import re

with open('nova_runtime.c', 'r', encoding='utf-8') as f:
    content = f.read()

old_accept = '''int64_t nova_rt_tcp_accept(int64_t server_val) {
    NOVA_SOCKET server = (NOVA_SOCKET)server_val;
    struct sockaddr_in client_addr;
    int addrlen = sizeof(client_addr);
#ifdef _WIN32
    NOVA_SOCKET client = accept(server, (struct sockaddr*)&client_addr, &addrlen);
#else
    socklen_t slen = (socklen_t)addrlen;
    NOVA_SOCKET client = accept(server, (struct sockaddr*)&client_addr, &slen);
#endif
    if (client == NOVA_INVALID_SOCKET) {
        nova_set_error("tcp_accept: accept failed");
        return -1;
    }
    return (int64_t)client;
}'''

new_accept = '''int64_t nova_rt_tcp_accept(int64_t server_val) {
    NOVA_SOCKET server = (NOVA_SOCKET)server_val;
    if (nova_sched_in_task()) {
        nova_rt_io_set_nonblocking(server_val);
        for (;;) {
            struct sockaddr_in ca;
            int al = sizeof(ca);
#ifdef _WIN32
            NOVA_SOCKET c = accept(server, (struct sockaddr*)&ca, &al);
            if (c != NOVA_INVALID_SOCKET) return (int64_t)c;
            if (WSAGetLastError() != WSAEWOULDBLOCK) break;
#else
            socklen_t sl = (socklen_t)al;
            NOVA_SOCKET c = accept(server, (struct sockaddr*)&ca, &sl);
            if (c != NOVA_INVALID_SOCKET) return (int64_t)c;
            if (errno != EAGAIN && errno != EWOULDBLOCK) break;
#endif
            nova_sched_park_io(server_val, NOVA_POLL_READ);
        }
        nova_set_error("tcp_accept: accept failed (green)");
        return -1;
    }
    struct sockaddr_in client_addr;
    int addrlen = sizeof(client_addr);
#ifdef _WIN32
    NOVA_SOCKET client = accept(server, (struct sockaddr*)&client_addr, &addrlen);
#else
    socklen_t slen = (socklen_t)addrlen;
    NOVA_SOCKET client = accept(server, (struct sockaddr*)&client_addr, &slen);
#endif
    if (client == NOVA_INVALID_SOCKET) {
        nova_set_error("tcp_accept: accept failed");
        return -1;
    }
    return (int64_t)client;
}'''

if old_accept in content:
    content = content.replace(old_accept, new_accept)
    with open('nova_runtime.c', 'w', encoding='utf-8') as f:
        f.write(content)
    print("tcp_accept patched")
else:
    print("ACCEPT NOT FOUND")
