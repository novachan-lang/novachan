// Minimal LSP client that talks to the NOVA LSP server over stdin/stdout.
// Exercises: initialize -> didOpen (broken file) -> wait for diagnostics ->
// didOpen (clean file) -> wait for diagnostics -> shutdown -> exit.

const { spawn } = require('child_process');
const path = require('path');

function frame(obj) {
  const body = JSON.stringify(obj);
  return `Content-Length: ${Buffer.byteLength(body, 'utf8')}\r\n\r\n${body}`;
}

class LspBuffer {
  constructor(onMessage) {
    this.buf = Buffer.alloc(0);
    this.onMessage = onMessage;
  }
  push(chunk) {
    this.buf = Buffer.concat([this.buf, chunk]);
    while (true) {
      const headerEnd = this.buf.indexOf('\r\n\r\n');
      if (headerEnd < 0) return;
      const header = this.buf.slice(0, headerEnd).toString('utf8');
      const m = /Content-Length:\s*(\d+)/i.exec(header);
      if (!m) { this.buf = this.buf.slice(headerEnd + 4); continue; }
      const len = parseInt(m[1], 10);
      const total = headerEnd + 4 + len;
      if (this.buf.length < total) return;
      const body = this.buf.slice(headerEnd + 4, total).toString('utf8');
      this.buf = this.buf.slice(total);
      try { this.onMessage(JSON.parse(body)); }
      catch (e) { console.error('parse error:', body); }
    }
  }
}

async function main() {
  const exe = path.resolve('lsp_server.exe');
  console.log('=== starting server:', exe);
  const proc = spawn(exe, [], { stdio: ['pipe', 'pipe', 'pipe'] });

  const messages = [];
  const buf = new LspBuffer(msg => {
    console.log('<- server:', JSON.stringify(msg).slice(0, 200));
    messages.push(msg);
  });

  proc.stdout.on('data', d => buf.push(d));
  proc.stderr.on('data', d => process.stderr.write('[server stderr] ' + d));

  const send = msg => {
    console.log('-> client:', JSON.stringify(msg).slice(0, 200));
    proc.stdin.write(frame(msg));
  };

  // 1. initialize
  send({ jsonrpc: '2.0', id: 1, method: 'initialize', params: { capabilities: {} } });
  await new Promise(r => setTimeout(r, 500));

  // 2. initialized notification
  send({ jsonrpc: '2.0', method: 'initialized', params: {} });
  await new Promise(r => setTimeout(r, 200));

  // 3. didOpen with broken file (should produce diagnostics)
  send({
    jsonrpc: '2.0',
    method: 'textDocument/didOpen',
    params: {
      textDocument: {
        uri: 'file:///tmp/broken.nova',
        languageId: 'nova',
        version: 1,
        text: 'fn main()\n    let x = undefined_function(42)\n    print(x)\n',
      },
    },
  });
  await new Promise(r => setTimeout(r, 2000));

  // 4. didChange — replace with clean code (should produce no diagnostics)
  send({
    jsonrpc: '2.0',
    method: 'textDocument/didChange',
    params: {
      textDocument: { uri: 'file:///tmp/broken.nova', version: 2 },
      contentChanges: [{ text: 'fn main()\n    print("hello from nova!")\n' }],
    },
  });
  await new Promise(r => setTimeout(r, 2000));

  // 5. hover over "print" (line 1, char 4)
  send({
    jsonrpc: '2.0',
    id: 10,
    method: 'textDocument/hover',
    params: {
      textDocument: { uri: 'file:///tmp/broken.nova' },
      position: { line: 1, character: 6 },
    },
  });
  await new Promise(r => setTimeout(r, 500));

  // 6. completion request
  send({
    jsonrpc: '2.0',
    id: 11,
    method: 'textDocument/completion',
    params: {
      textDocument: { uri: 'file:///tmp/broken.nova' },
      position: { line: 1, character: 8 },
    },
  });
  await new Promise(r => setTimeout(r, 500));

  // 7. shutdown + exit
  send({ jsonrpc: '2.0', id: 2, method: 'shutdown' });
  await new Promise(r => setTimeout(r, 300));
  send({ jsonrpc: '2.0', method: 'exit' });
  await new Promise(r => setTimeout(r, 500));

  proc.kill();

  // Report
  console.log('\n=== Results ===');
  const initResp = messages.find(m => m.id === 1);
  console.log('initialize result:', initResp ? '✓ got capabilities' : '✗ MISSING');

  const diags = messages.filter(m => m.method === 'textDocument/publishDiagnostics');
  console.log(`diagnostic notifications: ${diags.length}`);
  for (const d of diags) {
    const items = d.params.diagnostics;
    console.log(`  uri=${d.params.uri} count=${items.length}`);
    for (const it of items) {
      console.log(`    line ${it.range.start.line}: ${it.message}`);
    }
  }

  const hoverResp = messages.find(m => m.id === 10);
  if (hoverResp && hoverResp.result && hoverResp.result.contents) {
    console.log('hover response: ✓', JSON.stringify(hoverResp.result.contents).slice(0, 150));
  } else if (hoverResp && hoverResp.result === null) {
    console.log('hover response: ✗ null (no hover info found)');
  } else {
    console.log('hover response: ✗ MISSING');
  }

  const compResp = messages.find(m => m.id === 11);
  if (compResp && compResp.result && compResp.result.items) {
    console.log(`completion response: ✓ ${compResp.result.items.length} items`);
    for (const it of compResp.result.items.slice(0, 5)) {
      console.log(`  ${it.label}: ${it.detail || '(no detail)'}`);
    }
  } else {
    console.log('completion response: ✗ MISSING');
  }

  const shutResp = messages.find(m => m.id === 2);
  console.log('shutdown response:', shutResp ? '✓' : '✗');
}

main().catch(e => { console.error(e); process.exit(1); });
