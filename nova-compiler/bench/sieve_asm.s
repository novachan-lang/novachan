	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"bench_g5_sieve10m.ll"
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
	incq	%rcx
	xorl	%edi, %edi
	xorl	%edx, %edx
	callq	nova_rt_list_create_filled
	movq	%rax, %rbx
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	cmpq	$2, %rsi
	jge	.LBB0_1
.LBB0_6:                                # %while_exit6
	movq	%rbx, %rcx
	callq	nova_rc_dec
	movq	%rdi, %rax
	.seh_startepilogue
	addq	$32, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
.LBB0_1:                                # %while_body5.lr.ph
	movq	(%rbx), %rax
	leaq	32(%rax), %rcx
	movl	$2, %edx
	movl	$40, %r8d
	movl	$16, %r9d
	xorl	%edi, %edi
	jmp	.LBB0_2
	.p2align	4
.LBB0_5:                                # %ifb_merge9
                                        #   in Loop: Header=BB0_2 Depth=1
	incq	%rdx
	addq	%r8, %rcx
	addq	$16, %r8
	addq	$8, %r9
	cmpq	%rsi, %rdx
	jg	.LBB0_6
.LBB0_2:                                # %while_body5
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
	cmpq	$0, (%rax,%rdx,8)
	jne	.LBB0_5
# %bb.3:                                # %ifb_then7
                                        #   in Loop: Header=BB0_2 Depth=1
	incq	%rdi
	movq	%rdx, %r10
	imulq	%rdx, %r10
	movq	%rcx, %r11
	cmpq	%rsi, %r10
	jg	.LBB0_5
	.p2align	4
.LBB0_7:                                # %while_body11
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%r11)
	addq	%rdx, %r10
	addq	%r9, %r11
	cmpq	%rsi, %r10
	jle	.LBB0_7
	jmp	.LBB0_5
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
	xorl	%esi, %esi
	movl	$10000001, %ecx                 # imm = 0x989681
	xorl	%edx, %edx
	callq	nova_rt_list_create_filled
	movq	%rax, %rdi
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	movq	(%rdi), %rax
	leaq	32(%rax), %rcx
	movl	$2, %edx
	movl	$40, %r8d
	movl	$16, %r9d
	jmp	.LBB1_1
	.p2align	4
.LBB1_4:                                # %ifb_merge9.i
                                        #   in Loop: Header=BB1_1 Depth=1
	incq	%rdx
	addq	%r8, %rcx
	addq	$16, %r8
	addq	$8, %r9
	cmpq	$10000001, %rdx                 # imm = 0x989681
	je	.LBB1_5
.LBB1_1:                                # %while_body5.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_6 Depth 2
	cmpq	$0, (%rax,%rdx,8)
	jne	.LBB1_4
# %bb.2:                                # %ifb_then7.i
                                        #   in Loop: Header=BB1_1 Depth=1
	incq	%rsi
	movq	%rdx, %r10
	imulq	%rdx, %r10
	movq	%rcx, %r11
	cmpq	$10000000, %r10                 # imm = 0x989680
	jg	.LBB1_4
	.p2align	4
.LBB1_6:                                # %while_body11.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	$1, (%r11)
	addq	%rdx, %r10
	addq	%r9, %r11
	cmpq	$10000000, %r10                 # imm = 0x989680
	jle	.LBB1_6
	jmp	.LBB1_4
.LBB1_5:                                # %count_primes.exit
	movq	%rdi, %rcx
	callq	nova_rc_dec
	movq	%rsi, %rcx
	callq	nova_rt_int_to_str
	movq	%rax, %rsi
	leaq	.L.str.0(%rip), %rcx
	movq	%rax, %rdx
	callq	nova_rt_str_concat
	movq	%rax, %rdi
	movq	%rsi, %rcx
	callq	nova_rc_dec
	movq	%rdi, %rcx
	callq	puts
	movq	%rdi, %rcx
	callq	nova_rc_dec
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
	callq	nova_rt_init
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
	.section	.tls$,"dw"
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
	.asciz	"Primes up to 10M: "

	.addrsig
