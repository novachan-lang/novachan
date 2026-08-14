# prism/text — the text model

Needed by BOTH backends (unlike layout, which the DOM backend gets from CSS for free). Not started.

| Module | Purpose |
|---|---|
| `prism_textmodel.nova` | Document model shared by plain labels and rich text |
| `prism_richedit.nova` | Rich text editing (feature #62) -- ProseMirror-class; ~3-4 pm, no `contenteditable` shortcut on the GPU backend |
| `prism_select.nova` | Selection + caret |
| `prism_find.nova` | In-app find (replaces Ctrl+F on the GPU backend, where there is no browser find-in-page) |
