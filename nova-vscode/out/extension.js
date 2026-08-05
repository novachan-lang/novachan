"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
exports.deactivate = deactivate;
const path = __importStar(require("path"));
const cp = __importStar(require("child_process"));
const vscode = __importStar(require("vscode"));
const node_1 = require("vscode-languageclient/node");
let client;
function activate(context) {
    const config = vscode.workspace.getConfiguration('nova');
    const isWin = process.platform === 'win32';
    const ext = isWin ? '.exe' : '';
    // The compiler binary IS the LSP server when run with the 'lsp' subcommand
    // (nova_compiler.nova's lsp_server_main, self-hosted alongside the compiler
    // proper). nova-lsp.exe is kept as an identical copy for back-compat with
    // nova.lsp.path pointing at it directly, but nova-compiler.exe is canonical.
    let serverPath = config.get('lsp.path', '');
    if (!serverPath) {
        serverPath = path.join(context.extensionPath, 'bin', `nova-compiler${ext}`);
    }
    const serverOptions = {
        command: serverPath,
        args: ['lsp'],
        transport: node_1.TransportKind.stdio
    };
    const clientOptions = {
        documentSelector: [
            { scheme: 'file', language: 'nova' }
        ],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.{nova,nv}')
        }
    };
    client = new node_1.LanguageClient('novaLanguageServer', 'NOVA Language Server', serverOptions, clientOptions);
    client.start().catch(err => {
        vscode.window.showWarningMessage(`NOVA LSP server not found. Syntax highlighting is active, but diagnostics/completion require nova-lsp. ` +
            `Set nova.lsp.path in settings or place nova-lsp in PATH.`);
    });
    context.subscriptions.push({
        dispose: () => { if (client)
            client.stop(); }
    });
    // ── DAP debugger ────────────────────────────────────────────────────
    // VS Code's Run-and-Debug panel for NOVA: pre-build the .nova with
    // -O0 -g via the compiler, then hand off to lldb-dap (LLVM's standard
    // DAP adapter). NOVA emits DWARF metadata in the IR pipeline, so
    // lldb resolves breakpoints to .nova source lines.
    const compilerPath = config.get('compiler.path', '') ||
        path.join(context.extensionPath, 'bin', `nova-compiler${ext}`);
    const lldbDapPath = config.get('debug.lldbDapPath', '') ||
        `lldb-dap${ext}`;
    const novaHome = path.join(context.extensionPath, 'bin');
    const dapFactory = {
        createDebugAdapterDescriptor(session) {
            const program = session.configuration.program;
            if (!program || !program.endsWith('.nova')) {
                throw new Error('NOVA debug requires a .nova source file in "program".');
            }
            const cwd = session.configuration.cwd ||
                path.dirname(program);
            const ll = program.replace(/\.nova$/, '.ll');
            const exe = program.replace(/\.nova$/, isWin ? '.exe' : '');
            // Compile + link with -O0 -g (NOVA's nova_link auto-adds -g on -O0).
            const buildEnv = { ...process.env, NOVA_HOME: novaHome };
            const compileRes = cp.spawnSync(compilerPath, ['compile', '-O0', '-o', ll, program], { cwd, env: buildEnv });
            if (compileRes.status !== 0) {
                throw new Error(`nova compile failed:\n${compileRes.stderr?.toString() || compileRes.stdout?.toString()}`);
            }
            // Link via 'nova build' (same binary, different subcommand).
            const linkRes = cp.spawnSync(compilerPath, ['build', '-O0', '-o', exe, program], { cwd, env: buildEnv });
            if (linkRes.status !== 0) {
                throw new Error(`nova build (link) failed:\n${linkRes.stderr?.toString() || linkRes.stdout?.toString()}`);
            }
            // Rewrite the session's program to point at the built .exe so
            // lldb-dap launches it instead of the .nova source.
            session.configuration.program = exe;
            return new vscode.DebugAdapterExecutable(lldbDapPath, []);
        }
    };
    context.subscriptions.push(vscode.debug.registerDebugAdapterDescriptorFactory('nova', dapFactory));
}
function deactivate() {
    return client?.stop();
}
//# sourceMappingURL=extension.js.map