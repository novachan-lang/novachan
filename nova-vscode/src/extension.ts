import * as path from 'path';
import * as cp from 'child_process';
import * as vscode from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions, TransportKind } from 'vscode-languageclient/node';

let client: LanguageClient | undefined;

export function activate(context: vscode.ExtensionContext) {
    const config = vscode.workspace.getConfiguration('nova');
    const isWin = process.platform === 'win32';
    const ext = isWin ? '.exe' : '';

    // The compiler binary is the LSP server when run with the 'lsp' subcommand.
    // (Prior versions shipped a separate nova-lsp.exe; that's now a copy of
    // nova-compiler.exe and either path works.)
    let serverPath = config.get<string>('lsp.path', '');
    if (!serverPath) {
        serverPath = path.join(context.extensionPath, 'bin', `nova-compiler${ext}`);
    }

    const serverOptions: ServerOptions = {
        command: serverPath,
        args: ['lsp'],
        transport: TransportKind.stdio
    };

    const clientOptions: LanguageClientOptions = {
        documentSelector: [
            { scheme: 'file', language: 'nova' }
        ],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.{nova,nv}')
        }
    };

    client = new LanguageClient(
        'novaLanguageServer',
        'NOVA Language Server',
        serverOptions,
        clientOptions
    );

    client.start().catch(err => {
        vscode.window.showWarningMessage(
            `NOVA LSP server not found. Syntax highlighting is active, but diagnostics/completion require nova-lsp. ` +
            `Set nova.lsp.path in settings or place nova-lsp in PATH.`
        );
    });

    context.subscriptions.push({
        dispose: () => { if (client) client.stop(); }
    });

    // ── DAP debugger ────────────────────────────────────────────────────
    // VS Code's Run-and-Debug panel for NOVA: pre-build the .nova with
    // -O0 -g via the compiler, then hand off to lldb-dap (LLVM's standard
    // DAP adapter). NOVA emits DWARF metadata in the IR pipeline, so
    // lldb resolves breakpoints to .nova source lines.
    const compilerPath = config.get<string>('compiler.path', '') ||
        path.join(context.extensionPath, 'bin', `nova-compiler${ext}`);
    const lldbDapPath = config.get<string>('debug.lldbDapPath', '') ||
        `lldb-dap${ext}`;
    const novaHome = path.join(context.extensionPath, 'bin');

    const dapFactory: vscode.DebugAdapterDescriptorFactory = {
        createDebugAdapterDescriptor(session) {
            const program = session.configuration.program as string;
            if (!program || !program.endsWith('.nova')) {
                throw new Error('NOVA debug requires a .nova source file in "program".');
            }
            const cwd = (session.configuration.cwd as string) ||
                path.dirname(program);
            const ll = program.replace(/\.nova$/, '.ll');
            const exe = program.replace(/\.nova$/, isWin ? '.exe' : '');
            // Compile + link with -O0 -g (NOVA's nova_link auto-adds -g on -O0).
            const buildEnv = { ...process.env, NOVA_HOME: novaHome };
            const compileRes = cp.spawnSync(compilerPath,
                ['compile', '-O0', '-o', ll, program], { cwd, env: buildEnv });
            if (compileRes.status !== 0) {
                throw new Error(`nova compile failed:\n${compileRes.stderr?.toString() || compileRes.stdout?.toString()}`);
            }
            // Link via 'nova build' (same binary, different subcommand).
            const linkRes = cp.spawnSync(compilerPath,
                ['build', '-O0', '-o', exe, program], { cwd, env: buildEnv });
            if (linkRes.status !== 0) {
                throw new Error(`nova build (link) failed:\n${linkRes.stderr?.toString() || linkRes.stdout?.toString()}`);
            }
            // Rewrite the session's program to point at the built .exe so
            // lldb-dap launches it instead of the .nova source.
            (session.configuration as unknown as { program: string }).program = exe;
            return new vscode.DebugAdapterExecutable(lldbDapPath, []);
        }
    };
    context.subscriptions.push(
        vscode.debug.registerDebugAdapterDescriptorFactory('nova', dapFactory)
    );
}

export function deactivate(): Thenable<void> | undefined {
    return client?.stop();
}
