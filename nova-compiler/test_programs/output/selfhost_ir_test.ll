[1m[31merror[0m[1m: unexpected token 'newline inside string literal; use \n escape for a newline character' in expression[0m
  [2m-->[0m nova_compiler.nova:2521:45
  [2m     |[0m
  [2m2521 |[0m             header = header + ") nounwind {"
  [2m     |[0m                                             [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected INTERP_END but got 'ire_line' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2522:13
  [2m     |[0m
  [2m2522 |[0m             ire_line(e, header)
  [2m     |[0m             [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected INDENT but got 'match' (MATCH)[0m
  [2m-->[0m nova_compiler.nova:2527:17
  [2m     |[0m
  [2m2527 |[0m                 match params[pi]
  [2m     |[0m                 [31m^~~~~[0m
  [2m     |[0m [36m= blocks must be indented (NOVA uses indentation, not braces)[0m
  [2m     |[0m [32m+ fix: indent the following lines by 4 spaces[0m

[1m[31merror[0m[1m: expected INDENT but got 'IrParam' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2528:21
  [2m     |[0m
  [2m2528 |[0m                     IrParam(pname, ptype) =>
  [2m     |[0m                     [31m^~~~~~~[0m
  [2m     |[0m [36m= blocks must be indented (NOVA uses indentation, not braces)[0m
  [2m     |[0m [32m+ fix: indent the following lines by 4 spaces[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2530:20
  [2m     |[0m
  [2m2530 |[0m                 pi = pi + 1
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2530:20
  [2m     |[0m
  [2m2530 |[0m                 pi = pi + 1
  [2m     |[0m                    [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '+' (PLUS)[0m
  [2m-->[0m nova_compiler.nova:2530:25
  [2m     |[0m
  [2m2530 |[0m                 pi = pi + 1
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: unexpected token '+' in expression[0m
  [2m-->[0m nova_compiler.nova:2530:25
  [2m     |[0m
  [2m2530 |[0m                 pi = pi + 1
  [2m     |[0m                         [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'let' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2532:13
  [2m     |[0m
  [2m2532 |[0m             let local_slots = ire_collect_slots(blocks, param_names)
  [2m     |[0m             [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2532:29
  [2m     |[0m
  [2m2532 |[0m             let local_slots = ire_collect_slots(blocks, param_names)
  [2m     |[0m                             [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2532:29
  [2m     |[0m
  [2m2532 |[0m             let local_slots = ire_collect_slots(blocks, param_names)
  [2m     |[0m                             [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2532:48
  [2m     |[0m
  [2m2532 |[0m             let local_slots = ire_collect_slots(blocks, param_names)
  [2m     |[0m                                                [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2533:13
  [2m     |[0m
  [2m2533 |[0m             for block in blocks
  [2m     |[0m             [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'block' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2533:17
  [2m     |[0m
  [2m2533 |[0m             for block in blocks
  [2m     |[0m                 [31m^~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2534:17
  [2m     |[0m
  [2m2534 |[0m                 match block
  [2m     |[0m                 [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'block' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2534:23
  [2m     |[0m
  [2m2534 |[0m                 match block
  [2m     |[0m                       [31m^~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2537:25
  [2m     |[0m
  [2m2537 |[0m                         if label == "entry"
  [2m     |[0m                         [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'label' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2537:28
  [2m     |[0m
  [2m2537 |[0m                         if label == "entry"
  [2m     |[0m                            [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'pi2' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2539:33
  [2m     |[0m
  [2m2539 |[0m                             let pi2 = 0
  [2m     |[0m                                 [31m^~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2539:37
  [2m     |[0m
  [2m2539 |[0m                             let pi2 = 0
  [2m     |[0m                                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '0' (INT_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2539:39
  [2m     |[0m
  [2m2539 |[0m                             let pi2 = 0
  [2m     |[0m                                       [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'while'[0m
  [2m-->[0m nova_compiler.nova:2540:29
  [2m     |[0m
  [2m2540 |[0m                             while pi2 < len(params)
  [2m     |[0m                             [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'pi2' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2540:35
  [2m     |[0m
  [2m2540 |[0m                             while pi2 < len(params)
  [2m     |[0m                                   [31m^~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2541:33
  [2m     |[0m
  [2m2541 |[0m                                 match params[pi2]
  [2m     |[0m                                 [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'params' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2541:39
  [2m     |[0m
  [2m2541 |[0m                                 match params[pi2]
  [2m     |[0m                                       [31m^~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2544:51
  [2m     |[0m
  [2m2544 |[0m                                         ire_indent(e, "store i64 %p" + str(pi2) + ", ptr %slot." + pname + ", align 8")
  [2m     |[0m                                                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2545:37
  [2m     |[0m
  [2m2545 |[0m                                 pi2 = pi2 + 1
  [2m     |[0m                                     [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2545:37
  [2m     |[0m
  [2m2545 |[0m                                 pi2 = pi2 + 1
  [2m     |[0m                                     [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '+' (PLUS)[0m
  [2m-->[0m nova_compiler.nova:2545:43
  [2m     |[0m
  [2m2545 |[0m                                 pi2 = pi2 + 1
  [2m     |[0m                                           [31m^[0m

[1m[31merror[0m[1m: unexpected token '+' in expression[0m
  [2m-->[0m nova_compiler.nova:2545:43
  [2m     |[0m
  [2m2545 |[0m                                 pi2 = pi2 + 1
  [2m     |[0m                                           [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'for' (FOR)[0m
  [2m-->[0m nova_compiler.nova:2547:29
  [2m     |[0m
  [2m2547 |[0m                             for slot_name in local_slots
  [2m     |[0m                             [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2549:43
  [2m     |[0m
  [2m2549 |[0m                                 ire_indent(e, "store i64 0, ptr %slot." + slot_name + ", align 8")
  [2m     |[0m                                           [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2550:25
  [2m     |[0m
  [2m2550 |[0m                         for inst in insts
  [2m     |[0m                         [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'inst' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2550:29
  [2m     |[0m
  [2m2550 |[0m                         for inst in insts
  [2m     |[0m                             [31m^~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2551:42
  [2m     |[0m
  [2m2551 |[0m                             ire_emit_inst(e, inst)
  [2m     |[0m                                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2552:44
  [2m     |[0m
  [2m2552 |[0m                         ire_emit_terminator(e, terminator)
  [2m     |[0m                                            [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2553:21
  [2m     |[0m
  [2m2553 |[0m             ire_line(e, "}")
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2554:21
  [2m     |[0m
  [2m2554 |[0m             ire_line(e, "")
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'fn'[0m
  [2m-->[0m nova_compiler.nova:2558:1
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compile' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2558:4
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m    [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected RPAREN but got ':' (COLON)[0m
  [2m-->[0m nova_compiler.nova:2558:18
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m                  [31m^[0m
  [2m     |[0m [36m= unmatched opening parenthesis[0m
  [2m     |[0m [32m+ fix: add a closing ')'[0m

[1m[31merror[0m[1m: expected pattern, got ':'[0m
  [2m-->[0m nova_compiler.nova:2558:18
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m                  [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'string' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2558:20
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m                    [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got ')'[0m
  [2m-->[0m nova_compiler.nova:2558:26
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '->' (THIN_ARROW)[0m
  [2m-->[0m nova_compiler.nova:2558:28
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m                            [31m^~[0m

[1m[31merror[0m[1m: unexpected token '->' in expression[0m
  [2m-->[0m nova_compiler.nova:2558:28
  [2m     |[0m
  [2m2558 |[0m fn compile(source: string) -> string
  [2m     |[0m                            [31m^~[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'let' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2559:5
  [2m     |[0m
  [2m2559 |[0m     let tokens = tokenize(source)
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2559:16
  [2m     |[0m
  [2m2559 |[0m     let tokens = tokenize(source)
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2559:16
  [2m     |[0m
  [2m2559 |[0m     let tokens = tokenize(source)
  [2m     |[0m                [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2559:26
  [2m     |[0m
  [2m2559 |[0m     let tokens = tokenize(source)
  [2m     |[0m                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'stmts' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2560:9
  [2m     |[0m
  [2m2560 |[0m     let stmts = parse_program(tokens)
  [2m     |[0m         [31m^~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2560:15
  [2m     |[0m
  [2m2560 |[0m     let stmts = parse_program(tokens)
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'parse_program' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2560:17
  [2m     |[0m
  [2m2560 |[0m     let stmts = parse_program(tokens)
  [2m     |[0m                 [31m^~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'cg' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2561:9
  [2m     |[0m
  [2m2561 |[0m     let cg = new_codegen()
  [2m     |[0m         [31m^~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2561:12
  [2m     |[0m
  [2m2561 |[0m     let cg = new_codegen()
  [2m     |[0m            [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'new_codegen' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2561:14
  [2m     |[0m
  [2m2561 |[0m     let cg = new_codegen()
  [2m     |[0m              [31m^~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'functions' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2564:9
  [2m     |[0m
  [2m2564 |[0m     let functions = []
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2564:19
  [2m     |[0m
  [2m2564 |[0m     let functions = []
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '[' (LBRACKET)[0m
  [2m-->[0m nova_compiler.nova:2564:21
  [2m     |[0m
  [2m2564 |[0m     let functions = []
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'top_stmts' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2565:9
  [2m     |[0m
  [2m2565 |[0m     let top_stmts = []
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2565:19
  [2m     |[0m
  [2m2565 |[0m     let top_stmts = []
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '[' (LBRACKET)[0m
  [2m-->[0m nova_compiler.nova:2565:21
  [2m     |[0m
  [2m2565 |[0m     let top_stmts = []
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2566:5
  [2m     |[0m
  [2m2566 |[0m     for s in stmts
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 's' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2566:9
  [2m     |[0m
  [2m2566 |[0m     for s in stmts
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2567:9
  [2m     |[0m
  [2m2567 |[0m         match s
  [2m     |[0m         [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 's' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2567:15
  [2m     |[0m
  [2m2567 |[0m         match s
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2571:25
  [2m     |[0m
  [2m2571 |[0m                     push(cg.fn_names, name)
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2574:42
  [2m     |[0m
  [2m2574 |[0m                     cg.struct_defs[name] = params
  [2m     |[0m                                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'params' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2574:44
  [2m     |[0m
  [2m2574 |[0m                     cg.struct_defs[name] = params
  [2m     |[0m                                            [31m^~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fi' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2575:25
  [2m     |[0m
  [2m2575 |[0m                     let fi = 0
  [2m     |[0m                         [31m^~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2575:28
  [2m     |[0m
  [2m2575 |[0m                     let fi = 0
  [2m     |[0m                            [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '0' (INT_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2575:30
  [2m     |[0m
  [2m2575 |[0m                     let fi = 0
  [2m     |[0m                              [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2576:21
  [2m     |[0m
  [2m2576 |[0m                     for p in params
  [2m     |[0m                     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'p' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2576:25
  [2m     |[0m
  [2m2576 |[0m                     for p in params
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2577:25
  [2m     |[0m
  [2m2577 |[0m                         match p
  [2m     |[0m                         [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'p' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2577:31
  [2m     |[0m
  [2m2577 |[0m                         match p
  [2m     |[0m                               [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2579:53
  [2m     |[0m
  [2m2579 |[0m                                 cg.field_map[pname] = fi
  [2m     |[0m                                                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fi' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2579:55
  [2m     |[0m
  [2m2579 |[0m                                 cg.field_map[pname] = fi
  [2m     |[0m                                                       [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2580:28
  [2m     |[0m
  [2m2580 |[0m                         fi = fi + 1
  [2m     |[0m                            [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2580:28
  [2m     |[0m
  [2m2580 |[0m                         fi = fi + 1
  [2m     |[0m                            [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '+' (PLUS)[0m
  [2m-->[0m nova_compiler.nova:2580:33
  [2m     |[0m
  [2m2580 |[0m                         fi = fi + 1
  [2m     |[0m                                 [31m^[0m

[1m[31merror[0m[1m: unexpected token '+' in expression[0m
  [2m-->[0m nova_compiler.nova:2580:33
  [2m     |[0m
  [2m2580 |[0m                         fi = fi + 1
  [2m     |[0m                                 [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'else' (ELSE)[0m
  [2m-->[0m nova_compiler.nova:2581:17
  [2m     |[0m
  [2m2581 |[0m                 else if tag != "import"
  [2m     |[0m                 [31m^~~~[0m

[1m[31merror[0m[1m: unexpected token 'else' in expression[0m
  [2m-->[0m nova_compiler.nova:2581:17
  [2m     |[0m
  [2m2581 |[0m                 else if tag != "import"
  [2m     |[0m                 [31m^~~~[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2581:22
  [2m     |[0m
  [2m2581 |[0m                 else if tag != "import"
  [2m     |[0m                      [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'tag' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2581:25
  [2m     |[0m
  [2m2581 |[0m                 else if tag != "import"
  [2m     |[0m                         [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2582:25
  [2m     |[0m
  [2m2582 |[0m                     push(top_stmts, s)
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2588:23
  [2m     |[0m
  [2m2588 |[0m     emit_module_header(cg)
  [2m     |[0m                       [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2589:30
  [2m     |[0m
  [2m2589 |[0m     emit_runtime_declarations(cg)
  [2m     |[0m                              [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2592:5
  [2m     |[0m
  [2m2592 |[0m     for fn_stmt in functions
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fn_stmt' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2592:9
  [2m     |[0m
  [2m2592 |[0m     for fn_stmt in functions
  [2m     |[0m         [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2593:22
  [2m     |[0m
  [2m2593 |[0m         emit_function(cg, fn_stmt)
  [2m     |[0m                      [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2596:19
  [2m     |[0m
  [2m2596 |[0m     emit_nova_main(cg, top_stmts)
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2597:20
  [2m     |[0m
  [2m2597 |[0m     emit_main_entry(cg)
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2600:26
  [2m     |[0m
  [2m2600 |[0m     emit_string_constants(cg)
  [2m     |[0m                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2602:9
  [2m     |[0m
  [2m2602 |[0m     join(cg.output, "\n")
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'fn'[0m
  [2m-->[0m nova_compiler.nova:2606:1
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compile_ir' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2606:4
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m    [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected RPAREN but got ':' (COLON)[0m
  [2m-->[0m nova_compiler.nova:2606:21
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m                     [31m^[0m
  [2m     |[0m [36m= unmatched opening parenthesis[0m
  [2m     |[0m [32m+ fix: add a closing ')'[0m

[1m[31merror[0m[1m: expected pattern, got ':'[0m
  [2m-->[0m nova_compiler.nova:2606:21
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'string' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2606:23
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m                       [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got ')'[0m
  [2m-->[0m nova_compiler.nova:2606:29
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m                             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '->' (THIN_ARROW)[0m
  [2m-->[0m nova_compiler.nova:2606:31
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m                               [31m^~[0m

[1m[31merror[0m[1m: unexpected token '->' in expression[0m
  [2m-->[0m nova_compiler.nova:2606:31
  [2m     |[0m
  [2m2606 |[0m fn compile_ir(source: string) -> string
  [2m     |[0m                               [31m^~[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'let' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2607:5
  [2m     |[0m
  [2m2607 |[0m     let tokens = tokenize(source)
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2607:16
  [2m     |[0m
  [2m2607 |[0m     let tokens = tokenize(source)
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2607:16
  [2m     |[0m
  [2m2607 |[0m     let tokens = tokenize(source)
  [2m     |[0m                [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2607:26
  [2m     |[0m
  [2m2607 |[0m     let tokens = tokenize(source)
  [2m     |[0m                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'stmts' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2608:9
  [2m     |[0m
  [2m2608 |[0m     let stmts = parse_program(tokens)
  [2m     |[0m         [31m^~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2608:15
  [2m     |[0m
  [2m2608 |[0m     let stmts = parse_program(tokens)
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'parse_program' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2608:17
  [2m     |[0m
  [2m2608 |[0m     let stmts = parse_program(tokens)
  [2m     |[0m                 [31m^~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'b' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2609:9
  [2m     |[0m
  [2m2609 |[0m     let b = new_ir_builder()
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2609:11
  [2m     |[0m
  [2m2609 |[0m     let b = new_ir_builder()
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'new_ir_builder' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2609:13
  [2m     |[0m
  [2m2609 |[0m     let b = new_ir_builder()
  [2m     |[0m             [31m^~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'e' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2610:9
  [2m     |[0m
  [2m2610 |[0m     let e = new_ir_emitter()
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2610:11
  [2m     |[0m
  [2m2610 |[0m     let e = new_ir_emitter()
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'new_ir_emitter' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2610:13
  [2m     |[0m
  [2m2610 |[0m     let e = new_ir_emitter()
  [2m     |[0m             [31m^~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'functions' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2613:9
  [2m     |[0m
  [2m2613 |[0m     let functions = []
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2613:19
  [2m     |[0m
  [2m2613 |[0m     let functions = []
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '[' (LBRACKET)[0m
  [2m-->[0m nova_compiler.nova:2613:21
  [2m     |[0m
  [2m2613 |[0m     let functions = []
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'top_stmts' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2614:9
  [2m     |[0m
  [2m2614 |[0m     let top_stmts = []
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2614:19
  [2m     |[0m
  [2m2614 |[0m     let top_stmts = []
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '[' (LBRACKET)[0m
  [2m-->[0m nova_compiler.nova:2614:21
  [2m     |[0m
  [2m2614 |[0m     let top_stmts = []
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2615:5
  [2m     |[0m
  [2m2615 |[0m     for s in stmts
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 's' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2615:9
  [2m     |[0m
  [2m2615 |[0m     for s in stmts
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2616:9
  [2m     |[0m
  [2m2616 |[0m         match s
  [2m     |[0m         [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 's' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2616:15
  [2m     |[0m
  [2m2616 |[0m         match s
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2620:25
  [2m     |[0m
  [2m2620 |[0m                     push(b.ir_fnames, name)
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2622:38
  [2m     |[0m
  [2m2622 |[0m                     b.ir_sdefs[name] = params
  [2m     |[0m                                      [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'params' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2622:40
  [2m     |[0m
  [2m2622 |[0m                     b.ir_sdefs[name] = params
  [2m     |[0m                                        [31m^~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fi' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2623:25
  [2m     |[0m
  [2m2623 |[0m                     let fi = 0
  [2m     |[0m                         [31m^~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2623:28
  [2m     |[0m
  [2m2623 |[0m                     let fi = 0
  [2m     |[0m                            [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '0' (INT_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2623:30
  [2m     |[0m
  [2m2623 |[0m                     let fi = 0
  [2m     |[0m                              [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2624:21
  [2m     |[0m
  [2m2624 |[0m                     for p in params
  [2m     |[0m                     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'p' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2624:25
  [2m     |[0m
  [2m2624 |[0m                     for p in params
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2625:25
  [2m     |[0m
  [2m2625 |[0m                         match p
  [2m     |[0m                         [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'p' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2625:31
  [2m     |[0m
  [2m2625 |[0m                         match p
  [2m     |[0m                               [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2627:50
  [2m     |[0m
  [2m2627 |[0m                                 b.ir_fmap[pname] = fi
  [2m     |[0m                                                  [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fi' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2627:52
  [2m     |[0m
  [2m2627 |[0m                                 b.ir_fmap[pname] = fi
  [2m     |[0m                                                    [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2628:28
  [2m     |[0m
  [2m2628 |[0m                         fi = fi + 1
  [2m     |[0m                            [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2628:28
  [2m     |[0m
  [2m2628 |[0m                         fi = fi + 1
  [2m     |[0m                            [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '+' (PLUS)[0m
  [2m-->[0m nova_compiler.nova:2628:33
  [2m     |[0m
  [2m2628 |[0m                         fi = fi + 1
  [2m     |[0m                                 [31m^[0m

[1m[31merror[0m[1m: unexpected token '+' in expression[0m
  [2m-->[0m nova_compiler.nova:2628:33
  [2m     |[0m
  [2m2628 |[0m                         fi = fi + 1
  [2m     |[0m                                 [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'else' (ELSE)[0m
  [2m-->[0m nova_compiler.nova:2629:17
  [2m     |[0m
  [2m2629 |[0m                 else if tag != "import"
  [2m     |[0m                 [31m^~~~[0m

[1m[31merror[0m[1m: unexpected token 'else' in expression[0m
  [2m-->[0m nova_compiler.nova:2629:17
  [2m     |[0m
  [2m2629 |[0m                 else if tag != "import"
  [2m     |[0m                 [31m^~~~[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2629:22
  [2m     |[0m
  [2m2629 |[0m                 else if tag != "import"
  [2m     |[0m                      [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'tag' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2629:25
  [2m     |[0m
  [2m2629 |[0m                 else if tag != "import"
  [2m     |[0m                         [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2630:25
  [2m     |[0m
  [2m2630 |[0m                     push(top_stmts, s)
  [2m     |[0m                         [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2633:13
  [2m     |[0m
  [2m2633 |[0m     ire_line(e, "; NOVA IR-Pipeline Compiler Output")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2634:13
  [2m     |[0m
  [2m2634 |[0m     ire_line(e, "target datalayout = \"e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128\"")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2635:13
  [2m     |[0m
  [2m2635 |[0m     ire_line(e, "")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2636:13
  [2m     |[0m
  [2m2636 |[0m     ire_line(e, "@__nova_error_flag = thread_local global i64 0")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2637:13
  [2m     |[0m
  [2m2637 |[0m     ire_line(e, "@__nova_error_msg = thread_local global i64 0")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2638:13
  [2m     |[0m
  [2m2638 |[0m     ire_line(e, "")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2641:13
  [2m     |[0m
  [2m2641 |[0m     ire_line(e, "; Runtime declarations")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2642:13
  [2m     |[0m
  [2m2642 |[0m     ire_line(e, "declare i32 @puts(ptr) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2643:13
  [2m     |[0m
  [2m2643 |[0m     ire_line(e, "declare i32 @printf(ptr, ...) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2644:13
  [2m     |[0m
  [2m2644 |[0m     ire_line(e, "declare i64 @nova_rt_list_create() nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2645:13
  [2m     |[0m
  [2m2645 |[0m     ire_line(e, "declare i64 @nova_rt_list_append(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2646:13
  [2m     |[0m
  [2m2646 |[0m     ire_line(e, "declare i64 @nova_rt_list_get(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2647:13
  [2m     |[0m
  [2m2647 |[0m     ire_line(e, "declare i64 @nova_rt_list_len(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2648:13
  [2m     |[0m
  [2m2648 |[0m     ire_line(e, "declare i64 @nova_rt_dict_create() nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2649:13
  [2m     |[0m
  [2m2649 |[0m     ire_line(e, "declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2650:13
  [2m     |[0m
  [2m2650 |[0m     ire_line(e, "declare i64 @nova_rt_dict_get(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2651:13
  [2m     |[0m
  [2m2651 |[0m     ire_line(e, "declare i64 @nova_rt_dict_contains(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2652:13
  [2m     |[0m
  [2m2652 |[0m     ire_line(e, "declare i64 @nova_rt_str_concat(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2653:13
  [2m     |[0m
  [2m2653 |[0m     ire_line(e, "declare i64 @nova_rt_int_to_str(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2654:13
  [2m     |[0m
  [2m2654 |[0m     ire_line(e, "declare i64 @nova_rt_parse_int(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2655:13
  [2m     |[0m
  [2m2655 |[0m     ire_line(e, "declare i64 @nova_rt_len(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2656:13
  [2m     |[0m
  [2m2656 |[0m     ire_line(e, "declare i64 @nova_rt_len_any(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2657:13
  [2m     |[0m
  [2m2657 |[0m     ire_line(e, "declare i64 @nova_rt_ord(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2658:13
  [2m     |[0m
  [2m2658 |[0m     ire_line(e, "declare i64 @nova_rt_chr(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2659:13
  [2m     |[0m
  [2m2659 |[0m     ire_line(e, "declare i64 @nova_rt_contains(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2660:13
  [2m     |[0m
  [2m2660 |[0m     ire_line(e, "declare i64 @nova_rt_index_get(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2661:13
  [2m     |[0m
  [2m2661 |[0m     ire_line(e, "declare i64 @nova_rt_index_set(i64, i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2662:13
  [2m     |[0m
  [2m2662 |[0m     ire_line(e, "declare i64 @nova_rt_add(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2663:13
  [2m     |[0m
  [2m2663 |[0m     ire_line(e, "declare i64 @nova_rt_sub(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2664:13
  [2m     |[0m
  [2m2664 |[0m     ire_line(e, "declare i64 @nova_rt_mul(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2665:13
  [2m     |[0m
  [2m2665 |[0m     ire_line(e, "declare i64 @nova_rt_div(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2666:13
  [2m     |[0m
  [2m2666 |[0m     ire_line(e, "declare i64 @nova_rt_eq(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2667:13
  [2m     |[0m
  [2m2667 |[0m     ire_line(e, "declare i64 @nova_rt_neq(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2668:13
  [2m     |[0m
  [2m2668 |[0m     ire_line(e, "declare i64 @nova_rt_any_to_str(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2669:13
  [2m     |[0m
  [2m2669 |[0m     ire_line(e, "declare void @nova_rt_assert(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2670:13
  [2m     |[0m
  [2m2670 |[0m     ire_line(e, "declare i64 @nova_rt_read_file(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2671:13
  [2m     |[0m
  [2m2671 |[0m     ire_line(e, "declare i64 @nova_rt_write_file(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2672:13
  [2m     |[0m
  [2m2672 |[0m     ire_line(e, "declare i64 @nova_rt_args() nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2673:13
  [2m     |[0m
  [2m2673 |[0m     ire_line(e, "declare void @nova_rt_exit(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2674:13
  [2m     |[0m
  [2m2674 |[0m     ire_line(e, "declare i64 @nova_rt_split(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2675:13
  [2m     |[0m
  [2m2675 |[0m     ire_line(e, "declare i64 @nova_rt_join(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2676:13
  [2m     |[0m
  [2m2676 |[0m     ire_line(e, "declare i64 @nova_rt_upper(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2677:13
  [2m     |[0m
  [2m2677 |[0m     ire_line(e, "declare i64 @nova_rt_lower(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2678:13
  [2m     |[0m
  [2m2678 |[0m     ire_line(e, "declare i64 @nova_rt_trim(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2679:13
  [2m     |[0m
  [2m2679 |[0m     ire_line(e, "declare i64 @nova_rt_replace(i64, i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2680:13
  [2m     |[0m
  [2m2680 |[0m     ire_line(e, "declare i64 @nova_rt_starts_with(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2681:13
  [2m     |[0m
  [2m2681 |[0m     ire_line(e, "declare i64 @nova_rt_ends_with(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2682:13
  [2m     |[0m
  [2m2682 |[0m     ire_line(e, "declare i64 @nova_rt_print_any(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2683:13
  [2m     |[0m
  [2m2683 |[0m     ire_line(e, "declare i64 @nova_rt_float_bits(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2684:13
  [2m     |[0m
  [2m2684 |[0m     ire_line(e, "declare ptr @nova_rt_struct_alloc(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2685:13
  [2m     |[0m
  [2m2685 |[0m     ire_line(e, "declare i64 @nova_rt_slice(i64, i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2686:13
  [2m     |[0m
  [2m2686 |[0m     ire_line(e, "declare i64 @nova_rt_repeat(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2687:13
  [2m     |[0m
  [2m2687 |[0m     ire_line(e, "declare i64 @nova_rt_chars(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2688:13
  [2m     |[0m
  [2m2688 |[0m     ire_line(e, "declare i64 @nova_rt_time_ms() nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2689:13
  [2m     |[0m
  [2m2689 |[0m     ire_line(e, "declare i64 @nova_rt_sleep_ms(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2690:13
  [2m     |[0m
  [2m2690 |[0m     ire_line(e, "declare i64 @nova_rt_clock_ns() nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2691:13
  [2m     |[0m
  [2m2691 |[0m     ire_line(e, "declare i64 @nova_rt_type_of(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2692:13
  [2m     |[0m
  [2m2692 |[0m     ire_line(e, "declare i64 @nova_rt_range(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2693:13
  [2m     |[0m
  [2m2693 |[0m     ire_line(e, "declare i64 @nova_rt_sort(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2694:13
  [2m     |[0m
  [2m2694 |[0m     ire_line(e, "declare i64 @nova_rt_dict_keys(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2695:13
  [2m     |[0m
  [2m2695 |[0m     ire_line(e, "declare i64 @nova_rt_dict_values(i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2696:13
  [2m     |[0m
  [2m2696 |[0m     ire_line(e, "declare i64 @nova_rt_create_string(ptr) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2697:13
  [2m     |[0m
  [2m2697 |[0m     ire_line(e, "declare void @nova_rt_init_args(i64, i64) nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2698:13
  [2m     |[0m
  [2m2698 |[0m     ire_line(e, "declare void @nova_rt_cleanup() nounwind")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2699:13
  [2m     |[0m
  [2m2699 |[0m     ire_line(e, "")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2702:5
  [2m     |[0m
  [2m2702 |[0m     for fn_stmt in functions
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fn_stmt' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2702:9
  [2m     |[0m
  [2m2702 |[0m     for fn_stmt in functions
  [2m     |[0m         [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'ir_fn' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2703:13
  [2m     |[0m
  [2m2703 |[0m         let ir_fn = ir_lower_function(b, fn_stmt)
  [2m     |[0m             [31m^~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2703:19
  [2m     |[0m
  [2m2703 |[0m         let ir_fn = ir_lower_function(b, fn_stmt)
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'ir_lower_function' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2703:21
  [2m     |[0m
  [2m2703 |[0m         let ir_fn = ir_lower_function(b, fn_stmt)
  [2m     |[0m                     [31m^~~~~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'typed_fn' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2704:13
  [2m     |[0m
  [2m2704 |[0m         let typed_fn = ir_infer_types(ir_fn)
  [2m     |[0m             [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2704:22
  [2m     |[0m
  [2m2704 |[0m         let typed_fn = ir_infer_types(ir_fn)
  [2m     |[0m                      [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'ir_infer_types' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2704:24
  [2m     |[0m
  [2m2704 |[0m         let typed_fn = ir_infer_types(ir_fn)
  [2m     |[0m                        [31m^~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2705:26
  [2m     |[0m
  [2m2705 |[0m         ire_emit_function(e, typed_fn)
  [2m     |[0m                          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '.' (DOT)[0m
  [2m-->[0m nova_compiler.nova:2708:6
  [2m     |[0m
  [2m2708 |[0m     b.ir_insts = []
  [2m     |[0m      [31m^[0m

[1m[31merror[0m[1m: unexpected token '.' in expression[0m
  [2m-->[0m nova_compiler.nova:2708:6
  [2m     |[0m
  [2m2708 |[0m     b.ir_insts = []
  [2m     |[0m      [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2708:16
  [2m     |[0m
  [2m2708 |[0m     b.ir_insts = []
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2708:16
  [2m     |[0m
  [2m2708 |[0m     b.ir_insts = []
  [2m     |[0m                [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: unexpected token ']' in expression[0m
  [2m-->[0m nova_compiler.nova:2708:19
  [2m     |[0m
  [2m2708 |[0m     b.ir_insts = []
  [2m     |[0m                   [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected RBRACKET but got 'b' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2709:5
  [2m     |[0m
  [2m2709 |[0m     b.ir_blocks = []
  [2m     |[0m     [31m^[0m
  [2m     |[0m [36m= unmatched opening bracket[0m
  [2m     |[0m [32m+ fix: add a closing ']'[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '.' (DOT)[0m
  [2m-->[0m nova_compiler.nova:2709:6
  [2m     |[0m
  [2m2709 |[0m     b.ir_blocks = []
  [2m     |[0m      [31m^[0m

[1m[31merror[0m[1m: unexpected token '.' in expression[0m
  [2m-->[0m nova_compiler.nova:2709:6
  [2m     |[0m
  [2m2709 |[0m     b.ir_blocks = []
  [2m     |[0m      [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2709:17
  [2m     |[0m
  [2m2709 |[0m     b.ir_blocks = []
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2709:17
  [2m     |[0m
  [2m2709 |[0m     b.ir_blocks = []
  [2m     |[0m                 [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: unexpected token ']' in expression[0m
  [2m-->[0m nova_compiler.nova:2709:20
  [2m     |[0m
  [2m2709 |[0m     b.ir_blocks = []
  [2m     |[0m                    [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected RBRACKET but got 'b' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2710:5
  [2m     |[0m
  [2m2710 |[0m     b.ir_clabel = "entry"
  [2m     |[0m     [31m^[0m
  [2m     |[0m [36m= unmatched opening bracket[0m
  [2m     |[0m [32m+ fix: add a closing ']'[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '.' (DOT)[0m
  [2m-->[0m nova_compiler.nova:2710:6
  [2m     |[0m
  [2m2710 |[0m     b.ir_clabel = "entry"
  [2m     |[0m      [31m^[0m

[1m[31merror[0m[1m: unexpected token '.' in expression[0m
  [2m-->[0m nova_compiler.nova:2710:6
  [2m     |[0m
  [2m2710 |[0m     b.ir_clabel = "entry"
  [2m     |[0m      [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2710:17
  [2m     |[0m
  [2m2710 |[0m     b.ir_clabel = "entry"
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2710:17
  [2m     |[0m
  [2m2710 |[0m     b.ir_clabel = "entry"
  [2m     |[0m                 [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'b' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2711:5
  [2m     |[0m
  [2m2711 |[0m     b.ir_rc = 0
  [2m     |[0m     [31m^[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2711:13
  [2m     |[0m
  [2m2711 |[0m     b.ir_rc = 0
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '0' (INT_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2711:15
  [2m     |[0m
  [2m2711 |[0m     b.ir_rc = 0
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2712:5
  [2m     |[0m
  [2m2712 |[0m     for s in top_stmts
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 's' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2712:9
  [2m     |[0m
  [2m2712 |[0m     for s in top_stmts
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2713:22
  [2m     |[0m
  [2m2713 |[0m         ir_lower_stmt(b, s)
  [2m     |[0m                      [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2714:27
  [2m     |[0m
  [2m2714 |[0m     ir_flush_pending_block(b)
  [2m     |[0m                           [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2715:5
  [2m     |[0m
  [2m2715 |[0m     if len(b.ir_blocks) == 0
  [2m     |[0m     [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'len' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2715:8
  [2m     |[0m
  [2m2715 |[0m     if len(b.ir_blocks) == 0
  [2m     |[0m        [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2716:24
  [2m     |[0m
  [2m2716 |[0m         ir_finish_block(b, IrInst("return", "", ir_type_void(), ["0"], "", 0, "pure"))
  [2m     |[0m                        [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'main_fn' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2717:9
  [2m     |[0m
  [2m2717 |[0m     let main_fn = IrFunction("nova_main", [], ir_type_any(), b.ir_blocks, [], 0)
  [2m     |[0m         [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2717:17
  [2m     |[0m
  [2m2717 |[0m     let main_fn = IrFunction("nova_main", [], ir_type_any(), b.ir_blocks, [], 0)
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'IrFunction' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2717:19
  [2m     |[0m
  [2m2717 |[0m     let main_fn = IrFunction("nova_main", [], ir_type_any(), b.ir_blocks, [], 0)
  [2m     |[0m                   [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'typed_main' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2718:9
  [2m     |[0m
  [2m2718 |[0m     let typed_main = ir_infer_types(main_fn)
  [2m     |[0m         [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2718:20
  [2m     |[0m
  [2m2718 |[0m     let typed_main = ir_infer_types(main_fn)
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'ir_infer_types' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2718:22
  [2m     |[0m
  [2m2718 |[0m     let typed_main = ir_infer_types(main_fn)
  [2m     |[0m                      [31m^~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2719:22
  [2m     |[0m
  [2m2719 |[0m     ire_emit_function(e, typed_main)
  [2m     |[0m                      [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2722:13
  [2m     |[0m
  [2m2722 |[0m     ire_line(e, "define i32 @main(i32 %argc, ptr %argv) nounwind {")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: unexpected token 'newline inside string literal; use \n escape for a newline character' in expression[0m
  [2m-->[0m nova_compiler.nova:2722:69
  [2m     |[0m
  [2m2722 |[0m     ire_line(e, "define i32 @main(i32 %argc, ptr %argv) nounwind {")
  [2m     |[0m                                                                     [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected INTERP_END but got 'ire_line' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2723:5
  [2m     |[0m
  [2m2723 |[0m     ire_line(e, "entry:")
  [2m     |[0m     [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected RPAREN but got 'ire_line' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2723:5
  [2m     |[0m
  [2m2723 |[0m     ire_line(e, "entry:")
  [2m     |[0m     [31m^~~~~~~~[0m
  [2m     |[0m [36m= unmatched opening parenthesis[0m
  [2m     |[0m [32m+ fix: add a closing ')'[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2723:13
  [2m     |[0m
  [2m2723 |[0m     ire_line(e, "entry:")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2724:15
  [2m     |[0m
  [2m2724 |[0m     ire_indent(e, "%argc64 = sext i32 %argc to i64")
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2725:15
  [2m     |[0m
  [2m2725 |[0m     ire_indent(e, "%argv64 = ptrtoint ptr %argv to i64")
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2726:15
  [2m     |[0m
  [2m2726 |[0m     ire_indent(e, "call void @nova_rt_init_args(i64 %argc64, i64 %argv64)")
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2727:15
  [2m     |[0m
  [2m2727 |[0m     ire_indent(e, "call i64 @nova_main()")
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2728:15
  [2m     |[0m
  [2m2728 |[0m     ire_indent(e, "call void @nova_rt_cleanup()")
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2729:15
  [2m     |[0m
  [2m2729 |[0m     ire_indent(e, "ret i32 0")
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2730:13
  [2m     |[0m
  [2m2730 |[0m     ire_line(e, "}")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2731:13
  [2m     |[0m
  [2m2731 |[0m     ire_line(e, "")
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2734:5
  [2m     |[0m
  [2m2734 |[0m     if len(e.ire_strs) > 0
  [2m     |[0m     [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'len' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2734:8
  [2m     |[0m
  [2m2734 |[0m     if len(e.ire_strs) > 0
  [2m     |[0m        [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2735:17
  [2m     |[0m
  [2m2735 |[0m         ire_line(e, "; String constants")
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2736:9
  [2m     |[0m
  [2m2736 |[0m         for sc in e.ire_strs
  [2m     |[0m         [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'sc' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2736:13
  [2m     |[0m
  [2m2736 |[0m         for sc in e.ire_strs
  [2m     |[0m             [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2737:21
  [2m     |[0m
  [2m2737 |[0m             ire_line(e, sc)
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2738:17
  [2m     |[0m
  [2m2738 |[0m         ire_line(e, "")
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2740:9
  [2m     |[0m
  [2m2740 |[0m     join(e.ire_out, "\n")
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'fn'[0m
  [2m-->[0m nova_compiler.nova:2744:1
  [2m     |[0m
  [2m2744 |[0m fn compiler_main()
  [2m     |[0m [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compiler_main' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2744:4
  [2m     |[0m
  [2m2744 |[0m fn compiler_main()
  [2m     |[0m    [31m^~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'arguments' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2745:9
  [2m     |[0m
  [2m2745 |[0m     let arguments = args()
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2745:19
  [2m     |[0m
  [2m2745 |[0m     let arguments = args()
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'args' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2745:21
  [2m     |[0m
  [2m2745 |[0m     let arguments = args()
  [2m     |[0m                     [31m^~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2746:5
  [2m     |[0m
  [2m2746 |[0m     if len(arguments) < 2
  [2m     |[0m     [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'len' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2746:8
  [2m     |[0m
  [2m2746 |[0m     if len(arguments) < 2
  [2m     |[0m        [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2747:14
  [2m     |[0m
  [2m2747 |[0m         print("Usage: nova_compiler [--ir] <input.nova> [output.ll]")
  [2m     |[0m              [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2748:13
  [2m     |[0m
  [2m2748 |[0m         exit(1)
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'use_ir' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2750:9
  [2m     |[0m
  [2m2750 |[0m     let use_ir = false
  [2m     |[0m         [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2750:16
  [2m     |[0m
  [2m2750 |[0m     let use_ir = false
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'false' (FALSE)[0m
  [2m-->[0m nova_compiler.nova:2750:18
  [2m     |[0m
  [2m2750 |[0m     let use_ir = false
  [2m     |[0m                  [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'file_idx' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2751:9
  [2m     |[0m
  [2m2751 |[0m     let file_idx = 1
  [2m     |[0m         [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2751:18
  [2m     |[0m
  [2m2751 |[0m     let file_idx = 1
  [2m     |[0m                  [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '1' (INT_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2751:20
  [2m     |[0m
  [2m2751 |[0m     let file_idx = 1
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2752:5
  [2m     |[0m
  [2m2752 |[0m     if arguments[1] == "--ir"
  [2m     |[0m     [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'arguments' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2752:8
  [2m     |[0m
  [2m2752 |[0m     if arguments[1] == "--ir"
  [2m     |[0m        [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '=' (ASSIGN)[0m
  [2m-->[0m nova_compiler.nova:2753:16
  [2m     |[0m
  [2m2753 |[0m         use_ir = true
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: unexpected token '=' in expression[0m
  [2m-->[0m nova_compiler.nova:2753:16
  [2m     |[0m
  [2m2753 |[0m         use_ir = true
  [2m     |[0m                [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'file_idx' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2754:9
  [2m     |[0m
  [2m2754 |[0m         file_idx = 2
  [2m     |[0m         [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2754:18
  [2m     |[0m
  [2m2754 |[0m         file_idx = 2
  [2m     |[0m                  [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '2' (INT_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2754:20
  [2m     |[0m
  [2m2754 |[0m         file_idx = 2
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2755:5
  [2m     |[0m
  [2m2755 |[0m     if file_idx >= len(arguments)
  [2m     |[0m     [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'file_idx' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2755:8
  [2m     |[0m
  [2m2755 |[0m     if file_idx >= len(arguments)
  [2m     |[0m        [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2756:14
  [2m     |[0m
  [2m2756 |[0m         print("Usage: nova_compiler [--ir] <input.nova> [output.ll]")
  [2m     |[0m              [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2757:13
  [2m     |[0m
  [2m2757 |[0m         exit(1)
  [2m     |[0m             [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'input_path' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2758:9
  [2m     |[0m
  [2m2758 |[0m     let input_path = arguments[file_idx]
  [2m     |[0m         [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2758:20
  [2m     |[0m
  [2m2758 |[0m     let input_path = arguments[file_idx]
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'arguments' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2758:22
  [2m     |[0m
  [2m2758 |[0m     let input_path = arguments[file_idx]
  [2m     |[0m                      [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'output_path' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2759:9
  [2m     |[0m
  [2m2759 |[0m     let output_path = if file_idx + 1 < len(arguments)
  [2m     |[0m         [31m^~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2759:21
  [2m     |[0m
  [2m2759 |[0m     let output_path = if file_idx + 1 < len(arguments)
  [2m     |[0m                     [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'arguments' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2760:9
  [2m     |[0m
  [2m2760 |[0m         arguments[file_idx + 1]
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'source' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2763:9
  [2m     |[0m
  [2m2763 |[0m     let source = read_file(input_path)
  [2m     |[0m         [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2763:16
  [2m     |[0m
  [2m2763 |[0m     let source = read_file(input_path)
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'read_file' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2763:18
  [2m     |[0m
  [2m2763 |[0m     let source = read_file(input_path)
  [2m     |[0m                  [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'llvm_ir' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2764:9
  [2m     |[0m
  [2m2764 |[0m     let llvm_ir = if use_ir
  [2m     |[0m         [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2764:17
  [2m     |[0m
  [2m2764 |[0m     let llvm_ir = if use_ir
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compile_ir' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2765:9
  [2m     |[0m
  [2m2765 |[0m         compile_ir(source)
  [2m     |[0m         [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2768:15
  [2m     |[0m
  [2m2768 |[0m     write_file(output_path, llvm_ir)
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2769:5
  [2m     |[0m
  [2m2769 |[0m     if use_ir
  [2m     |[0m     [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'use_ir' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2769:8
  [2m     |[0m
  [2m2769 |[0m     if use_ir
  [2m     |[0m        [31m^~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2770:14
  [2m     |[0m
  [2m2770 |[0m         print("Compiled (IR): " + input_path + " -> " + output_path)
  [2m     |[0m              [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'fn'[0m
  [2m-->[0m nova_compiler.nova:2776:1
  [2m     |[0m
  [2m2776 |[0m fn run_self_test()
  [2m     |[0m [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'run_self_test' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2776:4
  [2m     |[0m
  [2m2776 |[0m fn run_self_test()
  [2m     |[0m    [31m^~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'tokens' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2778:9
  [2m     |[0m
  [2m2778 |[0m     let tokens = tokenize("let x = 42 + 3")
  [2m     |[0m         [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2778:16
  [2m     |[0m
  [2m2778 |[0m     let tokens = tokenize("let x = 42 + 3")
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'tokenize' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2778:18
  [2m     |[0m
  [2m2778 |[0m     let tokens = tokenize("let x = 42 + 3")
  [2m     |[0m                  [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2779:9
  [2m     |[0m
  [2m2779 |[0m     let non_nl = []
  [2m     |[0m         [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2779:16
  [2m     |[0m
  [2m2779 |[0m     let non_nl = []
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '[' (LBRACKET)[0m
  [2m-->[0m nova_compiler.nova:2779:18
  [2m     |[0m
  [2m2779 |[0m     let non_nl = []
  [2m     |[0m                  [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'for'[0m
  [2m-->[0m nova_compiler.nova:2780:5
  [2m     |[0m
  [2m2780 |[0m     for t in tokens
  [2m     |[0m     [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 't' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2780:9
  [2m     |[0m
  [2m2780 |[0m     for t in tokens
  [2m     |[0m         [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2781:9
  [2m     |[0m
  [2m2781 |[0m         match t
  [2m     |[0m         [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 't' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2781:15
  [2m     |[0m
  [2m2781 |[0m         match t
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2785:11
  [2m     |[0m
  [2m2785 |[0m     assert(len(non_nl) == 6, "lexer: expected 6 tokens, got " + str(len(non_nl)))
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2786:5
  [2m     |[0m
  [2m2786 |[0m     match non_nl[0]
  [2m     |[0m     [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2786:11
  [2m     |[0m
  [2m2786 |[0m     match non_nl[0]
  [2m     |[0m           [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2788:5
  [2m     |[0m
  [2m2788 |[0m     match non_nl[1]
  [2m     |[0m     [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2788:11
  [2m     |[0m
  [2m2788 |[0m     match non_nl[1]
  [2m     |[0m           [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2790:5
  [2m     |[0m
  [2m2790 |[0m     match non_nl[2]
  [2m     |[0m     [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2790:11
  [2m     |[0m
  [2m2790 |[0m     match non_nl[2]
  [2m     |[0m           [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2792:5
  [2m     |[0m
  [2m2792 |[0m     match non_nl[3]
  [2m     |[0m     [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2792:11
  [2m     |[0m
  [2m2792 |[0m     match non_nl[3]
  [2m     |[0m           [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2794:5
  [2m     |[0m
  [2m2794 |[0m     match non_nl[4]
  [2m     |[0m     [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2794:11
  [2m     |[0m
  [2m2794 |[0m     match non_nl[4]
  [2m     |[0m           [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'match'[0m
  [2m-->[0m nova_compiler.nova:2796:5
  [2m     |[0m
  [2m2796 |[0m     match non_nl[5]
  [2m     |[0m     [31m^~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'non_nl' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2796:11
  [2m     |[0m
  [2m2796 |[0m     match non_nl[5]
  [2m     |[0m           [31m^~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'tokens2' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2800:9
  [2m     |[0m
  [2m2800 |[0m     let tokens2 = tokenize("x = 10\ny = x + 5\nprint(y)")
  [2m     |[0m         [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2800:17
  [2m     |[0m
  [2m2800 |[0m     let tokens2 = tokenize("x = 10\ny = x + 5\nprint(y)")
  [2m     |[0m                 [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'tokenize' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2800:19
  [2m     |[0m
  [2m2800 |[0m     let tokens2 = tokenize("x = 10\ny = x + 5\nprint(y)")
  [2m     |[0m                   [31m^~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'stmts' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2801:9
  [2m     |[0m
  [2m2801 |[0m     let stmts = parse_program(tokens2)
  [2m     |[0m         [31m^~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2801:15
  [2m     |[0m
  [2m2801 |[0m     let stmts = parse_program(tokens2)
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'parse_program' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2801:17
  [2m     |[0m
  [2m2801 |[0m     let stmts = parse_program(tokens2)
  [2m     |[0m                 [31m^~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2802:11
  [2m     |[0m
  [2m2802 |[0m     assert(len(stmts) == 3, "parser: expected 3 stmts, got " + str(len(stmts)))
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'source' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2805:9
  [2m     |[0m
  [2m2805 |[0m     let source = "x = 42\nprint(x)"
  [2m     |[0m         [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2805:16
  [2m     |[0m
  [2m2805 |[0m     let source = "x = 42\nprint(x)"
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'x = 42
print(x)' (STRING_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2805:18
  [2m     |[0m
  [2m2805 |[0m     let source = "x = 42\nprint(x)"
  [2m     |[0m                  [31m^~~~~~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'result' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2806:9
  [2m     |[0m
  [2m2806 |[0m     let result = compile(source)
  [2m     |[0m         [31m^~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2806:16
  [2m     |[0m
  [2m2806 |[0m     let result = compile(source)
  [2m     |[0m                [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compile' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2806:18
  [2m     |[0m
  [2m2806 |[0m     let result = compile(source)
  [2m     |[0m                  [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2807:11
  [2m     |[0m
  [2m2807 |[0m     assert(contains(result, "define i64 @nova_main"), "codegen: has nova_main")
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2808:11
  [2m     |[0m
  [2m2808 |[0m     assert(contains(result, "nova_rt_print_any"), "codegen: has print call")
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fn_source' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2811:9
  [2m     |[0m
  [2m2811 |[0m     let fn_source = "fn add(a, b)\n    return a + b\nresult = add(3, 4)\nprint(result)"
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2811:19
  [2m     |[0m
  [2m2811 |[0m     let fn_source = "fn add(a, b)\n    return a + b\nresult = add(3, 4)\nprint(result)"
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fn add(a, b)
    return a + b
result = add(3, 4)
print(result)' (STRING_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2811:21
  [2m     |[0m
  [2m2811 |[0m     let fn_source = "fn add(a, b)\n    return a + b\nresult = add(3, 4)\nprint(result)"
  [2m     |[0m                     [31m^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'fn_result' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2812:9
  [2m     |[0m
  [2m2812 |[0m     let fn_result = compile(fn_source)
  [2m     |[0m         [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2812:19
  [2m     |[0m
  [2m2812 |[0m     let fn_result = compile(fn_source)
  [2m     |[0m                   [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compile' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2812:21
  [2m     |[0m
  [2m2812 |[0m     let fn_result = compile(fn_source)
  [2m     |[0m                     [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2813:11
  [2m     |[0m
  [2m2813 |[0m     assert(contains(fn_result, "define i64 @add"), "codegen: has user function")
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'str_source' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2816:9
  [2m     |[0m
  [2m2816 |[0m     let str_source = "x = \"hello\"\nprint(x)"
  [2m     |[0m         [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2816:20
  [2m     |[0m
  [2m2816 |[0m     let str_source = "x = \"hello\"\nprint(x)"
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'x = "hello"
print(x)' (STRING_LITERAL)[0m
  [2m-->[0m nova_compiler.nova:2816:22
  [2m     |[0m
  [2m2816 |[0m     let str_source = "x = \"hello\"\nprint(x)"
  [2m     |[0m                      [31m^~~~~~~~~~~~~~~~~~~~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'str_result' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2817:9
  [2m     |[0m
  [2m2817 |[0m     let str_result = compile(str_source)
  [2m     |[0m         [31m^~~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2817:20
  [2m     |[0m
  [2m2817 |[0m     let str_result = compile(str_source)
  [2m     |[0m                    [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'compile' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2817:22
  [2m     |[0m
  [2m2817 |[0m     let str_result = compile(str_source)
  [2m     |[0m                      [31m^~~~~~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2818:11
  [2m     |[0m
  [2m2818 |[0m     assert(contains(str_result, "@.str."), "codegen: has string constant")
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2819:11
  [2m     |[0m
  [2m2819 |[0m     assert(contains(str_result, "nova_rt_print_any"), "codegen: string print call")
  [2m     |[0m           [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2821:10
  [2m     |[0m
  [2m2821 |[0m     print("NOVA Self-Hosting Compiler: ALL TESTS PASSED")
  [2m     |[0m          [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'arguments' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2823:5
  [2m     |[0m
  [2m2823 |[0m let arguments = args()
  [2m     |[0m     [31m^~~~~~~~~[0m

[1m[31merror[0m[1m: expected pattern, got '='[0m
  [2m-->[0m nova_compiler.nova:2823:15
  [2m     |[0m
  [2m2823 |[0m let arguments = args()
  [2m     |[0m               [31m^[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'args' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2823:17
  [2m     |[0m
  [2m2823 |[0m let arguments = args()
  [2m     |[0m                 [31m^~~~[0m

[1m[31merror[0m[1m: expected pattern, got 'if'[0m
  [2m-->[0m nova_compiler.nova:2824:1
  [2m     |[0m
  [2m2824 |[0m if len(arguments) >= 2
  [2m     |[0m [31m^~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got 'len' (IDENT)[0m
  [2m-->[0m nova_compiler.nova:2824:4
  [2m     |[0m
  [2m2824 |[0m if len(arguments) >= 2
  [2m     |[0m    [31m^~~[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '(' (LPAREN)[0m
  [2m-->[0m nova_compiler.nova:2825:18
  [2m     |[0m
  [2m2825 |[0m     compiler_main()
  [2m     |[0m                  [31m^[0m

[1m[31merror[0m[1m: expected pattern, got 'unterminated string interpolation: missing closing '}''[0m
  [2m-->[0m nova_compiler.nova:2821:11
  [2m     |[0m
  [2m2821 |[0m     print("NOVA Self-Hosting Compiler: ALL TESTS PASSED")
  [2m     |[0m           [31m^[0m
  [2m     |[0m [32m+ fix: add a closing quote '"'[0m

[1m[31merror[0m[1m: expected FAT_ARROW but got '' (DEDENT)[0m
  [2m-->[0m nova_compiler.nova:2828:1
  [2m     |[0m
  [2m2828 |[0m 
  [2m     |[0m [31m^[0m

[1m[31merror[0m[1m: unexpected token '' in expression[0m
  [2m-->[0m nova_compiler.nova:2828:1
  [2m     |[0m
  [2m2828 |[0m 
  [2m     |[0m [31m^[0m
  [2m     |[0m [36m= the parser didn't expect this token here[0m

[1m[31m383 errors[0m emitted
