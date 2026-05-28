	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"bench_g5_matmul.c"
	.def	main;
	.scl	2;
	.type	32;
	.endef
	.globl	__xmm@00000003000000020000000100000000 # -- Begin function main
	.section	.rdata,"dr",discard,__xmm@00000003000000020000000100000000
	.p2align	4, 0x0
__xmm@00000003000000020000000100000000:
	.long	0                               # 0x0
	.long	1                               # 0x1
	.long	2                               # 0x2
	.long	3                               # 0x3
	.globl	__xmm@00000004000000040000000400000004
	.section	.rdata,"dr",discard,__xmm@00000004000000040000000400000004
	.p2align	4, 0x0
__xmm@00000004000000040000000400000004:
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.globl	__xmm@24924925249249252492492524924925
	.section	.rdata,"dr",discard,__xmm@24924925249249252492492524924925
	.p2align	4, 0x0
__xmm@24924925249249252492492524924925:
	.long	613566757                       # 0x24924925
	.long	613566757                       # 0x24924925
	.long	613566757                       # 0x24924925
	.long	613566757                       # 0x24924925
	.globl	__xmm@00000002000000020000000200000002
	.section	.rdata,"dr",discard,__xmm@00000002000000020000000200000002
	.p2align	4, 0x0
__xmm@00000002000000020000000200000002:
	.long	2                               # 0x2
	.long	2                               # 0x2
	.long	2                               # 0x2
	.long	2                               # 0x2
	.globl	__xmm@00000008000000080000000800000008
	.section	.rdata,"dr",discard,__xmm@00000008000000080000000800000008
	.p2align	4, 0x0
__xmm@00000008000000080000000800000008:
	.long	8                               # 0x8
	.long	8                               # 0x8
	.long	8                               # 0x8
	.long	8                               # 0x8
	.text
	.globl	main
	.p2align	4
main:                                   # @main
.seh_proc main
# %bb.0:
	pushq	%r15
	.seh_pushreg %r15
	pushq	%r14
	.seh_pushreg %r14
	pushq	%r13
	.seh_pushreg %r13
	pushq	%r12
	.seh_pushreg %r12
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$104, %rsp
	.seh_stackalloc 104
	movdqa	%xmm9, 80(%rsp)                 # 16-byte Spill
	.seh_savexmm %xmm9, 80
	movdqa	%xmm8, 64(%rsp)                 # 16-byte Spill
	.seh_savexmm %xmm8, 64
	movdqa	%xmm7, 48(%rsp)                 # 16-byte Spill
	.seh_savexmm %xmm7, 48
	movdqa	%xmm6, 32(%rsp)                 # 16-byte Spill
	.seh_savexmm %xmm6, 32
	.seh_endprologue
	movl	$360000, %ecx                   # imm = 0x57E40
	callq	malloc
	movq	%rax, %rsi
	movl	$360000, %ecx                   # imm = 0x57E40
	callq	malloc
	movq	%rax, %rdi
	movl	$4, %r14d
	movl	$90000, %ecx                    # imm = 0x15F90
	movl	$4, %edx
	callq	calloc
	movq	%rax, %rbx
	movdqa	__xmm@00000003000000020000000100000000(%rip), %xmm0 # xmm0 = [0,1,2,3]
	movdqa	__xmm@00000004000000040000000400000004(%rip), %xmm1 # xmm1 = [4,4,4,4]
	movdqa	__xmm@24924925249249252492492524924925(%rip), %xmm2 # xmm2 = [613566757,613566757,613566757,613566757]
	pcmpeqd	%xmm3, %xmm3
	movdqa	__xmm@00000002000000020000000200000002(%rip), %xmm4 # xmm4 = [2,2,2,2]
	movdqa	__xmm@00000008000000080000000800000008(%rip), %xmm5 # xmm5 = [8,8,8,8]
	.p2align	4
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movdqa	%xmm0, %xmm6
	paddd	%xmm1, %xmm6
	movdqa	%xmm0, %xmm7
	pmuludq	%xmm2, %xmm7
	pshufd	$237, %xmm7, %xmm8              # xmm8 = xmm7[1,3,2,3]
	pshufd	$245, %xmm0, %xmm7              # xmm7 = xmm0[1,1,3,3]
	pmuludq	%xmm2, %xmm7
	pshufd	$237, %xmm7, %xmm7              # xmm7 = xmm7[1,3,2,3]
	punpckldq	%xmm7, %xmm8            # xmm8 = xmm8[0],xmm7[0],xmm8[1],xmm7[1]
	movdqa	%xmm0, %xmm7
	psubd	%xmm8, %xmm7
	psrld	$1, %xmm7
	paddd	%xmm8, %xmm7
	psrld	$2, %xmm7
	movdqa	%xmm7, %xmm8
	pslld	$3, %xmm8
	psubd	%xmm8, %xmm7
	paddd	%xmm0, %xmm7
	movdqa	%xmm6, %xmm8
	pmuludq	%xmm2, %xmm8
	pshufd	$237, %xmm8, %xmm8              # xmm8 = xmm8[1,3,2,3]
	pshufd	$245, %xmm6, %xmm9              # xmm9 = xmm6[1,1,3,3]
	pmuludq	%xmm2, %xmm9
	pshufd	$237, %xmm9, %xmm9              # xmm9 = xmm9[1,3,2,3]
	punpckldq	%xmm9, %xmm8            # xmm8 = xmm8[0],xmm9[0],xmm8[1],xmm9[1]
	movdqa	%xmm6, %xmm9
	psubd	%xmm8, %xmm9
	psrld	$1, %xmm9
	paddd	%xmm8, %xmm9
	psrld	$2, %xmm9
	movdqa	%xmm9, %xmm8
	pslld	$3, %xmm8
	psubd	%xmm8, %xmm9
	paddd	%xmm6, %xmm9
	movdqa	%xmm7, %xmm6
	psubd	%xmm3, %xmm6
	movdqa	%xmm9, %xmm8
	psubd	%xmm3, %xmm8
	movdqu	%xmm6, -16(%rsi,%r14,4)
	movdqu	%xmm8, (%rsi,%r14,4)
	paddd	%xmm4, %xmm7
	paddd	%xmm4, %xmm9
	movdqu	%xmm7, -16(%rdi,%r14,4)
	movdqu	%xmm9, (%rdi,%r14,4)
	paddd	%xmm5, %xmm0
	addq	$8, %r14
	cmpq	$90004, %r14                    # imm = 0x15F94
	jne	.LBB0_1
# %bb.2:
	xorl	%eax, %eax
	movq	%rsi, %rcx
	.p2align	4
.LBB0_3:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
                                        #       Child Loop BB0_5 Depth 3
	imulq	$1200, %rax, %r11               # imm = 0x4B0
	leaq	(%rbx,%r11), %rdx
	movl	1184(%rsi,%r11), %r8d
	movl	1188(%rsi,%r11), %r9d
	movl	1192(%rsi,%r11), %r10d
	movl	1196(%rsi,%r11), %r11d
	movq	%rdi, %r14
	xorl	%r15d, %r15d
	.p2align	4
.LBB0_4:                                #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
	pxor	%xmm0, %xmm0
	movl	$4, %r12d
	movq	%r14, %r13
	pxor	%xmm1, %xmm1
	.p2align	4
.LBB0_5:                                #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movdqu	-16(%rcx,%r12,4), %xmm3
	movdqu	(%rcx,%r12,4), %xmm2
	movd	3600(%r13), %xmm4               # xmm4 = mem[0],zero,zero,zero
	movd	2400(%r13), %xmm5               # xmm5 = mem[0],zero,zero,zero
	punpckldq	%xmm4, %xmm5            # xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
	movd	1200(%r13), %xmm4               # xmm4 = mem[0],zero,zero,zero
	movd	(%r13), %xmm6                   # xmm6 = mem[0],zero,zero,zero
	punpckldq	%xmm4, %xmm6            # xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
	punpcklqdq	%xmm5, %xmm6            # xmm6 = xmm6[0],xmm5[0]
	movd	8400(%r13), %xmm4               # xmm4 = mem[0],zero,zero,zero
	movd	7200(%r13), %xmm5               # xmm5 = mem[0],zero,zero,zero
	punpckldq	%xmm4, %xmm5            # xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
	movd	6000(%r13), %xmm4               # xmm4 = mem[0],zero,zero,zero
	movd	4800(%r13), %xmm7               # xmm7 = mem[0],zero,zero,zero
	punpckldq	%xmm4, %xmm7            # xmm7 = xmm7[0],xmm4[0],xmm7[1],xmm4[1]
	punpcklqdq	%xmm5, %xmm7            # xmm7 = xmm7[0],xmm5[0]
	pshufd	$245, %xmm6, %xmm4              # xmm4 = xmm6[1,1,3,3]
	pmuludq	%xmm3, %xmm6
	pshufd	$232, %xmm6, %xmm5              # xmm5 = xmm6[0,2,2,3]
	pshufd	$245, %xmm3, %xmm3              # xmm3 = xmm3[1,1,3,3]
	pmuludq	%xmm4, %xmm3
	pshufd	$232, %xmm3, %xmm3              # xmm3 = xmm3[0,2,2,3]
	punpckldq	%xmm3, %xmm5            # xmm5 = xmm5[0],xmm3[0],xmm5[1],xmm3[1]
	paddd	%xmm5, %xmm1
	pshufd	$245, %xmm7, %xmm3              # xmm3 = xmm7[1,1,3,3]
	pmuludq	%xmm2, %xmm7
	pshufd	$232, %xmm7, %xmm4              # xmm4 = xmm7[0,2,2,3]
	pshufd	$245, %xmm2, %xmm2              # xmm2 = xmm2[1,1,3,3]
	pmuludq	%xmm3, %xmm2
	pshufd	$232, %xmm2, %xmm2              # xmm2 = xmm2[0,2,2,3]
	punpckldq	%xmm2, %xmm4            # xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
	paddd	%xmm4, %xmm0
	addq	$9600, %r13                     # imm = 0x2580
	addq	$8, %r12
	cmpq	$300, %r12                      # imm = 0x12C
	jne	.LBB0_5
# %bb.6:                                #   in Loop: Header=BB0_4 Depth=2
	paddd	%xmm1, %xmm0
	pshufd	$238, %xmm0, %xmm1              # xmm1 = xmm0[2,3,2,3]
	paddd	%xmm0, %xmm1
	pshufd	$85, %xmm1, %xmm0               # xmm0 = xmm1[1,1,1,1]
	paddd	%xmm1, %xmm0
	movd	%xmm0, %ebp
	movl	355200(%rdi,%r15,4), %r12d
	imull	%r8d, %r12d
	movl	356400(%rdi,%r15,4), %r13d
	imull	%r9d, %r13d
	addl	%r12d, %r13d
	movl	357600(%rdi,%r15,4), %r12d
	imull	%r10d, %r12d
	addl	%r13d, %r12d
	movl	358800(%rdi,%r15,4), %r13d
	imull	%r11d, %r13d
	addl	%r12d, %r13d
	addl	%ebp, %r13d
	movl	%r13d, (%rdx,%r15,4)
	incq	%r15
	addq	$4, %r14
	cmpq	$300, %r15                      # imm = 0x12C
	jne	.LBB0_4
# %bb.7:                                #   in Loop: Header=BB0_3 Depth=1
	incq	%rax
	addq	$1200, %rcx                     # imm = 0x4B0
	cmpq	$300, %rax                      # imm = 0x12C
	jne	.LBB0_3
# %bb.8:
	pxor	%xmm0, %xmm0
	movl	$36, %eax
	pxor	%xmm1, %xmm1
	.p2align	4
.LBB0_9:                                # =>This Inner Loop Header: Depth=1
	movdqu	-144(%rbx,%rax,4), %xmm2
	paddd	%xmm1, %xmm2
	movdqu	-128(%rbx,%rax,4), %xmm1
	paddd	%xmm0, %xmm1
	movdqu	-112(%rbx,%rax,4), %xmm0
	movdqu	-96(%rbx,%rax,4), %xmm3
	movdqu	-80(%rbx,%rax,4), %xmm4
	paddd	%xmm0, %xmm4
	paddd	%xmm2, %xmm4
	movdqu	-64(%rbx,%rax,4), %xmm2
	paddd	%xmm3, %xmm2
	paddd	%xmm1, %xmm2
	movdqu	-48(%rbx,%rax,4), %xmm0
	movdqu	-32(%rbx,%rax,4), %xmm3
	movdqu	-16(%rbx,%rax,4), %xmm1
	paddd	%xmm0, %xmm1
	paddd	%xmm4, %xmm1
	movdqu	(%rbx,%rax,4), %xmm0
	paddd	%xmm3, %xmm0
	paddd	%xmm2, %xmm0
	addq	$40, %rax
	cmpq	$90036, %rax                    # imm = 0x15FB4
	jne	.LBB0_9
# %bb.10:
	paddd	%xmm1, %xmm0
	pshufd	$238, %xmm0, %xmm1              # xmm1 = xmm0[2,3,2,3]
	paddd	%xmm0, %xmm1
	pshufd	$85, %xmm1, %xmm0               # xmm0 = xmm1[1,1,1,1]
	paddd	%xmm1, %xmm0
	movd	%xmm0, %edx
	leaq	"??_C@_0BO@KCENKOFD@Matmul?5300x300?5checksum?3?5?$CFld?6?$AA@"(%rip), %rcx
	callq	printf
	movq	%rsi, %rcx
	callq	free
	movq	%rdi, %rcx
	callq	free
	movq	%rbx, %rcx
	callq	free
	xorl	%eax, %eax
	movaps	32(%rsp), %xmm6                 # 16-byte Reload
	movaps	48(%rsp), %xmm7                 # 16-byte Reload
	movaps	64(%rsp), %xmm8                 # 16-byte Reload
	movaps	80(%rsp), %xmm9                 # 16-byte Reload
	.seh_startepilogue
	addq	$104, %rsp
	popq	%rbx
	popq	%rbp
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
	.seh_endproc
                                        # -- End function
	.def	printf;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",discard,printf
	.globl	printf                          # -- Begin function printf
	.p2align	4
printf:                                 # @printf
.seh_proc printf
# %bb.0:
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$48, %rsp
	.seh_stackalloc 48
	.seh_endprologue
	movq	%rcx, %rsi
	movq	%rdx, 88(%rsp)
	movq	%r8, 96(%rsp)
	movq	%r9, 104(%rsp)
	leaq	88(%rsp), %rbx
	movq	%rbx, 40(%rsp)
	movl	$1, %ecx
	callq	__acrt_iob_func
	movq	%rax, %rdi
	callq	__local_stdio_printf_options
	movq	(%rax), %rcx
	movq	%rbx, 32(%rsp)
	movq	%rdi, %rdx
	movq	%rsi, %r8
	xorl	%r9d, %r9d
	callq	__stdio_common_vfprintf
	nop
	.seh_startepilogue
	addq	$48, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
	.seh_endproc
                                        # -- End function
	.def	__local_stdio_printf_options;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",discard,__local_stdio_printf_options
	.globl	__local_stdio_printf_options    # -- Begin function __local_stdio_printf_options
	.p2align	4
__local_stdio_printf_options:           # @__local_stdio_printf_options
# %bb.0:
	leaq	__local_stdio_printf_options._OptionsStorage(%rip), %rax
	retq
                                        # -- End function
	.section	.rdata,"dr",discard,"??_C@_0BO@KCENKOFD@Matmul?5300x300?5checksum?3?5?$CFld?6?$AA@"
	.globl	"??_C@_0BO@KCENKOFD@Matmul?5300x300?5checksum?3?5?$CFld?6?$AA@" # @"??_C@_0BO@KCENKOFD@Matmul?5300x300?5checksum?3?5?$CFld?6?$AA@"
"??_C@_0BO@KCENKOFD@Matmul?5300x300?5checksum?3?5?$CFld?6?$AA@":
	.asciz	"Matmul 300x300 checksum: %ld\n"

	.lcomm	__local_stdio_printf_options._OptionsStorage,8,8 # @__local_stdio_printf_options._OptionsStorage
	.section	.debug$S,"dr"
	.p2align	2, 0x0
	.long	4                               # Debug section magic
	.long	241
	.long	.Ltmp1-.Ltmp0                   # Subsection size
.Ltmp0:
	.short	.Ltmp3-.Ltmp2                   # Record length
.Ltmp2:
	.short	4353                            # Record kind: S_OBJNAME
	.long	0                               # Signature
	.byte	0                               # Object name
	.p2align	2, 0x0
.Ltmp3:
	.short	.Ltmp5-.Ltmp4                   # Record length
.Ltmp4:
	.short	4412                            # Record kind: S_COMPILE3
	.long	0                               # Flags and language
	.short	208                             # CPUType
	.short	22                              # Frontend version
	.short	1
	.short	0
	.short	0
	.short	22010                           # Backend version
	.short	0
	.short	0
	.short	0
	.asciz	"clang version 22.1.0 (https://github.com/llvm/llvm-project 4434dabb69916856b824f68a64b029c67175e532)" # Null-terminated compiler version string
	.p2align	2, 0x0
.Ltmp5:
.Ltmp1:
	.p2align	2, 0x0
	.addrsig
	.addrsig_sym __local_stdio_printf_options._OptionsStorage
