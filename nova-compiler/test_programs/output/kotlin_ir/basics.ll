Wrote output.ll (254 lines)
C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\.\nova_runtime.c:323:23: warning: 'strcpy' is deprecated: This function or variable may be unsafe. Consider using strcpy_s instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. See online help for details. [-Wdeprecated-declarations]
  323 |         if (!found) { strcpy(dst, p); break; }
      |                       ^
C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt\string.h:130:1: note: 'strcpy' has been explicitly marked deprecated here
  130 | __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_1(
      | ^
C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt\corecrt.h:874:5: note: expanded from macro '__DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_1'
  874 |     __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_1_EX(_ReturnType, _ReturnPolicy, _DeclSpec, _FuncName, _FuncName##_s, _DstType, _SalAttributeDst, _DstType, _Dst, _TType1, _TArg1)
      |     ^
C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt\corecrt.h:1933:17: note: expanded from macro '__DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_1_EX'
 1933 |                 _CRT_INSECURE_DEPRECATE(_SecureFuncName) _DeclSpec _ReturnType __cdecl _FuncName(_SalAttributeDst _DstType *_Dst, _TType1 _TArg1);
      |                 ^
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include\vcruntime.h:368:55: note: expanded from macro '_CRT_INSECURE_DEPRECATE'
  368 |         #define _CRT_INSECURE_DEPRECATE(_Replacement) _CRT_DEPRECATE_TEXT(    \
      |                                                       ^
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include\vcruntime.h:358:47: note: expanded from macro '_CRT_DEPRECATE_TEXT'
  358 | #define _CRT_DEPRECATE_TEXT(_Text) __declspec(deprecated(_Text))
      |                                               ^
C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\.\nova_runtime.c:590:15: warning: 'fopen' is deprecated: This function or variable may be unsafe. Consider using fopen_s instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. See online help for details. [-Wdeprecated-declarations]
  590 |     FILE* f = fopen(p, "r");
      |               ^
C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt\stdio.h:212:20: note: 'fopen' has been explicitly marked deprecated here
  212 |     _Check_return_ _CRT_INSECURE_DEPRECATE(fopen_s)
      |                    ^
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include\vcruntime.h:368:55: note: expanded from macro '_CRT_INSECURE_DEPRECATE'
  368 |         #define _CRT_INSECURE_DEPRECATE(_Replacement) _CRT_DEPRECATE_TEXT(    \
      |                                                       ^
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include\vcruntime.h:358:47: note: expanded from macro '_CRT_DEPRECATE_TEXT'
  358 | #define _CRT_DEPRECATE_TEXT(_Text) __declspec(deprecated(_Text))
      |                                               ^
C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\.\nova_runtime.c:606:15: warning: 'fopen' is deprecated: This function or variable may be unsafe. Consider using fopen_s instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. See online help for details. [-Wdeprecated-declarations]
  606 |     FILE* f = fopen(p, "w");
      |               ^
C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt\stdio.h:212:20: note: 'fopen' has been explicitly marked deprecated here
  212 |     _Check_return_ _CRT_INSECURE_DEPRECATE(fopen_s)
      |                    ^
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include\vcruntime.h:368:55: note: expanded from macro '_CRT_INSECURE_DEPRECATE'
  368 |         #define _CRT_INSECURE_DEPRECATE(_Replacement) _CRT_DEPRECATE_TEXT(    \
      |                                                       ^
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include\vcruntime.h:358:47: note: expanded from macro '_CRT_DEPRECATE_TEXT'
  358 | #define _CRT_DEPRECATE_TEXT(_Text) __declspec(deprecated(_Text))
      |                                               ^
3 warnings generated.
warning: overriding the module target triple with x86_64-pc-windows-msvc19.44.35222 [-Woverride-module]
1 warning generated.
lld-link: error: undefined symbol: nova_rt_init_args
>>> referenced by C:\Users\mange\AppData\Local\Temp\output-83e171.o:(main)
clang: error: linker command failed with exit code 1 (use -v to see invocation)

clang failed (exit 1) — .ll written, compile manually:
  clang -O2 C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\.\nova_runtime.c C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\output.ll -o output.exe
