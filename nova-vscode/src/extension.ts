import * as path from 'path';
import * as vscode from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions, TransportKind } from 'vscode-languageclient/node';

let client: LanguageClient | undefined;

export function activate(context: vscode.ExtensionContext) {
    const config = vscode.workspace.getConfiguration('nova');

    // Resolve LSP server binary
    let serverPath = config.get<string>('lsp.path', '');
    if (!serverPath) {
        const isWin = process.platform === 'win32';
        const ext = isWin ? '.exe' : '';
        serverPath = path.join(context.extensionPath, 'bin', `nova-lsp${ext}`);
    }

    // Resolve compiler binary — passed as arg[1] to the LSP server
    let compilerPath = config.get<string>('compiler.path', '');
    if (!compilerPath) {
        const isWin = process.platform === 'win32';
        const ext = isWin ? '.exe' : '';
        compilerPath = path.join(context.extensionPath, 'bin', `nova-compiler${ext}`);
    }

    const serverOptions: ServerOptions = {
        command: serverPath,
        args: [compilerPath],
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
}

export function deactivate(): Thenable<void> | undefined {
    return client?.stop();
}
