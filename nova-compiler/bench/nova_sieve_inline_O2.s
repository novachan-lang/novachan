	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"gate4_nova_sieve.ll"
	.def	count_primes;
	.scl	2;
	.type	32;
	.endef
	.text
	.globl	count_primes                    # -- Begin function count_primes
	.p2align	4
count_primes:                           # @count_primes
.seh_proc count_primes
# %bb.0:                                # %entry0
	pushq	%r15
	.seh_pushreg %r15
	pushq	%r14
	.seh_pushreg %r14
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$32, %rsp
	.seh_stackalloc 32
	.seh_endprologue
	movq	%rcx, %rsi
	callq	nova_rt_list_create
	testq	%rsi, %rsi
	js	.LBB0_7
# %bb.1:                                # %while_body2.lr.ph
	movq	%rax, %rdi
	movq	(%rax), %rax
	movq	8(%rdi), %rbx
	xorl	%r14d, %r14d
	jmp	.LBB0_3
	.p2align	4
.LBB0_2:                                # %list_append_7
                                        #   in Loop: Header=BB0_3 Depth=1
	movq	$0, (%rax,%rbx,8)
	incq	%rbx
	movq	%rbx, 8(%rdi)
	incq	%r14
	cmpq	%rsi, %r14
	jg	.LBB0_5
.LBB0_3:                                # %while_body2
                                        # =>This Inner Loop Header: Depth=1
	movq	16(%rdi), %rdx
	cmpq	%rdx, %rbx
	jl	.LBB0_2
# %bb.4:                                # %list_grow_7
                                        #   in Loop: Header=BB0_3 Depth=1
	leaq	(%rdx,%rdx), %r15
	shlq	$4, %rdx
	movq	%rax, %rcx
	callq	realloc
	movq	%rax, (%rdi)
	movq	%r15, 16(%rdi)
	jmp	.LBB0_2
.LBB0_5:                                # %while_header4.preheader
	cmpq	$2, %rsi
	jge	.LBB0_9
.LBB0_7:
	xorl	%eax, %eax
.LBB0_8:                                # %while_exit6
	.seh_startepilogue
	addq	$32, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
.LBB0_9:                                # %while_body5.lr.ph
	movq	(%rdi), %rcx
	leaq	32(%rcx), %rdx
	movl	$2, %r8d
	movl	$40, %r9d
	movl	$16, %r10d
	xorl	%eax, %eax
	jmp	.LBB0_11
	.p2align	4
.LBB0_10:                               # %ifb_merge9
                                        #   in Loop: Header=BB0_11 Depth=1
	incq	%r8
	addq	%r9, %rdx
	addq	$16, %r9
	addq	$8, %r10
	cmpq	%rsi, %r8
	jg	.LBB0_8
.LBB0_11:                               # %while_body5
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_13 Depth 2
	cmpq	$0, (%rcx,%r8,8)
	jne	.LBB0_10
# %bb.12:                               # %ifb_then7
                                        #   in Loop: Header=BB0_11 Depth=1
	incq	%rax
	movq	%r8, %r11
	imulq	%r8, %r11
	movq	%rdx, %rdi
	cmpq	%rsi, %r11
	jg	.LBB0_10
	.p2align	4
.LBB0_13:                               # %while_body11
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%rdi)
	addq	%r8, %r11
	addq	%r10, %rdi
	cmpq	%rsi, %r11
	jle	.LBB0_13
	jmp	.LBB0_10
	.seh_endproc
                                        # -- End function
	.def	nova_main;
	.scl	2;
	.type	32;
	.endef
	.globl	nova_main                       # -- Begin function nova_main
	.p2align	4
nova_main:                              # @nova_main
.seh_proc nova_main
# %bb.0:                                # %entry0
	pushq	%r14
	.seh_pushreg %r14
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	callq	nova_rt_list_create
	movq	%rax, %rsi
	movq	(%rax), %rax
	movq	8(%rsi), %rdi
	movl	$1000001, %ebx                  # imm = 0xF4241
	jmp	.LBB1_1
	.p2align	4
.LBB1_3:                                # %list_append_7.i
                                        #   in Loop: Header=BB1_1 Depth=1
	movq	$0, (%rax,%rdi,8)
	incq	%rdi
	movq	%rdi, 8(%rsi)
	decq	%rbx
	je	.LBB1_4
.LBB1_1:                                # %while_body2.i
                                        # =>This Inner Loop Header: Depth=1
	movq	16(%rsi), %rdx
	cmpq	%rdx, %rdi
	jl	.LBB1_3
# %bb.2:                                # %list_grow_7.i
                                        #   in Loop: Header=BB1_1 Depth=1
	leaq	(%rdx,%rdx), %r14
	shlq	$4, %rdx
	movq	%rax, %rcx
	callq	realloc
	movq	%rax, (%rsi)
	movq	%r14, 16(%rsi)
	jmp	.LBB1_3
.LBB1_4:                                # %while_body5.i.preheader
	leaq	32(%rax), %rdx
	movl	$2, %r8d
	movl	$40, %r9d
	movl	$16, %r10d
	xorl	%ecx, %ecx
	jmp	.LBB1_5
	.p2align	4
.LBB1_8:                                # %ifb_merge9.i
                                        #   in Loop: Header=BB1_5 Depth=1
	incq	%r8
	addq	%r9, %rdx
	addq	$16, %r9
	addq	$8, %r10
	cmpq	$1000001, %r8                   # imm = 0xF4241
	je	.LBB1_9
.LBB1_5:                                # %while_body5.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_10 Depth 2
	cmpq	$0, (%rax,%r8,8)
	jne	.LBB1_8
# %bb.6:                                # %ifb_then7.i
                                        #   in Loop: Header=BB1_5 Depth=1
	incq	%rcx
	movq	%r8, %r11
	imulq	%r8, %r11
	movq	%rdx, %rsi
	cmpq	$1000000, %r11                  # imm = 0xF4240
	jg	.LBB1_8
	.p2align	4
.LBB1_10:                               # %while_body11.i
                                        #   Parent Loop BB1_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%rsi)
	addq	%r8, %r11
	addq	%r10, %rsi
	cmpq	$1000000, %r11                  # imm = 0xF4240
	jle	.LBB1_10
	jmp	.LBB1_8
.LBB1_9:                                # %count_primes.exit
	movq	%rcx, __nova_g_result(%rip)
	callq	nova_rt_int_to_str
	leaq	.L.str.0(%rip), %rcx
	movq	%rax, %rdx
	callq	nova_rt_str_concat
	movq	%rax, %rcx
	callq	puts
	xorl	%eax, %eax
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r14
	.seh_endepilogue
	retq
	.seh_endproc
                                        # -- End function
	.def	main;
	.scl	2;
	.type	32;
	.endef
	.globl	main                            # -- Begin function main
	.p2align	4
main:                                   # @main
.seh_proc main
# %bb.0:                                # %entry
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	callq	nova_main
	callq	nova_rt_wait_all
	callq	nova_rt_cleanup
	xorl	%eax, %eax
	.seh_startepilogue
	addq	$40, %rsp
	.seh_endepilogue
	retq
	.seh_endproc
                                        # -- End function
	.bss
	.globl	__nova_error_flag               # @__nova_error_flag
	.p2align	3, 0x0
__nova_error_flag:
	.quad	0                               # 0x0

	.globl	__nova_error_msg                # @__nova_error_msg
	.p2align	3, 0x0
__nova_error_msg:
	.quad	0                               # 0x0

	.section	.rdata,"dr"
	.p2align	4, 0x0                          # @.str.0
.L.str.0:
	.asciz	"Primes up to 1M: "

	.bss
	.globl	__nova_g_result                 # @__nova_g_result
	.p2align	3, 0x0
__nova_g_result:
	.quad	0                               # 0x0

	.addrsig
