#!/bin/bash

. initialize.sh

sleep 1
echo $'\n\n*** Sending didOpen command ***\n'

rawDidOpenCommand='{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"","languageId":"c","version":0,"text":"#include <stdio.h>\n\nint main() {\n  printf(\"Hello world\n\");\n}\n"}}}'
didOpenCommand=$(echo "$rawDidOpenCommand" | jq -c "setpath([\"params\", \"textDocument\", \"uri\"]; \"file://${home}/test.c\")")
sendCommand cclsPipe "$didOpenCommand"

sleep 1
echo $'\n\n*** Sending textDocument/documentSymbol command ***\n'

rawSymbolsCommand='{"jsonrpc":"2.0","id":"2","method":"textDocument/documentSymbol","params":{"textDocument":{"uri":""}}}'
symbolsCommand=$(echo "$rawSymbolsCommand" | jq -c "setpath([\"params\", \"textDocument\", \"uri\"]; \"file://${home}/test.c\")")
sendCommand cclsPipe "$symbolsCommand"

echo "Should see a documentSymbol response with a 'main' symbol below"
