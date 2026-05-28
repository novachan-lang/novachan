
/* ======== Phase 13 Web: HTTP server stub + JSON + URL routing ======== */

/* nova_rt_json_encode: JSON-stringify any NOVA value to a fat string. */
int64_t nova_rt_json_encode(int64_t val) {
    int64_t raw = nova_rt_json_stringify(val);
    if (!raw) return nova_rt_create_string((void*)"null");
    return nova_rt_create_string((void*)(uintptr_t)raw);
}

/* nova_rt_json_decode: Parse a JSON string into a NOVA value (dict/list/int/string). */
int64_t nova_rt_json_decode(int64_t str_val) {
    return nova_rt_json_parse(str_val);
}

/* nova_rt_http_listen: Bind a TCP socket on port for HTTP. Returns server handle. */
int64_t nova_rt_http_listen(int64_t port_val) {
    return nova_rt_tcp_listen(port_val);
}

/* nova_rt_http_close: Close an HTTP server socket. */
int64_t nova_rt_http_close(int64_t server_handle) {
    if (server_handle > 0) NOVA_CLOSE_SOCKET((NOVA_SOCKET)server_handle);
    return 0;
}

/* nova_rt_route_match: Match URL pattern (e.g. "/users/:id") against a path.
   Returns a dict of named param values, or empty dict on mismatch. */
int64_t nova_rt_route_match(int64_t pattern_val, int64_t path_val) {
    int64_t result = nova_rt_dict_create();
    if (!pattern_val || !path_val) return result;
    const char *pat  = (const char*)(uintptr_t)pattern_val;
    const char *path = (const char*)(uintptr_t)path_val;
    char path_seg[256], param_name[128];
    const char *pp = pat, *ph = path;
    while (1) {
        while (*pp == '/') pp++;
        while (*ph == '/') ph++;
        if (*pp == '\0' && *ph == '\0') break;
        if (*pp == '\0' || *ph == '\0') return nova_rt_dict_create();
        const char *ps_end = strchr(pp, '/'); if (!ps_end) ps_end = pp + strlen(pp);
        const char *ph_end = strchr(ph, '/'); if (!ph_end) ph_end = ph + strlen(ph);
        size_t ps_len = (size_t)(ps_end - pp);
        size_t ph_len = (size_t)(ph_end - ph);
        if (ps_len > 0 && pp[0] == ':') {
            size_t klen = ps_len - 1; if (klen > 127) klen = 127;
            memcpy(param_name, pp+1, klen); param_name[klen] = '\0';
            size_t vlen = ph_len; if (vlen > 255) vlen = 255;
            memcpy(path_seg, ph, vlen); path_seg[vlen] = '\0';
            int64_t k = nova_rt_create_string((void*)param_name);
            int64_t v = nova_rt_create_string((void*)path_seg);
            nova_rt_dict_set(result, k, v);
        } else {
            if (ps_len != ph_len || memcmp(pp, ph, ps_len) != 0) return nova_rt_dict_create();
        }
        pp = ps_end; ph = ph_end;
    }
    return result;
}

/* ======== Phase 13 AI: Tensor operations ======== */

typedef struct { int64_t *data; int64_t size; int valid; } NovaTensor;
static NovaTensor g_tensors[256];
static int g_tensor_count = 0;

/* nova_rt_tensor_create: Create a zero-initialized tensor of `size` int64 elements. */
int64_t nova_rt_tensor_create(int64_t size) {
    if (size <= 0 || g_tensor_count >= 256) return -1;
    int64_t *data = (int64_t*)calloc((size_t)size, sizeof(int64_t));
    if (!data) return -1;
    int idx = g_tensor_count++;
    g_tensors[idx].data = data;
    g_tensors[idx].size = size;
    g_tensors[idx].valid = 1;
    return (int64_t)idx;
}

/* nova_rt_tensor_free: Release a tensor. */
int64_t nova_rt_tensor_free(int64_t handle) {
    int h = (int)handle;
    if (h >= 0 && h < g_tensor_count && g_tensors[h].valid) {
        free(g_tensors[h].data);
        g_tensors[h].data = NULL;
        g_tensors[h].valid = 0;
    }
    return 0;
}

/* nova_rt_tensor_set: Write a value at index. */
int64_t nova_rt_tensor_set(int64_t handle, int64_t idx, int64_t val) {
    int h = (int)handle;
    if (h < 0 || h >= g_tensor_count || !g_tensors[h].valid) return -1;
    if (idx < 0 || idx >= g_tensors[h].size) return -1;
    g_tensors[h].data[idx] = val;
    return 0;
}

/* nova_rt_tensor_get: Read a value at index. */
int64_t nova_rt_tensor_get(int64_t handle, int64_t idx) {
    int h = (int)handle;
    if (h < 0 || h >= g_tensor_count || !g_tensors[h].valid) return 0;
    if (idx < 0 || idx >= g_tensors[h].size) return 0;
    return g_tensors[h].data[idx];
}

/* nova_rt_tensor_fill: Fill all elements with val. */
int64_t nova_rt_tensor_fill(int64_t handle, int64_t val) {
    int h = (int)handle;
    if (h < 0 || h >= g_tensor_count || !g_tensors[h].valid) return -1;
    for (int64_t i = 0; i < g_tensors[h].size; i++) g_tensors[h].data[i] = val;
    return 0;
}

/* nova_rt_tensor_size: Return the number of elements. */
int64_t nova_rt_tensor_size(int64_t handle) {
    int h = (int)handle;
    if (h < 0 || h >= g_tensor_count || !g_tensors[h].valid) return 0;
    return g_tensors[h].size;
}

/* nova_rt_tensor_add: Elementwise addition; returns new tensor. */
int64_t nova_rt_tensor_add(int64_t a_handle, int64_t b_handle) {
    int a = (int)a_handle, b_idx = (int)b_handle;
    if (a < 0 || a >= g_tensor_count || !g_tensors[a].valid) return -1;
    if (b_idx < 0 || b_idx >= g_tensor_count || !g_tensors[b_idx].valid) return -1;
    int64_t sz = g_tensors[a].size < g_tensors[b_idx].size ? g_tensors[a].size : g_tensors[b_idx].size;
    int64_t c = nova_rt_tensor_create(sz);
    if (c < 0) return -1;
    int ci = (int)c;
    for (int64_t i = 0; i < sz; i++) g_tensors[ci].data[i] = g_tensors[a].data[i] + g_tensors[b_idx].data[i];
    return c;
}

/* nova_rt_tensor_dot: Dot product; returns scalar. */
int64_t nova_rt_tensor_dot(int64_t a_handle, int64_t b_handle) {
    int a = (int)a_handle, b_idx = (int)b_handle;
    if (a < 0 || a >= g_tensor_count || !g_tensors[a].valid) return 0;
    if (b_idx < 0 || b_idx >= g_tensor_count || !g_tensors[b_idx].valid) return 0;
    int64_t sz = g_tensors[a].size < g_tensors[b_idx].size ? g_tensors[a].size : g_tensors[b_idx].size;
    int64_t sum = 0;
    for (int64_t i = 0; i < sz; i++) sum += g_tensors[a].data[i] * g_tensors[b_idx].data[i];
    return sum;
}

/* Model stub */
typedef struct { char path[1024]; int valid; } NovaModel;
static NovaModel g_models[32];
static int g_model_count = 0;

/* nova_rt_model_load: Register a model file. Returns handle, -1 if file not found. */
int64_t nova_rt_model_load(int64_t path_val) {
    if (!path_val || g_model_count >= 32) return -1;
    const char *path = (const char*)(uintptr_t)path_val;
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    fclose(f);
    int idx = g_model_count++;
    strncpy(g_models[idx].path, path, 1023); g_models[idx].path[1023] = '\0';
    g_models[idx].valid = 1;
    return (int64_t)idx;
}

/* nova_rt_model_close: Release a model handle. */
int64_t nova_rt_model_close(int64_t handle) {
    int idx = (int)handle;
    if (idx >= 0 && idx < g_model_count && g_models[idx].valid) g_models[idx].valid = 0;
    return 0;
}

/* nova_rt_model_infer: Run inference; stub returns copy of input tensor (identity). */
int64_t nova_rt_model_infer(int64_t model_handle, int64_t input_handle) {
    int m = (int)model_handle, inp = (int)input_handle;
    if (m < 0 || m >= g_model_count || !g_models[m].valid) return -1;
    if (inp < 0 || inp >= g_tensor_count || !g_tensors[inp].valid) return -1;
    int64_t out = nova_rt_tensor_create(g_tensors[inp].size);
    if (out < 0) return -1;
    int oi = (int)out;
    for (int64_t i = 0; i < g_tensors[inp].size; i++) g_tensors[oi].data[i] = g_tensors[inp].data[i];
    return out;
}

/* ======== Phase 13 Game: Entity-Component System ======== */

#define NOVA_ECS_MAX_WORLDS 8
#define NOVA_ECS_MAX_COMPS 16384

typedef struct { int64_t entity_id; char comp_name[64]; int64_t comp_value; int valid; } NovaEcsComp;
typedef struct { NovaEcsComp *comps; int comp_count; int next_entity; int valid; } NovaEcsWorld;
static NovaEcsWorld g_ecs_worlds[NOVA_ECS_MAX_WORLDS];
static int g_ecs_world_count = 0;

/* nova_rt_ecs_world: Create a new ECS world. Returns world handle. */
int64_t nova_rt_ecs_world(void) {
    if (g_ecs_world_count >= NOVA_ECS_MAX_WORLDS) return -1;
    int idx = g_ecs_world_count++;
    g_ecs_worlds[idx].comps = (NovaEcsComp*)calloc(NOVA_ECS_MAX_COMPS, sizeof(NovaEcsComp));
    if (!g_ecs_worlds[idx].comps) return -1;
    g_ecs_worlds[idx].comp_count = 0;
    g_ecs_worlds[idx].next_entity = 1;
    g_ecs_worlds[idx].valid = 1;
    return (int64_t)idx;
}

/* nova_rt_ecs_entity: Allocate a fresh entity id. */
int64_t nova_rt_ecs_entity(int64_t world_handle) {
    int w = (int)world_handle;
    if (w < 0 || w >= g_ecs_world_count || !g_ecs_worlds[w].valid) return -1;
    return (int64_t)(g_ecs_worlds[w].next_entity++);
}

/* nova_rt_ecs_set: Attach or update a component on an entity. */
int64_t nova_rt_ecs_set(int64_t world_handle, int64_t entity_id, int64_t comp_name_val, int64_t val) {
    int w = (int)world_handle;
    if (w < 0 || w >= g_ecs_world_count || !g_ecs_worlds[w].valid) return -1;
    const char *name = (const char*)(uintptr_t)comp_name_val;
    if (!name) return -1;
    NovaEcsWorld *world = &g_ecs_worlds[w];
    for (int i = 0; i < world->comp_count; i++) {
        if (world->comps[i].valid && world->comps[i].entity_id == entity_id &&
            strncmp(world->comps[i].comp_name, name, 63) == 0) {
            world->comps[i].comp_value = val;
            return 0;
        }
    }
    if (world->comp_count >= NOVA_ECS_MAX_COMPS) return -1;
    int slot = world->comp_count++;
    world->comps[slot].entity_id = entity_id;
    strncpy(world->comps[slot].comp_name, name, 63); world->comps[slot].comp_name[63] = '\0';
    world->comps[slot].comp_value = val;
    world->comps[slot].valid = 1;
    return 0;
}

/* nova_rt_ecs_get: Read a component value. Returns 0 if absent. */
int64_t nova_rt_ecs_get(int64_t world_handle, int64_t entity_id, int64_t comp_name_val) {
    int w = (int)world_handle;
    if (w < 0 || w >= g_ecs_world_count || !g_ecs_worlds[w].valid) return 0;
    const char *name = (const char*)(uintptr_t)comp_name_val;
    if (!name) return 0;
    NovaEcsWorld *world = &g_ecs_worlds[w];
    for (int i = 0; i < world->comp_count; i++) {
        if (world->comps[i].valid && world->comps[i].entity_id == entity_id &&
            strncmp(world->comps[i].comp_name, name, 63) == 0)
            return world->comps[i].comp_value;
    }
    return 0;
}

/* nova_rt_ecs_has: Returns 1 if entity has the component. */
int64_t nova_rt_ecs_has(int64_t world_handle, int64_t entity_id, int64_t comp_name_val) {
    int w = (int)world_handle;
    if (w < 0 || w >= g_ecs_world_count || !g_ecs_worlds[w].valid) return 0;
    const char *name = (const char*)(uintptr_t)comp_name_val;
    if (!name) return 0;
    NovaEcsWorld *world = &g_ecs_worlds[w];
    for (int i = 0; i < world->comp_count; i++) {
        if (world->comps[i].valid && world->comps[i].entity_id == entity_id &&
            strncmp(world->comps[i].comp_name, name, 63) == 0)
            return 1;
    }
    return 0;
}

/* nova_rt_ecs_query: Return list of entity ids that have the named component. */
int64_t nova_rt_ecs_query(int64_t world_handle, int64_t comp_name_val) {
    int64_t result = nova_rt_list_create();
    int w = (int)world_handle;
    if (w < 0 || w >= g_ecs_world_count || !g_ecs_worlds[w].valid) return result;
    const char *name = (const char*)(uintptr_t)comp_name_val;
    if (!name) return result;
    NovaEcsWorld *world = &g_ecs_worlds[w];
    for (int i = 0; i < world->comp_count; i++) {
        if (world->comps[i].valid && strncmp(world->comps[i].comp_name, name, 63) == 0)
            nova_rt_list_append(result, world->comps[i].entity_id);
    }
    return result;
}

/* nova_rt_ecs_destroy: Remove all components for an entity. */
int64_t nova_rt_ecs_destroy(int64_t world_handle, int64_t entity_id) {
    int w = (int)world_handle;
    if (w < 0 || w >= g_ecs_world_count || !g_ecs_worlds[w].valid) return -1;
    NovaEcsWorld *world = &g_ecs_worlds[w];
    for (int i = 0; i < world->comp_count; i++) {
        if (world->comps[i].valid && world->comps[i].entity_id == entity_id)
            world->comps[i].valid = 0;
    }
    return 0;
}

/* ======== Phase 14: Deployment, Semver, Deprecation ======== */

/* nova_rt_deploy_config: Create a deployment config dict for provider+app. */
int64_t nova_rt_deploy_config(int64_t provider_val, int64_t app_val) {
    int64_t cfg = nova_rt_dict_create();
    if (!provider_val || !app_val) return cfg;
    int64_t k1 = nova_rt_create_string((void*)"provider");
    int64_t k2 = nova_rt_create_string((void*)"app");
    int64_t k3 = nova_rt_create_string((void*)"status");
    int64_t v3 = nova_rt_create_string((void*)"configured");
    nova_rt_dict_set(cfg, k1, provider_val);
    nova_rt_dict_set(cfg, k2, app_val);
    nova_rt_dict_set(cfg, k3, v3);
    return cfg;
}

/* nova_rt_deploy_validate: Validate a deploy config. Returns "" on success. */
int64_t nova_rt_deploy_validate(int64_t config_val) {
    if (!config_val) return nova_rt_create_string((void*)"error: null config");
    return nova_rt_create_string((void*)"");
}

/* Semver parsing helper */
typedef struct { int major; int minor; int patch; } NovaSemVer;
static void nova_parse_semver(const char *s, NovaSemVer *v) {
    v->major = v->minor = v->patch = 0;
    if (!s) return;
    if (*s == 'v') s++;
    char *end;
    v->major = (int)strtol(s, &end, 10);
    if (*end != '.') return;
    s = end + 1;
    v->minor = (int)strtol(s, &end, 10);
    if (*end != '.') return;
    s = end + 1;
    v->patch = (int)strtol(s, NULL, 10);
}

/* nova_rt_semver_parse: Parse semver string into dict {major, minor, patch}. */
int64_t nova_rt_semver_parse(int64_t s_val) {
    int64_t result = nova_rt_dict_create();
    NovaSemVer v = {0,0,0};
    if (s_val) nova_parse_semver((const char*)(uintptr_t)s_val, &v);
    int64_t kmaj = nova_rt_create_string((void*)"major");
    int64_t kmin = nova_rt_create_string((void*)"minor");
    int64_t kpat = nova_rt_create_string((void*)"patch");
    nova_rt_dict_set(result, kmaj, (int64_t)v.major);
    nova_rt_dict_set(result, kmin, (int64_t)v.minor);
    nova_rt_dict_set(result, kpat, (int64_t)v.patch);
    return result;
}

/* nova_rt_semver_compare: Compare two semver strings. Returns -1, 0, or 1. */
int64_t nova_rt_semver_compare(int64_t v1_val, int64_t v2_val) {
    NovaSemVer v1={0,0,0}, v2={0,0,0};
    if (v1_val) nova_parse_semver((const char*)(uintptr_t)v1_val, &v1);
    if (v2_val) nova_parse_semver((const char*)(uintptr_t)v2_val, &v2);
    if (v1.major != v2.major) return v1.major < v2.major ? -1 : 1;
    if (v1.minor != v2.minor) return v1.minor < v2.minor ? -1 : 1;
    if (v1.patch != v2.patch) return v1.patch < v2.patch ? -1 : 1;
    return 0;
}

/* nova_rt_semver_compatible: Returns 1 if same major version (semver compat rule). */
int64_t nova_rt_semver_compatible(int64_t v1_val, int64_t v2_val) {
    NovaSemVer v1={0,0,0}, v2={0,0,0};
    if (v1_val) nova_parse_semver((const char*)(uintptr_t)v1_val, &v1);
    if (v2_val) nova_parse_semver((const char*)(uintptr_t)v2_val, &v2);
    return v1.major == v2.major ? 1 : 0;
}

/* nova_rt_deprecated_warn: Emit a deprecation warning to stderr. */
int64_t nova_rt_deprecated_warn(int64_t name_val, int64_t msg_val) {
    const char *name = name_val ? (const char*)(uintptr_t)name_val : "unknown";
    const char *msg  = msg_val  ? (const char*)(uintptr_t)msg_val  : "";
    fprintf(stderr, "DEPRECATED: %s - %s\n", name, msg);
    return 0;
}
