/* WASM value-model translation unit (NOVA #27 carve, S1 scaffold).
   Compiles the NOVA runtime's HEAP VALUE-MODEL (strings/lists/dicts/structs + RC + find_tag + arena) to
   wasm32 by #define NOVA_FREESTANDING -- which gates out the system headers and (incrementally, S2+) the
   I/O/socket/thread/scheduler sections inside nova_runtime.c -- plus tiny freestanding libc primitives below
   (there is no wasi-sysroot offline). The NATIVE build NEVER compiles this file: nova_runtime.c is compiled
   directly with NOVA_FREESTANDING absent, so it is unaffected.
   Build: clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c nova_runtime_wasm.c -o _wasm_vm.o
   (-fno-builtin is MANDATORY: -O2 loop-idiom otherwise re-emits a libc strlen/memcpy import that traps in V8.) */
#define NOVA_FREESTANDING 1

#include <stdint.h>
#include <stddef.h>

/* --- tiny freestanding libc (no sysroot). clang lowers struct copies + aggregate initializers to memcpy/
   memset, so those MUST exist as REAL symbols (not just inline). Provided non-static so the whole TU + the
   linked NOVA program can resolve them. snprintf/malloc/etc. are handled in later carve steps. --- */
void* memcpy(void* d, const void* s, size_t n) {
    unsigned char* a = (unsigned char*)d; const unsigned char* b = (const unsigned char*)s;
    for (size_t i = 0; i < n; i++) a[i] = b[i];
    return d;
}
void* memmove(void* d, const void* s, size_t n) {
    unsigned char* a = (unsigned char*)d; const unsigned char* b = (const unsigned char*)s;
    if (a < b) { for (size_t i = 0; i < n; i++) a[i] = b[i]; }
    else       { for (size_t i = n; i > 0; i--) a[i-1] = b[i-1]; }
    return d;
}
void* memset(void* d, int v, size_t n) {
    unsigned char* a = (unsigned char*)d;
    for (size_t i = 0; i < n; i++) a[i] = (unsigned char)v;
    return d;
}
int memcmp(const void* x, const void* y, size_t n) {
    const unsigned char* a = (const unsigned char*)x; const unsigned char* b = (const unsigned char*)y;
    for (size_t i = 0; i < n; i++) { if (a[i] != b[i]) return (int)a[i] - (int)b[i]; }
    return 0;
}
size_t strlen(const char* s) { size_t n = 0; while (s[n]) n++; return n; }
int strcmp(const char* a, const char* b) { while (*a && *a == *b) { a++; b++; } return (int)(unsigned char)*a - (int)(unsigned char)*b; }
int strncmp(const char* a, const char* b, size_t n) {
    for (size_t i = 0; i < n; i++) { if (a[i] != b[i] || !a[i]) return (int)(unsigned char)a[i] - (int)(unsigned char)b[i]; }
    return 0;
}
char* strchr(const char* s, int c) { for (; *s; s++) { if (*s == (char)c) return (char*)s; } return c ? (char*)0 : (char*)s; }
char* strstr(const char* h, const char* n) {
    if (!*n) return (char*)h;
    for (; *h; h++) { const char* a=h; const char* b=n; while (*a && *b && *a==*b){a++;b++;} if (!*b) return (char*)h; }
    return (char*)0;
}
char* strcpy(char* d, const char* s) { char* r=d; while ((*d++=*s++)); return r; }

/* ===================== freestanding libc SHIM (NOVA #27 wasm carve, S2) =====================
   No wasi-sysroot offline, so the I/O/OS symbols nova_runtime.c references must be satisfied here. The
   value-model genuinely USES a handful (malloc/snprintf/parsers) -> real minimal impls. The rest (stdio/
   sockets/threads/process/backtrace) are DEAD in a pure value-model wasm program -> declarations + harmless
   stubs so the TU compiles; wasm-ld --gc-sections / --allow-undefined drops them. NATIVE never sees this. */
#include <stdarg.h>

/* --- opaque/scalar types the gated headers would have provided --- */
typedef struct _NOVA_FILE FILE;          /* incomplete: only ever used as FILE* (fopen/fread opaque) */
typedef long ssize_t;
typedef int  pid_t;
typedef unsigned long _nova_jb[64];
typedef _nova_jb jmp_buf;
typedef unsigned long pthread_t;
typedef struct { long _o[8]; } pthread_mutex_t;
typedef struct { long _o[8]; } pthread_cond_t;
typedef struct { long _o[2]; } pthread_mutexattr_t;
typedef struct { unsigned long fds_bits[64]; } fd_set;
struct timeval  { long tv_sec; long tv_usec; };
struct timespec { long tv_sec; long tv_nsec; };
struct in_addr  { unsigned int s_addr; };
struct sockaddr { unsigned short sa_family; char sa_data[14]; };
struct sockaddr_in { unsigned short sin_family; unsigned short sin_port; struct in_addr sin_addr; char sin_zero[8]; };
struct addrinfo { int ai_flags, ai_family, ai_socktype, ai_protocol; unsigned int ai_addrlen;
                  struct sockaddr* ai_addr; char* ai_canonname; struct addrinfo* ai_next; };
struct stat { unsigned long st_dev, st_ino; unsigned int st_mode; unsigned long st_size; long st_mtime; };
struct dirent { unsigned long d_ino; char d_name[256]; };

/* --- macros --- */
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#define EEXIST 17
#define CLOCK_REALTIME  0
#define CLOCK_MONOTONIC 1
#define PTHREAD_MUTEX_INITIALIZER {{0}}
#define PTHREAD_COND_INITIALIZER  {{0}}
#define PTHREAD_MUTEX_RECURSIVE 1
#define _SC_NPROCESSORS_ONLN 84
#ifndef FD_SETSIZE
#define FD_SETSIZE 4096
#endif
#define FD_ZERO(s)    do { for (int _i=0;_i<64;_i++) (s)->fds_bits[_i]=0; } while (0)
#define FD_SET(fd,s)  do { (s)->fds_bits[(fd)>>6] |= (1UL<<((fd)&63)); } while (0)
#define FD_CLR(fd,s)  do { (s)->fds_bits[(fd)>>6] &= ~(1UL<<((fd)&63)); } while (0)
#define FD_ISSET(fd,s) (((s)->fds_bits[(fd)>>6]>>((fd)&63))&1UL)
#define WIFEXITED(s)   (((s)&0x7f)==0)
#define WEXITSTATUS(s) (((s)>>8)&0xff)
extern int errno;
int errno = 0;
extern FILE* stdin;  FILE* stdin  = (FILE*)0;
extern FILE* stdout; FILE* stdout = (FILE*)0;
extern FILE* stderr; FILE* stderr = (FILE*)0;

/* --- value-model libc: REAL minimal impls (bump heap, used at runtime) --- */
static unsigned char _wasm_libc_heap[16*1024*1024];
static size_t _wasm_libc_off = 0;
void* malloc(size_t n) { size_t a=(n+15)&~(size_t)15; if (_wasm_libc_off+a>sizeof(_wasm_libc_heap)) return (void*)0; void* p=&_wasm_libc_heap[_wasm_libc_off]; _wasm_libc_off+=a; return p; }
void* calloc(size_t n, size_t s) { size_t t=n*s; void* p=malloc(t); if (p) memset(p,0,t); return p; }
void  free(void* p) { (void)p; }                                   /* bump: no individual free */
void* realloc(void* p, size_t n) { void* q=malloc(n); if (p&&q) memcpy(q,p,n); return q; }  /* may over-copy within heap; safe */
int   atoi(const char* s) { int r=0,sg=1; while (*s==' ')s++; if (*s=='-'){sg=-1;s++;} else if (*s=='+')s++; while (*s>='0'&&*s<='9') r=r*10+(*s++-'0'); return r*sg; }
long long atoll(const char* s) { long long r=0; int sg=1; while (*s==' ')s++; if (*s=='-'){sg=-1;s++;} else if (*s=='+')s++; while (*s>='0'&&*s<='9') r=r*10+(*s++-'0'); return r*sg; }
double strtod(const char* s, char** end) {
    double r=0; int sg=1; while (*s==' ')s++; if (*s=='-'){sg=-1;s++;} else if (*s=='+')s++;
    while (*s>='0'&&*s<='9') r=r*10+(*s++-'0');
    if (*s=='.') { s++; double f=0.1; while (*s>='0'&&*s<='9'){ r+=(*s++-'0')*f; f*=0.1; } }
    if (end) *end=(char*)s; return r*sg;
}
double atof(const char* s) { return strtod(s,(char**)0); }
void qsort(void* base, size_t n, size_t sz, int(*cmp)(const void*,const void*)) {
    char* a=(char*)base; unsigned char tmp[512]; if (sz>sizeof(tmp)) return;
    for (size_t i=1;i<n;i++) for (size_t j=i; j>0 && cmp(a+(j-1)*sz, a+j*sz)>0; j--) {
        memcpy(tmp,a+(j-1)*sz,sz); memcpy(a+(j-1)*sz,a+j*sz,sz); memcpy(a+j*sz,tmp,sz);
    }
}
__attribute__((noreturn)) void abort(void) { __builtin_trap(); }
__attribute__((noreturn)) void exit(int c)  { (void)c; __builtin_trap(); }
__attribute__((noreturn)) void _exit(int c) { (void)c; __builtin_trap(); }
char* getenv(const char* n) { (void)n; return (char*)0; }           /* no env in wasm */

/* minimal vsnprintf/snprintf supporting %d %ld %lld %u %x %s %c %f %g %p %% (good enough for value-model
   int/float-to-str; float fidelity refined in S4). Returns bytes that WOULD be written (C99). */
static int _wasm_utoa(char* o, int cap, int* pos, unsigned long long v, int base, int upper) {
    char buf[32]; int k=0; const char* dig = upper ? "0123456789ABCDEF" : "0123456789abcdef";
    if (v==0) buf[k++]='0'; while (v){ buf[k++]=dig[v%base]; v/=base; }
    int w=0; while (k>0){ if (*pos<cap-1) o[(*pos)++]=buf[--k]; else k--; w++; } return w;
}
int vsnprintf(char* o, size_t cap, const char* f, va_list ap) {
    int pos=0; int total=0; if (cap==0) cap=1;
    for (; *f; f++) {
        if (*f!='%') { if (pos<(int)cap-1) o[pos++]=*f; total++; continue; }
        f++; int lng=0; while (*f=='l'){lng++;f++;}
        if (*f=='z'){f++;}
        if (*f=='d'||*f=='i') { long long v = lng>=2 ? va_arg(ap,long long) : (long long)va_arg(ap,long);
            if (lng==0) {} unsigned long long u; if (v<0){ if (pos<(int)cap-1)o[pos++]='-'; total++; u=(unsigned long long)(-v);} else u=(unsigned long long)v;
            total+=_wasm_utoa(o,(int)cap,&pos,u,10,0); }
        else if (*f=='u') { unsigned long long v = lng>=2 ? va_arg(ap,unsigned long long) : (unsigned long long)va_arg(ap,unsigned long); total+=_wasm_utoa(o,(int)cap,&pos,v,10,0); }
        else if (*f=='x'||*f=='X') { unsigned long long v = lng>=2 ? va_arg(ap,unsigned long long) : (unsigned long long)va_arg(ap,unsigned long); total+=_wasm_utoa(o,(int)cap,&pos,v,16,*f=='X'); }
        else if (*f=='p') { unsigned long long v=(unsigned long long)(size_t)va_arg(ap,void*); if(pos<(int)cap-1)o[pos++]='0'; if(pos<(int)cap-1)o[pos++]='x'; total+=2+_wasm_utoa(o,(int)cap,&pos,v,16,0); }
        else if (*f=='c') { int c=va_arg(ap,int); if (pos<(int)cap-1)o[pos++]=(char)c; total++; }
        else if (*f=='s') { const char* s=va_arg(ap,const char*); if(!s)s="(null)"; while (*s){ if (pos<(int)cap-1)o[pos++]=*s; s++; total++; } }
        else if (*f=='f'||*f=='g'||*f=='e'||*f=='F'||*f=='G') { double d=va_arg(ap,double); if (d<0){ if(pos<(int)cap-1)o[pos++]='-'; total++; d=-d; }
            unsigned long long ip=(unsigned long long)d; total+=_wasm_utoa(o,(int)cap,&pos,ip,10,0); double fr=d-(double)ip;
            if (pos<(int)cap-1)o[pos++]='.'; total++; for (int i=0;i<6;i++){ fr*=10; int dd=(int)fr; if(pos<(int)cap-1)o[pos++]=(char)('0'+dd); fr-=dd; total++; } }
        else if (*f=='%') { if (pos<(int)cap-1)o[pos++]='%'; total++; }
        else { if (pos<(int)cap-1)o[pos++]=*f; total++; }
    }
    o[pos<(int)cap?pos:(int)cap-1]='\0'; return total;
}
int snprintf(char* o, size_t cap, const char* f, ...) { va_list ap; va_start(ap,f); int r=vsnprintf(o,cap,f,ap); va_end(ap); return r; }

/* --- DEAD-in-wasm I/O/OS: declarations (+ trivial stubs where a definition eases linking). A pure value-
   model program never calls these; wasm-ld drops them. Signatures kept loose-but-compatible. --- */
int    printf(const char* f, ...) { (void)f; return 0; }
int    fprintf(FILE* s, const char* f, ...) { (void)s;(void)f; return 0; }
int    fflush(FILE* s) { (void)s; return 0; }
int    puts(const char* s) { (void)s; return 0; }
int    fputs(const char* s, FILE* st) { (void)s;(void)st; return 0; }
int    fputc(int c, FILE* st) { (void)st; return c; }
FILE*  fopen(const char* p, const char* m) { (void)p;(void)m; return (FILE*)0; }
size_t fread(void* b, size_t s, size_t n, FILE* f) { (void)b;(void)s;(void)n;(void)f; return 0; }
size_t fwrite(const void* b, size_t s, size_t n, FILE* f) { (void)b;(void)s;(void)n;(void)f; return 0; }
int    fclose(FILE* f) { (void)f; return 0; }
char*  fgets(char* b, int n, FILE* f) { (void)b;(void)n;(void)f; return (char*)0; }
int    fseeko(FILE* f, long off, int w) { (void)f;(void)off;(void)w; return -1; }
long   ftello(FILE* f) { (void)f; return -1; }
char*  strerror(int e) { (void)e; return (char*)"error"; }
int    setjmp(jmp_buf b) { (void)b; return 0; }
__attribute__((noreturn)) void longjmp(jmp_buf b, int v) { (void)b;(void)v; __builtin_trap(); }
int    backtrace(void** a, int n) { (void)a;(void)n; return 0; }
void   backtrace_symbols_fd(void* const* a, int n, int fd) { (void)a;(void)n;(void)fd; }
int    pthread_mutex_init(pthread_mutex_t* m, const void* a) { (void)m;(void)a; return 0; }
int    pthread_mutex_lock(pthread_mutex_t* m) { (void)m; return 0; }
int    pthread_mutex_unlock(pthread_mutex_t* m) { (void)m; return 0; }
int    pthread_mutex_destroy(pthread_mutex_t* m) { (void)m; return 0; }
int    pthread_mutexattr_init(pthread_mutexattr_t* a) { (void)a; return 0; }
int    pthread_mutexattr_settype(pthread_mutexattr_t* a, int t) { (void)a;(void)t; return 0; }
int    pthread_mutexattr_destroy(pthread_mutexattr_t* a) { (void)a; return 0; }
int    pthread_cond_init(pthread_cond_t* c, const void* a) { (void)c;(void)a; return 0; }
int    pthread_cond_signal(pthread_cond_t* c) { (void)c; return 0; }
int    pthread_cond_broadcast(pthread_cond_t* c) { (void)c; return 0; }
int    pthread_cond_wait(pthread_cond_t* c, pthread_mutex_t* m) { (void)c;(void)m; return 0; }
int    pthread_cond_timedwait(pthread_cond_t* c, pthread_mutex_t* m, const struct timespec* t) { (void)c;(void)m;(void)t; return 0; }
int    pthread_cond_destroy(pthread_cond_t* c) { (void)c; return 0; }
int    pthread_create(pthread_t* th, const void* a, void* (*fn)(void*), void* arg) { (void)th;(void)a;(void)fn;(void)arg; return 1; }
int    pthread_detach(pthread_t th) { (void)th; return 0; }
int    pthread_join(pthread_t th, void** r) { (void)th;(void)r; return 0; }
int    sched_yield(void) { return 0; }
int    usleep(unsigned int us) { (void)us; return 0; }
unsigned int sleep(unsigned int s) { (void)s; return 0; }
int    gettimeofday(struct timeval* tv, void* tz) { (void)tz; if (tv){tv->tv_sec=0;tv->tv_usec=0;} return 0; }
int    clock_gettime(int clk, struct timespec* ts) { (void)clk; if (ts){ts->tv_sec=0;ts->tv_nsec=0;} return 0; }
long   sysconf(int name) { (void)name; return 1; }
int    select(int n, fd_set* r, fd_set* w, fd_set* e, struct timeval* t) { (void)n;(void)r;(void)w;(void)e;(void)t; return 0; }
int    getaddrinfo(const char* node, const char* svc, const struct addrinfo* h, struct addrinfo** res) { (void)node;(void)svc;(void)h; if(res)*res=(struct addrinfo*)0; return -1; }
void   freeaddrinfo(struct addrinfo* r) { (void)r; }
int    pipe(int fds[2]) { (void)fds; return -1; }
ssize_t write(int fd, const void* b, size_t n) { (void)fd;(void)b;(void)n; return -1; }
ssize_t read(int fd, void* b, size_t n) { (void)fd;(void)b;(void)n; return -1; }
int    close(int fd) { (void)fd; return 0; }
int    dup2(int a, int b) { (void)a;(void)b; return -1; }
int    system(const char* c) { (void)c; return -1; }
FILE*  popen(const char* c, const char* m) { (void)c;(void)m; return (FILE*)0; }
int    pclose(FILE* f) { (void)f; return -1; }
int    waitpid(pid_t p, int* st, int o) { (void)p;(void)st;(void)o; return -1; }
int    mkdir(const char* p, unsigned int m) { (void)p;(void)m; return -1; }
int    stat(const char* p, struct stat* st) { (void)p;(void)st; return -1; }
int    execl(const char* p, const char* a, ...) { (void)p;(void)a; return -1; }
pid_t  fork(void) { return -1; }
/* signals: don't exist in wasm -> no-op registration */
typedef int sig_atomic_t;
#define SIGINT 2
#define SIGTERM 15
#define SIGSEGV 11
#define SIGABRT 6
#define SIGFPE 8
#define SIGILL 4
#define SIG_DFL ((void(*)(int))0)
#define SIG_IGN ((void(*)(int))1)
void (*signal(int sig, void(*h)(int)))(int) { (void)sig;(void)h; return SIG_DFL; }
int    raise(int sig) { (void)sig; return 0; }
int    kill(pid_t p, int sig) { (void)p;(void)sig; return -1; }
int    posix_memalign(void** out, size_t align, size_t sz) { (void)align; void* p=malloc(sz); if(!p) return 12; *out=p; return 0; }
void*  mmap(void* a, size_t l, int pr, int fl, int fd, long off) { (void)a;(void)l;(void)pr;(void)fl;(void)fd;(void)off; return (void*)-1; }
int    munmap(void* a, size_t l) { (void)a;(void)l; return 0; }

/* --- misc libc --- */
int    setvbuf(FILE* f, char* b, int m, size_t s) { (void)f;(void)b;(void)m;(void)s; return 0; }
#define _IOFBF 0
#define _IOLBF 1
#define _IONBF 2
static unsigned long _wasm_rng = 1;
void   srand(unsigned s) { _wasm_rng = s ? s : 1; }
int    rand(void) { _wasm_rng = _wasm_rng*6364136223846793005UL + 1442695040888963407UL; return (int)((_wasm_rng>>33)&0x7fffffff); }
#define RAND_MAX 0x7fffffff
long   time(long* t) { if (t) *t = 0; return 0; }                 /* no wall clock in wasm */
int    setenv(const char* n, const char* v, int o) { (void)n;(void)v;(void)o; return 0; }
int    unsetenv(const char* n) { (void)n; return 0; }
int    putenv(char* s) { (void)s; return 0; }
int    atexit(void(*f)(void)) { (void)f; return 0; }

/* --- math (libm absent in wasm). isnan/isinf/isfinite are REAL (value-model float-to-str may use them);
   the transcendental fns are declarations -- a pure value-model program never calls them (dead-stripped). --- */
int    isnan(double x) { return x != x; }
int    isinf(double x) { return x != 0.0 && x + x == x; }
int    isfinite(double x) { return !isnan(x) && !isinf(x); }
double sin(double),cos(double),tan(double),asin(double),acos(double),atan(double);
double sinh(double),cosh(double),tanh(double),asinh(double),acosh(double),atanh(double);
double exp(double),exp2(double),expm1(double),log(double),log2(double),log10(double),log1p(double);
double sqrt(double),cbrt(double),floor(double),ceil(double),round(double),trunc(double),rint(double),nearbyint(double),fabs(double);
double pow(double,double),atan2(double,double),fmod(double,double),hypot(double,double),copysign(double,double);
double fmax(double,double),fmin(double,double),remainder(double,double),nextafter(double,double),fdim(double,double);
double ldexp(double,int),frexp(double,int*),modf(double,double*),fma(double,double,double);

#include "nova_runtime.c"
