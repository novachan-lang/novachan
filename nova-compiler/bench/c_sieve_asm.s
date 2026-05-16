	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"gate5_sieve10m.c"
	.def	main;
	.scl	2;
	.type	32;
	.endef
	.text
	.globl	main                            # -- Begin function main
	.p2align	4
main:                                   # @main
.seh_proc main
# %bb.0:
	pushq	%rsi
	.seh_pushreg %rsi
	subq	$32, %rsp
	.seh_stackalloc 32
	.seh_endprologue
	movl	$10000001, %ecx                 # imm = 0x989681
	movl	$8, %edx
	callq	calloc
	movq	%rax, %rsi
	addq	$32, %rax
	movl	$2, %ecx
	movl	$40, %r8d
	movl	$16, %r9d
	xorl	%edx, %edx
	jmp	.LBB0_1
	.p2align	4
.LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	incq	%rcx
	addq	%r8, %rax
	addq	$16, %r8
	addq	$8, %r9
	cmpq	$10000001, %rcx                 # imm = 0x989681
	je	.LBB0_6
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	cmpq	$0, (%rsi,%rcx,8)
	jne	.LBB0_5
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
	incq	%rdx
	movq	%rcx, %r10
	imulq	%rcx, %r10
	cmpq	$10000000, %r10                 # imm = 0x989680
	ja	.LBB0_5
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	movq	%rax, %r11
	.p2align	4
.LBB0_4:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%r11)
	addq	%rcx, %r10
	addq	%r9, %r11
	cmpq	$10000001, %r10                 # imm = 0x989681
	jb	.LBB0_4
	jmp	.LBB0_5
.LBB0_6:
	leaq	"??_C@_0BI@PEIAFEGF@Primes?5up?5to?510M?3?5?$CFlld?6?$AA@"(%rip), %rcx
	callq	printf
	movq	%rsi, %rcx
	callq	free
	xorl	%eax, %eax
	.seh_startepilogue
	addq	$32, %rsp
	popq	%rsi
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
	.section	.rdata,"dr",discard,"??_C@_0BI@PEIAFEGF@Primes?5up?5to?510M?3?5?$CFlld?6?$AA@"
	.globl	"??_C@_0BI@PEIAFEGF@Primes?5up?5to?510M?3?5?$CFlld?6?$AA@" # @"??_C@_0BI@PEIAFEGF@Primes?5up?5to?510M?3?5?$CFlld?6?$AA@"
"??_C@_0BI@PEIAFEGF@Primes?5up?5to?510M?3?5?$CFlld?6?$AA@":
	.asciz	"Primes up to 10M: %lld\n"

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
