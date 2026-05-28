	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"bench_g5_matmul_i64.c"
	.def	main;
	.scl	2;
	.type	32;
	.endef
	.globl	__xmm@00000000000000000000000100000000 # -- Begin function main
	.section	.rdata,"dr",discard,__xmm@00000000000000000000000100000000
	.p2align	4, 0x0
__xmm@00000000000000000000000100000000:
	.long	0                               # 0x0
	.long	1                               # 0x1
	.zero	4
	.zero	4
	.globl	__xmm@00000000000000000000000200000002
	.section	.rdata,"dr",discard,__xmm@00000000000000000000000200000002
	.p2align	4, 0x0
__xmm@00000000000000000000000200000002:
	.long	2                               # 0x2
	.long	2                               # 0x2
	.zero	4
	.zero	4
	.globl	__xmm@24924925249249252492492524924925
	.section	.rdata,"dr",discard,__xmm@24924925249249252492492524924925
	.p2align	4, 0x0
__xmm@24924925249249252492492524924925:
	.long	613566757                       # 0x24924925
	.long	613566757                       # 0x24924925
	.long	613566757                       # 0x24924925
	.long	613566757                       # 0x24924925
	.globl	__xmm@00000000000000000000000400000004
	.section	.rdata,"dr",discard,__xmm@00000000000000000000000400000004
	.p2align	4, 0x0
__xmm@00000000000000000000000400000004:
	.long	4                               # 0x4
	.long	4                               # 0x4
	.zero	4
	.zero	4
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
	pushq	%r12
	.seh_pushreg %r12
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
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
	movl	$720000, %ecx                   # imm = 0xAFC80
	callq	malloc
	movq	%rax, %rsi
	movl	$720000, %ecx                   # imm = 0xAFC80
	callq	malloc
	movq	%rax, %rdi
	movl	$90000, %ecx                    # imm = 0x15F90
	movl	$8, %edx
	callq	calloc
	movq	%rax, %rbx
	movq	__xmm@00000000000000000000000100000000(%rip), %xmm0 # xmm0 = [0,1,0,0]
	movl	$2, %eax
	movdqa	__xmm@00000000000000000000000200000002(%rip), %xmm1 # xmm1 = [2,2,u,u]
	movdqa	__xmm@24924925249249252492492524924925(%rip), %xmm2 # xmm2 = [613566757,613566757,613566757,613566757]
	pcmpeqd	%xmm3, %xmm3
	pxor	%xmm4, %xmm4
	movdqa	__xmm@00000000000000000000000400000004(%rip), %xmm5 # xmm5 = [4,4,u,u]
	.p2align	4
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movdqa	%xmm0, %xmm7
	paddd	%xmm1, %xmm7
	movdqa	%xmm0, %xmm6
	pmuludq	%xmm2, %xmm6
	pshufd	$237, %xmm6, %xmm8              # xmm8 = xmm6[1,3,2,3]
	pshufd	$245, %xmm0, %xmm6              # xmm6 = xmm0[1,1,3,3]
	pmuludq	%xmm2, %xmm6
	pshufd	$237, %xmm6, %xmm6              # xmm6 = xmm6[1,3,2,3]
	punpckldq	%xmm6, %xmm8            # xmm8 = xmm8[0],xmm6[0],xmm8[1],xmm6[1]
	movdqa	%xmm0, %xmm6
	psubd	%xmm8, %xmm6
	psrld	$1, %xmm6
	paddd	%xmm8, %xmm6
	psrld	$2, %xmm6
	movdqa	%xmm6, %xmm8
	pslld	$3, %xmm8
	psubd	%xmm8, %xmm6
	paddd	%xmm0, %xmm6
	movdqa	%xmm7, %xmm8
	pmuludq	%xmm2, %xmm8
	pshufd	$237, %xmm8, %xmm9              # xmm9 = xmm8[1,3,2,3]
	pshufd	$245, %xmm7, %xmm8              # xmm8 = xmm7[1,1,3,3]
	pmuludq	%xmm2, %xmm8
	pshufd	$237, %xmm8, %xmm8              # xmm8 = xmm8[1,3,2,3]
	punpckldq	%xmm8, %xmm9            # xmm9 = xmm9[0],xmm8[0],xmm9[1],xmm8[1]
	movdqa	%xmm7, %xmm8
	psubd	%xmm9, %xmm8
	psrld	$1, %xmm8
	paddd	%xmm9, %xmm8
	psrld	$2, %xmm8
	movdqa	%xmm8, %xmm9
	pslld	$3, %xmm9
	psubd	%xmm9, %xmm8
	paddd	%xmm7, %xmm8
	movdqa	%xmm6, %xmm7
	psubd	%xmm3, %xmm7
	movdqa	%xmm8, %xmm9
	psubd	%xmm3, %xmm9
	punpckldq	%xmm4, %xmm7            # xmm7 = xmm7[0],xmm4[0],xmm7[1],xmm4[1]
	punpckldq	%xmm4, %xmm9            # xmm9 = xmm9[0],xmm4[0],xmm9[1],xmm4[1]
	movdqu	%xmm7, -16(%rsi,%rax,8)
	movdqu	%xmm9, (%rsi,%rax,8)
	paddd	%xmm1, %xmm6
	paddd	%xmm1, %xmm8
	punpckldq	%xmm4, %xmm6            # xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
	punpckldq	%xmm4, %xmm8            # xmm8 = xmm8[0],xmm4[0],xmm8[1],xmm4[1]
	movdqu	%xmm6, -16(%rdi,%rax,8)
	movdqu	%xmm8, (%rdi,%rax,8)
	paddd	%xmm5, %xmm0
	addq	$4, %rax
	cmpq	$90002, %rax                    # imm = 0x15F92
	jne	.LBB0_1
# %bb.2:
	xorl	%eax, %eax
	movq	%rsi, %rcx
	.p2align	4
.LBB0_3:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
                                        #       Child Loop BB0_5 Depth 3
	imulq	$2400, %rax, %rdx               # imm = 0x960
	addq	%rbx, %rdx
	movq	%rdi, %r8
	xorl	%r9d, %r9d
	.p2align	4
.LBB0_4:                                #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
	movl	$3, %r10d
	movq	%r8, %r11
	xorl	%r14d, %r14d
	.p2align	4
.LBB0_5:                                #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	(%r11), %r15
	imulq	-24(%rcx,%r10,8), %r15
	addq	%r14, %r15
	movq	2400(%r11), %r14
	imulq	-16(%rcx,%r10,8), %r14
	movq	4800(%r11), %r12
	imulq	-8(%rcx,%r10,8), %r12
	addq	%r14, %r12
	addq	%r15, %r12
	movq	7200(%r11), %r14
	imulq	(%rcx,%r10,8), %r14
	addq	%r12, %r14
	addq	$4, %r10
	addq	$9600, %r11                     # imm = 0x2580
	cmpq	$303, %r10                      # imm = 0x12F
	jne	.LBB0_5
# %bb.6:                                #   in Loop: Header=BB0_4 Depth=2
	movq	%r14, (%rdx,%r9,8)
	incq	%r9
	addq	$8, %r8
	cmpq	$300, %r9                       # imm = 0x12C
	jne	.LBB0_4
# %bb.7:                                #   in Loop: Header=BB0_3 Depth=1
	incq	%rax
	addq	$2400, %rcx                     # imm = 0x960
	cmpq	$300, %rax                      # imm = 0x12C
	jne	.LBB0_3
# %bb.8:
	pxor	%xmm0, %xmm0
	movl	$18, %eax
	pxor	%xmm1, %xmm1
	.p2align	4
.LBB0_9:                                # =>This Inner Loop Header: Depth=1
	movdqu	-144(%rbx,%rax,8), %xmm2
	paddq	%xmm1, %xmm2
	movdqu	-128(%rbx,%rax,8), %xmm1
	paddq	%xmm0, %xmm1
	movdqu	-112(%rbx,%rax,8), %xmm0
	movdqu	-96(%rbx,%rax,8), %xmm3
	movdqu	-80(%rbx,%rax,8), %xmm4
	paddq	%xmm0, %xmm4
	paddq	%xmm2, %xmm4
	movdqu	-64(%rbx,%rax,8), %xmm2
	paddq	%xmm3, %xmm2
	paddq	%xmm1, %xmm2
	movdqu	-48(%rbx,%rax,8), %xmm0
	movdqu	-32(%rbx,%rax,8), %xmm3
	movdqu	-16(%rbx,%rax,8), %xmm1
	paddq	%xmm0, %xmm1
	paddq	%xmm4, %xmm1
	movdqu	(%rbx,%rax,8), %xmm0
	paddq	%xmm3, %xmm0
	paddq	%xmm2, %xmm0
	addq	$20, %rax
	cmpq	$90018, %rax                    # imm = 0x15FA2
	jne	.LBB0_9
# %bb.10:
	paddq	%xmm1, %xmm0
	pshufd	$238, %xmm0, %xmm1              # xmm1 = xmm0[2,3,2,3]
	paddq	%xmm0, %xmm1
	movq	%xmm1, %rdx
	leaq	"??_C@_0BP@IPNCGLKP@Matmul?5300x300?5checksum?3?5?$CFlld?6?$AA@"(%rip), %rcx
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
	popq	%rdi
	popq	%rsi
	popq	%r12
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
	.section	.rdata,"dr",discard,"??_C@_0BP@IPNCGLKP@Matmul?5300x300?5checksum?3?5?$CFlld?6?$AA@"
	.globl	"??_C@_0BP@IPNCGLKP@Matmul?5300x300?5checksum?3?5?$CFlld?6?$AA@" # @"??_C@_0BP@IPNCGLKP@Matmul?5300x300?5checksum?3?5?$CFlld?6?$AA@"
"??_C@_0BP@IPNCGLKP@Matmul?5300x300?5checksum?3?5?$CFlld?6?$AA@":
	.asciz	"Matmul 300x300 checksum: %lld\n"

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
