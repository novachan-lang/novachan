package nova

import nova.ir.*
import java.io.File

class GpuCodegen {

    data class GpuKernel(
        val name: String,
        val openclSource: String,
        val inputArrays: List<String>,
        val outputArray: String,
        val workSize: String
    )

    data class GpuProgram(
        val kernels: List<GpuKernel>,
        val hostLlvm: String,
        val openclSource: String
    )

    fun compile(sourceFile: File, outDir: File): Int {
        val source = sourceFile.readText()
        val fileName = sourceFile.name

        nova.error.DiagnosticPrinter.registerSource(fileName, source)

        val tokens = try {
            nova.lexer.Lexer(source, fileName).tokenize()
        } catch (e: Exception) {
            System.err.println("Lex error: ${e.message}")
            return 1
        }

        val parser = nova.parser.Parser(tokens)
        val program = parser.parse()
        if (parser.errors.isNotEmpty()) {
            parser.errors.forEach { System.err.println("Parse error: ${it.message}") }
            return 1
        }

        val inferResult = nova.types.TypeInferer().infer(program)
        if (inferResult.errors.isNotEmpty()) {
            inferResult.errors.forEach { System.err.println("Type error: ${it.message}") }
            return 1
        }

        val module = AstToIr(inferResult.nodeTypes).lower(program)
        val erased = IrErasure().erase(module)
        val refined = IrTypeRefiner().refine(erased)

        val kernels = extractKernels(refined)
        if (kernels.isEmpty()) {
            println("gpu: no parallelizable operations found")
            println("gpu: generating standard code with SIMD hints")
        }

        outDir.mkdirs()

        val llvm = LlvmCodegen().generate(refined)
        val hostLl = File(outDir, "host.ll")
        hostLl.writeText(llvm)

        if (kernels.isNotEmpty()) {
            val clSource = generateOpenCL(kernels)
            File(outDir, "kernels.cl").writeText(clSource)

            val gpuHostC = generateGpuHostC(kernels)
            File(outDir, "gpu_host.c").writeText(gpuHostC)

            println("gpu: extracted ${kernels.size} kernel(s)")
            for (k in kernels) {
                println("  kernel '${k.name}': work_size=${k.workSize}, inputs=${k.inputArrays}, output=${k.outputArray}")
            }
        }

        val runtimeC = File(outDir, "nova_runtime.c")
        val canonical = File("runtime/nova_runtime.c")
        if (canonical.exists()) runtimeC.writeText(canonical.readText())
        else {
            val proj = File("nova_runtime.c")
            if (proj.exists()) runtimeC.writeText(proj.readText())
        }

        println("gpu: output written to ${outDir.absolutePath}")
        println("  host.ll      — LLVM IR for host code")
        if (kernels.isNotEmpty()) {
            println("  kernels.cl   — OpenCL kernel source")
            println("  gpu_host.c   — GPU dispatch host code")
        }
        println("  nova_runtime.c")
        println()
        println("To compile (with OpenCL):")
        println("  clang -O2 gpu_host.c host.ll nova_runtime.c -o program -lOpenCL")
        println("To compile (CPU-only fallback):")
        println("  clang -O2 -DNOCL host.ll nova_runtime.c -o program")

        return 0
    }

    private fun extractKernels(module: IrModule): List<GpuKernel> {
        val kernels = mutableListOf<GpuKernel>()
        var kernelId = 0

        for (fn in module.functions) {
            for (block in fn.blocks) {
                for (inst in block.instructions) {
                    val kernel = tryExtractKernel(inst, fn, kernelId)
                    if (kernel != null) {
                        kernels.add(kernel)
                        kernelId++
                    }
                }
            }
        }
        return kernels
    }

    private fun tryExtractKernel(inst: IrInst, fn: IrFunction, id: Int): GpuKernel? {
        val name = when (inst) {
            is IrInst.CallDirect -> inst.funcName
            else -> return null
        }

        if (name == "nova_rt_list_map" || name == "nova_rt_parallel_map") {
            return GpuKernel(
                name = "kernel_map_$id",
                openclSource = generateMapKernel("kernel_map_$id"),
                inputArrays = listOf("input"),
                outputArray = "output",
                workSize = "n"
            )
        }

        if (name == "nova_rt_matmul" || name == "nova_rt_tensor_multiply") {
            return GpuKernel(
                name = "kernel_matmul_$id",
                openclSource = generateMatmulKernel("kernel_matmul_$id"),
                inputArrays = listOf("A", "B"),
                outputArray = "C",
                workSize = "rows * cols"
            )
        }

        return null
    }

    private fun generateMapKernel(name: String): String = """
__kernel void $name(
    __global const long* input,
    __global long* output,
    const int n,
    const long param
) {
    int gid = get_global_id(0);
    if (gid < n) {
        output[gid] = input[gid] * param;
    }
}
"""

    private fun generateMatmulKernel(name: String): String = """
__kernel void $name(
    __global const double* A,
    __global const double* B,
    __global double* C,
    const int M,
    const int N,
    const int K
) {
    int row = get_global_id(0);
    int col = get_global_id(1);
    if (row < M && col < N) {
        double sum = 0.0;
        for (int k = 0; k < K; k++) {
            sum += A[row * K + k] * B[k * N + col];
        }
        C[row * N + col] = sum;
    }
}
"""

    private fun generateOpenCL(kernels: List<GpuKernel>): String = buildString {
        appendLine("// NOVA GPU Kernels — Generated by nova --target gpu")
        appendLine("// Compile with: clang -O2 gpu_host.c host.ll nova_runtime.c -o program -lOpenCL")
        appendLine()
        for (k in kernels) {
            append(k.openclSource)
            appendLine()
        }
    }

    private fun generateGpuHostC(kernels: List<GpuKernel>): String = buildString {
        appendLine("""
// NOVA GPU Host — Generated by nova --target gpu
// Provides OpenCL dispatch with CPU fallback

#ifdef NOCL
// CPU-only mode: no OpenCL required
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void nova_gpu_init(void) {
    // no-op in CPU mode
}

void nova_gpu_map(long* input, long* output, int n, long param) {
    for (int i = 0; i < n; i++) {
        output[i] = input[i] * param;
    }
}

void nova_gpu_matmul(double* A, double* B, double* C, int M, int N, int K) {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            double sum = 0.0;
            for (int k = 0; k < K; k++) {
                sum += A[i * K + k] * B[k * N + j];
            }
            C[i * N + j] = sum;
        }
    }
}

void nova_gpu_cleanup(void) {}

#else
// OpenCL GPU mode
#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static cl_context gpu_ctx = NULL;
static cl_command_queue gpu_queue = NULL;
static cl_program gpu_program = NULL;
static int gpu_available = 0;

static const char* kernel_source =
""".trimIndent())

        // Embed kernel source as a C string
        for (k in kernels) {
            for (line in k.openclSource.lines()) {
                if (line.isNotBlank()) {
                    appendLine("    \"${line.replace("\\", "\\\\").replace("\"", "\\\"")}\\n\"")
                }
            }
        }
        appendLine("    ;")

        appendLine("""

void nova_gpu_init(void) {
    cl_platform_id platform;
    cl_device_id device;
    cl_int err;

    err = clGetPlatformIDs(1, &platform, NULL);
    if (err != CL_SUCCESS) { gpu_available = 0; return; }

    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
    if (err != CL_SUCCESS) {
        err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
        if (err != CL_SUCCESS) { gpu_available = 0; return; }
    }

    gpu_ctx = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    if (err != CL_SUCCESS) { gpu_available = 0; return; }

    gpu_queue = clCreateCommandQueue(gpu_ctx, device, 0, &err);
    if (err != CL_SUCCESS) { gpu_available = 0; return; }

    size_t src_len = strlen(kernel_source);
    gpu_program = clCreateProgramWithSource(gpu_ctx, 1, &kernel_source, &src_len, &err);
    if (err != CL_SUCCESS) { gpu_available = 0; return; }

    err = clBuildProgram(gpu_program, 1, &device, "-cl-fast-relaxed-math", NULL, NULL);
    if (err != CL_SUCCESS) {
        char log[4096];
        clGetProgramBuildInfo(gpu_program, device, CL_PROGRAM_BUILD_LOG, sizeof(log), log, NULL);
        fprintf(stderr, "GPU kernel build error: %s\n", log);
        gpu_available = 0;
        return;
    }

    gpu_available = 1;
}

void nova_gpu_map(long* input, long* output, int n, long param) {
    if (!gpu_available) {
        for (int i = 0; i < n; i++) output[i] = input[i] * param;
        return;
    }
    cl_int err;
    cl_kernel kernel = clCreateKernel(gpu_program, "${kernels.firstOrNull { "map" in it.name }?.name ?: "kernel_map_0"}", &err);
    if (err != CL_SUCCESS) {
        for (int i = 0; i < n; i++) output[i] = input[i] * param;
        return;
    }

    size_t buf_size = n * sizeof(long);
    cl_mem in_buf = clCreateBuffer(gpu_ctx, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, buf_size, input, &err);
    cl_mem out_buf = clCreateBuffer(gpu_ctx, CL_MEM_WRITE_ONLY, buf_size, NULL, &err);

    clSetKernelArg(kernel, 0, sizeof(cl_mem), &in_buf);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), &out_buf);
    clSetKernelArg(kernel, 2, sizeof(int), &n);
    clSetKernelArg(kernel, 3, sizeof(long), &param);

    size_t global_size = n;
    clEnqueueNDRangeKernel(gpu_queue, kernel, 1, NULL, &global_size, NULL, 0, NULL, NULL);
    clEnqueueReadBuffer(gpu_queue, out_buf, CL_TRUE, 0, buf_size, output, 0, NULL, NULL);

    clReleaseMemObject(in_buf);
    clReleaseMemObject(out_buf);
    clReleaseKernel(kernel);
}

void nova_gpu_matmul(double* A, double* B, double* C, int M, int N, int K) {
    if (!gpu_available) {
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++) {
                double s = 0;
                for (int k = 0; k < K; k++) s += A[i*K+k] * B[k*N+j];
                C[i*N+j] = s;
            }
        return;
    }
    cl_int err;
    cl_kernel kernel = clCreateKernel(gpu_program, "${kernels.firstOrNull { "matmul" in it.name }?.name ?: "kernel_matmul_0"}", &err);
    if (err != CL_SUCCESS) {
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++) {
                double s = 0;
                for (int k = 0; k < K; k++) s += A[i*K+k] * B[k*N+j];
                C[i*N+j] = s;
            }
        return;
    }

    cl_mem a_buf = clCreateBuffer(gpu_ctx, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, M*K*sizeof(double), A, &err);
    cl_mem b_buf = clCreateBuffer(gpu_ctx, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, K*N*sizeof(double), B, &err);
    cl_mem c_buf = clCreateBuffer(gpu_ctx, CL_MEM_WRITE_ONLY, M*N*sizeof(double), NULL, &err);

    clSetKernelArg(kernel, 0, sizeof(cl_mem), &a_buf);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), &b_buf);
    clSetKernelArg(kernel, 2, sizeof(cl_mem), &c_buf);
    clSetKernelArg(kernel, 3, sizeof(int), &M);
    clSetKernelArg(kernel, 4, sizeof(int), &N);
    clSetKernelArg(kernel, 5, sizeof(int), &K);

    size_t global[2] = { M, N };
    clEnqueueNDRangeKernel(gpu_queue, kernel, 2, NULL, global, NULL, 0, NULL, NULL);
    clEnqueueReadBuffer(gpu_queue, c_buf, CL_TRUE, 0, M*N*sizeof(double), C, 0, NULL, NULL);

    clReleaseMemObject(a_buf);
    clReleaseMemObject(b_buf);
    clReleaseMemObject(c_buf);
    clReleaseKernel(kernel);
}

void nova_gpu_cleanup(void) {
    if (gpu_program) clReleaseProgram(gpu_program);
    if (gpu_queue) clReleaseCommandQueue(gpu_queue);
    if (gpu_ctx) clReleaseContext(gpu_ctx);
}

#endif
""".trimIndent())
    }
}
