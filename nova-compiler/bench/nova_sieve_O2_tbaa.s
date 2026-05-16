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
	js	.LBB0_5
# %bb.1:                                # %while_body2.preheader
	movq	%rax, %rdi
	xorl	%ebx, %ebx
	.p2align	4
.LBB0_2:                                # %while_body2
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rcx
	xorl	%edx, %edx
	callq	nova_rt_list_append
	incq	%rbx
	cmpq	%rsi, %rbx
	jle	.LBB0_2
# %bb.3:                                # %while_header4.preheader
	cmpq	$2, %rsi
	jae	.LBB0_7
.LBB0_5:
	xorl	%eax, %eax
.LBB0_6:                                # %while_exit6
	.seh_startepilogue
	addq	$32, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
.LBB0_7:                                # %while_body5.lr.ph
	movq	(%rdi), %rcx
	leaq	32(%rcx), %rdx
	movl	$2, %r8d
	movl	$40, %r9d
	movl	$16, %r10d
	xorl	%eax, %eax
	jmp	.LBB0_9
	.p2align	4
.LBB0_8:                                # %ifb_merge9
                                        #   in Loop: Header=BB0_9 Depth=1
	incq	%r8
	addq	%r9, %rdx
	addq	$16, %r9
	addq	$8, %r10
	cmpq	%rsi, %r8
	jg	.LBB0_6
.LBB0_9:                                # %while_body5
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_11 Depth 2
	cmpq	$0, (%rcx,%r8,8)
	jne	.LBB0_8
# %bb.10:                               # %ifb_then7
                                        #   in Loop: Header=BB0_9 Depth=1
	incq	%rax
	movq	%r8, %r11
	imulq	%r8, %r11
	movq	%rdx, %rdi
	cmpq	%rsi, %r11
	jg	.LBB0_8
	.p2align	4
.LBB0_11:                               # %while_body11
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%rdi)
	addq	%r8, %r11
	addq	%r10, %rdi
	cmpq	%rsi, %r11
	jle	.LBB0_11
	jmp	.LBB0_8
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
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movl	$1000001, %edi                  # imm = 0xF4241
	callq	nova_rt_list_create
	movq	%rax, %rsi
	.p2align	4
.LBB1_1:                                # %while_body2.i
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rcx
	xorl	%edx, %edx
	callq	nova_rt_list_append
	decq	%rdi
	jne	.LBB1_1
# %bb.2:                                # %while_header4.preheader.i
	movq	(%rsi), %rax
	leaq	32(%rax), %rdx
	movl	$2, %r8d
	movl	$40, %r9d
	movl	$16, %r10d
	xorl	%ecx, %ecx
	jmp	.LBB1_3
	.p2align	4
.LBB1_6:                                # %ifb_merge9.i
                                        #   in Loop: Header=BB1_3 Depth=1
	incq	%r8
	addq	%r9, %rdx
	addq	$16, %r9
	addq	$8, %r10
	cmpq	$1000001, %r8                   # imm = 0xF4241
	je	.LBB1_7
.LBB1_3:                                # %while_body5.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_8 Depth 2
	cmpq	$0, (%rax,%r8,8)
	jne	.LBB1_6
# %bb.4:                                # %ifb_then7.i
                                        #   in Loop: Header=BB1_3 Depth=1
	incq	%rcx
	movq	%r8, %r11
	imulq	%r8, %r11
	movq	%rdx, %rsi
	cmpq	$1000000, %r11                  # imm = 0xF4240
	jg	.LBB1_6
	.p2align	4
.LBB1_8:                                # %while_body11.i
                                        #   Parent Loop BB1_3 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%rsi)
	addq	%r8, %r11
	addq	%r10, %rsi
	cmpq	$1000000, %r11                  # imm = 0xF4240
	jle	.LBB1_8
	jmp	.LBB1_6
.LBB1_7:                                # %count_primes.exit
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
	popq	%rdi
	popq	%rsi
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
