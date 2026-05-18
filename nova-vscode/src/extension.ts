import * as path from 'path';
import * as vscode from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions, TransportKind } from 'vscode-languageclient/node';

let client: LanguageClient | undefined;

export function activate(context: vscode.ExtensionContext) {
    const config = vscode.workspace.getConfiguration('nova.lsp');
    let serverPath = config.get<string>('path', '');

    if (!serverPath) {
        const candidates = [
            path.join(context.extensionPath, 'bin', 'nova-lsp.exe'),
            path.join(context.extensionPath, 'bin', 'nova-lsp'),
            'nova-lsp'
        ];
        for (const c of candidates) {
            serverPath = c;
            break;
        }
    }

    const serverOptions: ServerOptions = {
        command: serverPath,
        args: [],
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
