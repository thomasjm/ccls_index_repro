
# Reproduction for an indexing issue in `ccls`

The issue I'm seeing is that `ccls` does not properly index files in response to a `textDocument/didChange` event.

The specific problem I'm seeing happens with the following steps:

1. Launch `ccls` with options `{"index": {"onChange": true}}`
2. Create a blank file by sending a `textDocument/didOpen` command with empty text.
3. Send a `textDocument/didChange` command that updates the contents of the file to something simple. I'm using

```c
#include <stdio.h>

int main() {
    printf();
}
```

3. Send a command such as `textDocument/documentSymbol`. It comes back with no symbols, when it should contain a single symbol `main`. Other things like `textDocument/hover` on the `printf` also don't work.

Interestingly, it **does** publish diagnostics correctly. The example code I'm using produces a warning that `printf` is called with too few arguments, and this diagnostic appears after the code is added.

# About this repo

This repo contains two files,

* `./ccls_repro_existingfile.sh`: this script **works**. It sends a `textDocument/didOpen` command with the code already filled in. Then it sends a `textDocument/documentSymbol`, and we get back a successful result with a `main` symbol.

* `./ccls_repro_newfile.sh`: this script **does not work**. It starts with an empty document, and then does a `didChange` command to fill in the code. When it sends `textDocument/documentSymbol`, the result is empty.

Also, the log output contains much less stuff when `./ccls_repro_newfile.sh` is run.
