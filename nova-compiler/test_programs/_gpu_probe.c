// Minimal OpenCL probe — dynamically loads OpenCL.dll (Windows ICD loader),
// enumerates platforms/devices, compiles and runs a vector-add kernel on the
// integrated GPU (Intel Iris Xe), verifies the output against the CPU answer.
// No OpenCL headers needed — we declare only the types/functions we call.
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
typedef HMODULE DynLib;
static DynLib dl_open(const char* name) { return LoadLibraryA(name); }
static void*  dl_sym(DynLib h, const char* sym) { return (void*)GetProcAddress(h, sym); }
#else
#include <dlfcn.h>
typedef void* DynLib;
static DynLib dl_open(const char* name) { return dlopen(name, RTLD_NOW); }
static void*  dl_sym(DynLib h, const char* sym) { return dlsym(h, sym); }
#endif

// Minimal OpenCL ABI declarations.
typedef int32_t  cl_int;
typedef uint32_t cl_uint;
typedef uint64_t cl_ulong;
typedef size_t   cl_size_t;
typedef intptr_t cl_intptr_t;

typedef void* cl_platform_id;
typedef void* cl_device_id;
typedef void* cl_context;
typedef void* cl_command_queue;
typedef void* cl_mem;
typedef void* cl_program;
typedef void* cl_kernel;
typedef void* cl_event;

typedef cl_intptr_t cl_context_properties;
typedef cl_intptr_t cl_queue_properties;
typedef cl_ulong cl_device_type;
typedef cl_ulong cl_mem_flags;

#define CL_DEVICE_TYPE_ALL  0xFFFFFFFFul
#define CL_DEVICE_TYPE_GPU  (1<<2)
#define CL_MEM_READ_ONLY    (1<<2)
#define CL_MEM_WRITE_ONLY   (1<<1)
#define CL_MEM_COPY_HOST_PTR (1<<5)
#define CL_TRUE 1
#define CL_DEVICE_NAME       0x102B
#define CL_DEVICE_VENDOR     0x102C
#define CL_PROGRAM_BUILD_LOG 0x1183

// cl_int clGetPlatformIDs(cl_uint num_entries, cl_platform_id* platforms, cl_uint* num_platforms);
typedef cl_int (*PFN_clGetPlatformIDs)(cl_uint, cl_platform_id*, cl_uint*);
typedef cl_int (*PFN_clGetDeviceIDs)(cl_platform_id, cl_device_type, cl_uint, cl_device_id*, cl_uint*);
typedef cl_int (*PFN_clGetDeviceInfo)(cl_device_id, cl_uint, size_t, void*, size_t*);
typedef cl_context (*PFN_clCreateContext)(const cl_context_properties*, cl_uint, const cl_device_id*, void*, void*, cl_int*);
typedef cl_command_queue (*PFN_clCreateCommandQueueWithProperties)(cl_context, cl_device_id, const cl_queue_properties*, cl_int*);
typedef cl_command_queue (*PFN_clCreateCommandQueue)(cl_context, cl_device_id, cl_ulong, cl_int*);
typedef cl_mem (*PFN_clCreateBuffer)(cl_context, cl_mem_flags, size_t, void*, cl_int*);
typedef cl_program (*PFN_clCreateProgramWithSource)(cl_context, cl_uint, const char**, const size_t*, cl_int*);
typedef cl_int (*PFN_clBuildProgram)(cl_program, cl_uint, const cl_device_id*, const char*, void*, void*);
typedef cl_int (*PFN_clGetProgramBuildInfo)(cl_program, cl_device_id, cl_uint, size_t, void*, size_t*);
typedef cl_kernel (*PFN_clCreateKernel)(cl_program, const char*, cl_int*);
typedef cl_int (*PFN_clSetKernelArg)(cl_kernel, cl_uint, size_t, const void*);
typedef cl_int (*PFN_clEnqueueNDRangeKernel)(cl_command_queue, cl_kernel, cl_uint, const size_t*, const size_t*, const size_t*, cl_uint, const cl_event*, cl_event*);
typedef cl_int (*PFN_clEnqueueReadBuffer)(cl_command_queue, cl_mem, cl_uint, size_t, size_t, void*, cl_uint, const cl_event*, cl_event*);
typedef cl_int (*PFN_clFinish)(cl_command_queue);
typedef cl_int (*PFN_clReleaseMemObject)(cl_mem);
typedef cl_int (*PFN_clReleaseKernel)(cl_kernel);
typedef cl_int (*PFN_clReleaseProgram)(cl_program);
typedef cl_int (*PFN_clReleaseCommandQueue)(cl_command_queue);
typedef cl_int (*PFN_clReleaseContext)(cl_context);

#define LOAD(h,n) n = (PFN_##n)dl_sym(h, #n); if(!n){fprintf(stderr,"missing sym: %s\n", #n); return 1;}

static const char* kernel_src =
"__kernel void vadd(__global const float* a, __global const float* b, __global float* c) {\n"
"  int i = get_global_id(0);\n"
"  c[i] = a[i] + b[i];\n"
"}\n";

int main(void) {
    PFN_clGetPlatformIDs clGetPlatformIDs;
    PFN_clGetDeviceIDs clGetDeviceIDs;
    PFN_clGetDeviceInfo clGetDeviceInfo;
    PFN_clCreateContext clCreateContext;
    PFN_clCreateCommandQueueWithProperties clCreateCommandQueueWithProperties;
    PFN_clCreateCommandQueue clCreateCommandQueue;
    PFN_clCreateBuffer clCreateBuffer;
    PFN_clCreateProgramWithSource clCreateProgramWithSource;
    PFN_clBuildProgram clBuildProgram;
    PFN_clGetProgramBuildInfo clGetProgramBuildInfo;
    PFN_clCreateKernel clCreateKernel;
    PFN_clSetKernelArg clSetKernelArg;
    PFN_clEnqueueNDRangeKernel clEnqueueNDRangeKernel;
    PFN_clEnqueueReadBuffer clEnqueueReadBuffer;
    PFN_clFinish clFinish;
    PFN_clReleaseMemObject clReleaseMemObject;
    PFN_clReleaseKernel clReleaseKernel;
    PFN_clReleaseProgram clReleaseProgram;
    PFN_clReleaseCommandQueue clReleaseCommandQueue;
    PFN_clReleaseContext clReleaseContext;

    DynLib h = dl_open("OpenCL.dll");
    if (!h) { fprintf(stderr, "FAIL: OpenCL.dll not loadable\n"); return 1; }

    LOAD(h, clGetPlatformIDs);
    LOAD(h, clGetDeviceIDs);
    LOAD(h, clGetDeviceInfo);
    LOAD(h, clCreateContext);
    LOAD(h, clCreateBuffer);
    LOAD(h, clCreateProgramWithSource);
    LOAD(h, clBuildProgram);
    LOAD(h, clGetProgramBuildInfo);
    LOAD(h, clCreateKernel);
    LOAD(h, clSetKernelArg);
    LOAD(h, clEnqueueNDRangeKernel);
    LOAD(h, clEnqueueReadBuffer);
    LOAD(h, clFinish);
    LOAD(h, clReleaseMemObject);
    LOAD(h, clReleaseKernel);
    LOAD(h, clReleaseProgram);
    LOAD(h, clReleaseCommandQueue);
    LOAD(h, clReleaseContext);
    // OpenCL 2.0+ has clCreateCommandQueueWithProperties; 1.x has clCreateCommandQueue.
    clCreateCommandQueueWithProperties = (PFN_clCreateCommandQueueWithProperties)dl_sym(h, "clCreateCommandQueueWithProperties");
    clCreateCommandQueue = (PFN_clCreateCommandQueue)dl_sym(h, "clCreateCommandQueue");

    cl_uint nplat = 0;
    cl_int err = clGetPlatformIDs(0, NULL, &nplat);
    if (err != 0 || nplat == 0) { fprintf(stderr, "FAIL: no OpenCL platforms (err=%d)\n", err); return 1; }
    cl_platform_id* plats = (cl_platform_id*)calloc(nplat, sizeof(cl_platform_id));
    clGetPlatformIDs(nplat, plats, NULL);

    cl_device_id device = NULL;
    for (cl_uint i = 0; i < nplat && !device; ++i) {
        cl_uint ndev = 0;
        if (clGetDeviceIDs(plats[i], CL_DEVICE_TYPE_GPU, 0, NULL, &ndev) == 0 && ndev > 0) {
            cl_device_id* devs = (cl_device_id*)calloc(ndev, sizeof(cl_device_id));
            clGetDeviceIDs(plats[i], CL_DEVICE_TYPE_GPU, ndev, devs, NULL);
            device = devs[0];
            char name[256] = {0}, vendor[256] = {0};
            clGetDeviceInfo(device, CL_DEVICE_NAME, sizeof(name), name, NULL);
            clGetDeviceInfo(device, CL_DEVICE_VENDOR, sizeof(vendor), vendor, NULL);
            printf("GPU: %s (%s)\n", name, vendor);
            free(devs);
        }
    }
    free(plats);
    if (!device) { fprintf(stderr, "FAIL: no GPU device found\n"); return 1; }

    cl_context ctx = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    if (err != 0) { fprintf(stderr, "FAIL: clCreateContext err=%d\n", err); return 1; }

    cl_command_queue q = NULL;
    if (clCreateCommandQueueWithProperties) {
        q = clCreateCommandQueueWithProperties(ctx, device, NULL, &err);
    }
    if (!q && clCreateCommandQueue) {
        q = clCreateCommandQueue(ctx, device, 0, &err);
    }
    if (!q) { fprintf(stderr, "FAIL: no command queue (err=%d)\n", err); return 1; }

    const int N = 1024;
    float* a = (float*)malloc(N * sizeof(float));
    float* b = (float*)malloc(N * sizeof(float));
    float* c = (float*)calloc(N, sizeof(float));
    for (int i = 0; i < N; ++i) { a[i] = (float)i; b[i] = (float)(2*i); }

    cl_mem dA = clCreateBuffer(ctx, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, N*sizeof(float), a, &err);
    cl_mem dB = clCreateBuffer(ctx, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, N*sizeof(float), b, &err);
    cl_mem dC = clCreateBuffer(ctx, CL_MEM_WRITE_ONLY, N*sizeof(float), NULL, &err);
    if (err != 0) { fprintf(stderr, "FAIL: clCreateBuffer err=%d\n", err); return 1; }

    size_t src_len = strlen(kernel_src);
    cl_program prog = clCreateProgramWithSource(ctx, 1, &kernel_src, &src_len, &err);
    if (err != 0) { fprintf(stderr, "FAIL: clCreateProgramWithSource err=%d\n", err); return 1; }

    err = clBuildProgram(prog, 1, &device, "", NULL, NULL);
    if (err != 0) {
        char log[4096] = {0};
        clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, sizeof(log), log, NULL);
        fprintf(stderr, "FAIL: clBuildProgram err=%d log=%s\n", err, log);
        return 1;
    }

    cl_kernel k = clCreateKernel(prog, "vadd", &err);
    if (err != 0) { fprintf(stderr, "FAIL: clCreateKernel err=%d\n", err); return 1; }

    clSetKernelArg(k, 0, sizeof(cl_mem), &dA);
    clSetKernelArg(k, 1, sizeof(cl_mem), &dB);
    clSetKernelArg(k, 2, sizeof(cl_mem), &dC);

    size_t global = N;
    err = clEnqueueNDRangeKernel(q, k, 1, NULL, &global, NULL, 0, NULL, NULL);
    if (err != 0) { fprintf(stderr, "FAIL: clEnqueueNDRangeKernel err=%d\n", err); return 1; }
    clFinish(q);
    err = clEnqueueReadBuffer(q, dC, CL_TRUE, 0, N*sizeof(float), c, 0, NULL, NULL);
    if (err != 0) { fprintf(stderr, "FAIL: clEnqueueReadBuffer err=%d\n", err); return 1; }

    int wrong = 0;
    for (int i = 0; i < N; ++i) {
        float expect = (float)(3*i);
        if (c[i] != expect) { wrong++; if (wrong < 5) fprintf(stderr, "wrong[%d]: got %f want %f\n", i, c[i], expect); }
    }
    if (wrong) { fprintf(stderr, "FAIL: %d/%d wrong\n", wrong, N); return 1; }
    printf("PASS: GPU computed vadd[0..%d] = a+b correctly (sample c[42]=%f expect=%f)\n", N, c[42], (float)(3*42));

    clReleaseKernel(k);
    clReleaseProgram(prog);
    clReleaseMemObject(dA);
    clReleaseMemObject(dB);
    clReleaseMemObject(dC);
    clReleaseCommandQueue(q);
    clReleaseContext(ctx);
    free(a); free(b); free(c);
    return 0;
}
