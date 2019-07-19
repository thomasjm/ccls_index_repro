#!/bin/bash

. initialize.sh

sleep 1
echo $'\n\n*** Sending didOpen command ***\n'

rawDidOpenCommand='{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"","languageId":"c","version":0,"text":""}}}'
didOpenCommand=$(echo "$rawDidOpenCommand" | jq -c "setpath([\"params\", \"textDocument\", \"uri\"]; \"file://${home}/foo.c\")")
sendCommand cclsPipe "$didOpenCommand"

sleep 1
echo $'\n\n*** Sending textDocument/didChange command ***\n'

rawChangeCommand='{"jsonrpc":"2.0","method":"textDocument/didChange","params":{"textDocument":{"version":1,"uri":""},"contentChanges":[{"text":"#include <stdio.h>\n\nint main() {\n    printf();\n}","range":{"start":{"line":0,"character":0},"end":{"line":0,"character":0}},"rangeLength":0}]}}';
changeCommand=$(echo "$rawChangeCommand" | jq -c "setpath([\"params\", \"textDocument\", \"uri\"]; \"file://${home}/foo.c\")")
sendCommand cclsPipe "$changeCommand"

sleep 1
echo $'\n\n*** Sending textDocument/documentSymbol command ***\n'

rawSymbolsCommand='{"jsonrpc":"2.0","id":"2","method":"textDocument/documentSymbol","params":{"textDocument":{"uri":""}}}'
symbolsCommand=$(echo "$rawSymbolsCommand" | jq -c "setpath([\"params\", \"textDocument\", \"uri\"]; \"file://${home}/foo.c\")")
sendCommand cclsPipe "$symbolsCommand"

echo "Should see a documentSymbol response with a 'main' symbol below"
