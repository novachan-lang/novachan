	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"bench_g5_matmul.ll"
	.def	make_mat;
	.scl	2;
	.type	32;
	.endef
	.text
	.globl	make_mat                        # -- Begin function make_mat
	.p2align	4
make_mat:                               # @make_mat
.seh_proc make_mat
# %bb.0:                                # %entry0
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
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movq	%rdx, %rdi
	movq	%rcx, %rbx
	callq	nova_rt_list_create
	movq	%rax, %rsi
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	imulq	%rbx, %rbx
	testq	%rbx, %rbx
	jle	.LBB0_5
# %bb.1:                                # %while_body2.lr.ph
	movq	8(%rsi), %r12
	xorl	%r14d, %r14d
	movabsq	$2635249153387078803, %r13      # imm = 0x2492492492492493
	jmp	.LBB0_2
	.p2align	4
.LBB0_4:                                # %list_append_8
                                        #   in Loop: Header=BB0_2 Depth=1
	movq	%r14, %rcx
	subq	%r15, %rcx
	shrq	%rcx
	addq	%r15, %rcx
	shrq	$2, %rcx
	leaq	(,%rcx,8), %rdx
	subq	%rdx, %rcx
	addq	%rdi, %rcx
	movq	%rcx, (%rax,%r12,8)
	callq	nova_rc_inc
	incq	%r12
	movq	%r12, 8(%rsi)
	incq	%r14
	incq	%rdi
	decq	%rbx
	je	.LBB0_5
.LBB0_2:                                # %while_body2
                                        # =>This Inner Loop Header: Depth=1
	movq	%r14, %rax
	mulq	%r13
	movq	%rdx, %r15
	movq	(%rsi), %rax
	movq	16(%rsi), %rdx
	cmpq	%rdx, %r12
	jl	.LBB0_4
# %bb.3:                                # %list_grow_8
                                        #   in Loop: Header=BB0_2 Depth=1
	leaq	(%rdx,%rdx), %rbp
	shlq	$4, %rdx
	movq	%rax, %rcx
	callq	realloc
	movq	%rax, (%rsi)
	movq	%rbp, 16(%rsi)
	jmp	.LBB0_4
.LBB0_5:                                # %while_exit3
	movq	%rsi, %rcx
	callq	nova_rc_inc
	movq	%rsi, %rcx
	callq	nova_rc_dec
	movq	%rsi, %rax
	.seh_startepilogue
	addq	$40, %rsp
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
	.def	mat_mul;
	.scl	2;
	.type	32;
	.endef
	.globl	mat_mul                         # -- Begin function mat_mul
	.p2align	4
mat_mul:                                # @mat_mul
.seh_proc mat_mul
# %bb.0:                                # %entry0
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
	subq	$88, %rsp
	.seh_stackalloc 88
	.seh_endprologue
	movq	%r8, %rdi
	movq	%rdx, %rbx
	movq	%rcx, %r14
	callq	nova_rt_list_create
	movq	%rax, %r13
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	movq	%rdi, %r15
	imulq	%rdi, %r15
	testq	%r15, %r15
	jle	.LBB1_5
# %bb.1:                                # %while_body2.lr.ph
	movq	8(%r13), %rsi
	jmp	.LBB1_2
	.p2align	4
.LBB1_4:                                # %list_append_8
                                        #   in Loop: Header=BB1_2 Depth=1
	movq	$0, (%rax,%rsi,8)
	xorl	%ecx, %ecx
	callq	nova_rc_inc
	incq	%rsi
	movq	%rsi, 8(%r13)
	decq	%r15
	je	.LBB1_5
.LBB1_2:                                # %while_body2
                                        # =>This Inner Loop Header: Depth=1
	movq	(%r13), %rax
	movq	16(%r13), %rdx
	cmpq	%rdx, %rsi
	jl	.LBB1_4
# %bb.3:                                # %list_grow_8
                                        #   in Loop: Header=BB1_2 Depth=1
	leaq	(%rdx,%rdx), %r12
	shlq	$4, %rdx
	movq	%rax, %rcx
	callq	realloc
	movq	%rax, (%r13)
	movq	%r12, 16(%r13)
	jmp	.LBB1_4
.LBB1_5:                                # %while_header4.preheader
	movq	%r13, 40(%rsp)                  # 8-byte Spill
	testq	%rdi, %rdi
	jle	.LBB1_11
# %bb.6:                                # %while_header7.preheader.lr.ph
	movq	40(%rsp), %rax                  # 8-byte Reload
	movq	(%rax), %rax
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	movq	(%r14), %rax
	movq	(%rbx), %rcx
	movq	%rcx, 56(%rsp)                  # 8-byte Spill
	movl	%edi, %r8d
	andl	$3, %r8d
	movabsq	$9223372036854775804, %r9       # imm = 0x7FFFFFFFFFFFFFFC
	andq	%rdi, %r9
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	leaq	24(%rax), %r10
	leaq	(,%rdi,8), %r11
	leaq	(%r11,%r11,2), %rbx
	movq	%rdi, %r14
	shlq	$5, %r14
	movq	%rdi, %r15
	shlq	$4, %r15
	xorl	%eax, %eax
	jmp	.LBB1_7
	.p2align	4
.LBB1_10:                               # %while_exit9
                                        #   in Loop: Header=BB1_7 Depth=1
	movq	72(%rsp), %rax                  # 8-byte Reload
	incq	%rax
	addq	%r11, %r10
	addq	%r11, 48(%rsp)                  # 8-byte Folded Spill
	cmpq	%rdi, %rax
	je	.LBB1_11
.LBB1_7:                                # %while_header10.preheader.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_8 Depth 2
                                        #       Child Loop BB1_13 Depth 3
                                        #       Child Loop BB1_16 Depth 3
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	imulq	%rdi, %rax
	movq	64(%rsp), %rcx                  # 8-byte Reload
	leaq	(%rcx,%rax,8), %rax
	movq	%rax, 80(%rsp)                  # 8-byte Spill
	movq	56(%rsp), %r12                  # 8-byte Reload
	xorl	%eax, %eax
	jmp	.LBB1_8
	.p2align	4
.LBB1_17:                               # %while_exit12
                                        #   in Loop: Header=BB1_8 Depth=2
	movq	80(%rsp), %rcx                  # 8-byte Reload
	movq	%rdx, (%rcx,%rax,8)
	incq	%rax
	addq	$8, %r12
	cmpq	%rdi, %rax
	je	.LBB1_10
.LBB1_8:                                # %while_header10.preheader
                                        #   Parent Loop BB1_7 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_13 Depth 3
                                        #       Child Loop BB1_16 Depth 3
	cmpq	$4, %rdi
	jae	.LBB1_12
# %bb.9:                                #   in Loop: Header=BB1_8 Depth=2
	xorl	%edx, %edx
	xorl	%esi, %esi
	jmp	.LBB1_15
	.p2align	4
.LBB1_12:                               # %while_body11.preheader
                                        #   in Loop: Header=BB1_8 Depth=2
	movq	%r12, %rbp
	xorl	%edx, %edx
	xorl	%esi, %esi
	.p2align	4
.LBB1_13:                               # %while_body11
                                        #   Parent Loop BB1_7 Depth=1
                                        #     Parent Loop BB1_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	(%rbp), %rcx
	imulq	-24(%r10,%rsi,8), %rcx
	addq	%rdx, %rcx
	movq	(%rbp,%r11), %rdx
	imulq	-16(%r10,%rsi,8), %rdx
	movq	(%rbp,%r15), %r13
	imulq	-8(%r10,%rsi,8), %r13
	addq	%rdx, %r13
	addq	%rcx, %r13
	movq	(%rbp,%rbx), %rdx
	imulq	(%r10,%rsi,8), %rdx
	addq	%r13, %rdx
	addq	$4, %rsi
	addq	%r14, %rbp
	cmpq	%rsi, %r9
	jne	.LBB1_13
# %bb.14:                               # %while_exit12.unr-lcssa
                                        #   in Loop: Header=BB1_8 Depth=2
	testq	%r8, %r8
	je	.LBB1_17
.LBB1_15:                               # %while_body11.epil.preheader
                                        #   in Loop: Header=BB1_8 Depth=2
	movq	%r11, %rbp
	imulq	%rsi, %rbp
	addq	%r12, %rbp
	movq	48(%rsp), %rcx                  # 8-byte Reload
	leaq	(%rcx,%rsi,8), %rsi
	xorl	%ecx, %ecx
	.p2align	4
.LBB1_16:                               # %while_body11.epil
                                        #   Parent Loop BB1_7 Depth=1
                                        #     Parent Loop BB1_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	(%rbp), %r13
	imulq	(%rsi,%rcx,8), %r13
	addq	%r13, %rdx
	incq	%rcx
	addq	%r11, %rbp
	cmpq	%rcx, %r8
	jne	.LBB1_16
	jmp	.LBB1_17
.LBB1_11:                               # %while_exit6
	movq	40(%rsp), %rsi                  # 8-byte Reload
	movq	%rsi, %rcx
	callq	nova_rc_inc
	movq	%rsi, %rcx
	callq	nova_rc_dec
	movq	%rsi, %rax
	.seh_startepilogue
	addq	$88, %rsp
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
	.def	nova_main;
	.scl	2;
	.type	32;
	.endef
	.globl	nova_main                       # -- Begin function nova_main
	.p2align	4
nova_main:                              # @nova_main
.seh_proc nova_main
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
	movl	$300, %ecx                      # imm = 0x12C
	movl	$1, %edx
	callq	make_mat
	movq	%rax, %rsi
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	movl	$300, %ecx                      # imm = 0x12C
	movl	$2, %edx
	callq	make_mat
	movq	%rax, %rdi
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	movl	$300, %r8d                      # imm = 0x12C
	movq	%rsi, %rcx
	movq	%rdi, %rdx
	callq	mat_mul
	movq	%rax, %rbx
	xorl	%ecx, %ecx
	callq	nova_rc_dec
	movq	(%rbx), %rax
	pxor	%xmm0, %xmm0
	movl	$18, %ecx
	pxor	%xmm1, %xmm1
	.p2align	4
.LBB2_1:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	movdqu	-144(%rax,%rcx,8), %xmm2
	paddq	%xmm1, %xmm2
	movdqu	-128(%rax,%rcx,8), %xmm1
	paddq	%xmm0, %xmm1
	movdqu	-112(%rax,%rcx,8), %xmm0
	movdqu	-96(%rax,%rcx,8), %xmm3
	movdqu	-80(%rax,%rcx,8), %xmm4
	paddq	%xmm0, %xmm4
	paddq	%xmm2, %xmm4
	movdqu	-64(%rax,%rcx,8), %xmm2
	paddq	%xmm3, %xmm2
	paddq	%xmm1, %xmm2
	movdqu	-48(%rax,%rcx,8), %xmm0
	movdqu	-32(%rax,%rcx,8), %xmm3
	movdqu	-16(%rax,%rcx,8), %xmm1
	paddq	%xmm0, %xmm1
	paddq	%xmm4, %xmm1
	movdqu	(%rax,%rcx,8), %xmm0
	paddq	%xmm3, %xmm0
	paddq	%xmm2, %xmm0
	addq	$20, %rcx
	cmpq	$90018, %rcx                    # imm = 0x15FA2
	jne	.LBB2_1
# %bb.2:                                # %while_exit3
	paddq	%xmm1, %xmm0
	pshufd	$238, %xmm0, %xmm1              # xmm1 = xmm0[2,3,2,3]
	paddq	%xmm0, %xmm1
	movq	%xmm1, %rcx
	callq	nova_rt_int_to_str
	movq	%rax, %r14
	leaq	.L.str.0(%rip), %rcx
	movq	%rax, %rdx
	callq	nova_rt_str_concat
	movq	%rax, %r15
	movq	%r14, %rcx
	callq	nova_rc_dec
	movq	%r15, %rcx
	callq	puts
	movq	%r15, %rcx
	callq	nova_rc_dec
	movq	%rsi, %rcx
	callq	nova_rc_dec
	movq	%rdi, %rcx
	callq	nova_rc_dec
	movq	%rbx, %rcx
	callq	nova_rc_dec
	xorl	%eax, %eax
	.seh_startepilogue
	addq	$32, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r14
	popq	%r15
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
	.asciz	"Matmul 300x300 checksum: "

	.addrsig
