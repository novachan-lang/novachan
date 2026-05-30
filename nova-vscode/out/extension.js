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
const vscode = __importStar(require("vscode"));
const node_1 = require("vscode-languageclient/node");
let client;
function activate(context) {
    const config = vscode.workspace.getConfiguration('nova');
    // The compiler binary is the LSP server when run with the 'lsp' subcommand.
    // (Prior versions shipped a separate nova-lsp.exe; that's now a copy of
    // nova-compiler.exe and either path works.)
    let serverPath = config.get('lsp.path', '');
    if (!serverPath) {
        const isWin = process.platform === 'win32';
        const ext = isWin ? '.exe' : '';
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
}
function deactivate() {
    return client?.stop();
}
//# sourceMappingURL=extension.js.map