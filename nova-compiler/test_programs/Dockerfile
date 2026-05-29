# Deploy NOVA's ai_serve (full-stack AI inference HTTP service) to Linux / Railway.
#
# NOTE: the NOVA compiler is Windows-hosted today, so the Linux LLVM IR is produced
# on the host first:  gen3_test.exe compile --target linux -o ai_serve_linux.ll ai_serve.nova
# (see _deploy_prep.ps1). This image then builds that IR + the C runtime with clang.
FROM debian:stable-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends clang ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY ai_serve_linux.ll output/nova_runtime.c ./
RUN clang -O2 -o ai_serve ai_serve_linux.ll nova_runtime.c -lpthread -lm -w

FROM debian:stable-slim
WORKDIR /app
COPY --from=build /src/ai_serve /app/ai_serve
ENV PORT=8080
EXPOSE 8080
# Railway injects $PORT; ai_serve takes the listen port as argv[1].
CMD ["/bin/sh","-c","/app/ai_serve ${PORT}"]
