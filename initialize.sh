#!/bin/bash

function sendCommand {
    path="$1"
    contents="$2"
    echo $'\n\n'
    echo "SENDING: $contents"

    echo -n "Content-Length: ${#contents}" > $path
    echo -n $'\r\n\r\n' > $path
    echo -n "$contents" > $path
}

# Set up the home directory
home=$(mktemp -d -t ccls-debug-XXXXX)
echo "Using home directory $home"
cd $home
touch $home/.ccls
echo $'#include <stdio.h>\n\nint main() {\n  printf("Hello world\n");\n}\n' > test.c

# Start ccls with a pipe input
mkfifo cclsPipe
ccls -log-file=/tmp/ccls_log.log -v=1 --init='{"index": {"onChange": true}}' < cclsPipe &
sleep infinity > cclsPipe & # Keep pipe open

# Kill jobs on exit
trap 'kill $(jobs -p)' EXIT

rawInitializeCommand='{"jsonrpc":"2.0","id":"1","method":"initialize","params":{"rootPath":"/home/user","rootUri":"file:///home/user","trace":"verbose","capabilities":{"workspace":{"applyEdit":false,"workspaceEdit":{"documentChanges":false},"didChangeConfiguration":{"dynamicRegistration":false},"didChangeWatchedFiles":{"dynamicRegistration":false},"symbol":{"dynamicRegistration":false,"symbolKind":{"valueSet":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]}},"executeCommand":{"dynamicRegistration":false},"workspaceFolders":false,"configuration":false},"textDocument":{"synchronization":{"dynamicRegistration":false,"willSave":false,"willSaveWaitUntil":false,"didSave":false},"completion":{"dynamicRegistration":false,"completionItem":{"snippetSupport":true,"commitCharactersSupport":true,"documentationFormat":["markdown","plaintext"],"deprecatedSupport":true,"preselectSupport":true},"completionItemKind":{"valueSet":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]},"contextSupport":true},"hover":{"dynamicRegistration":false,"contentFormat":["markdown","plaintext"]},"signatureHelp":{"dynamicRegistration":false,"signatureInformation":{}},"references":{"dynamicRegistration":false},"documentHighlight":{"dynamicRegistration":false},"documentSymbol":{"dynamicRegistration":false,"symbolKind":{"valueSet":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},"hierarchicalDocumentSymbolSupport":true},"formatting":{"dynamicRegistration":false},"rangeFormatting":{"dynamicRegistration":false},"onTypeFormatting":{"dynamicRegistration":false},"definition":{"dynamicRegistration":false},"typeDefinition":{"dynamicRegistration":false},"implementation":{"dynamicRegistration":false},"codeAction":{"dynamicRegistration":false,"codeActionLiteralSupport":{"codeActionKind":{"valueSet":["quickfix","refactor"]}}},"codeLens":{"dynamicRegistration":false},"documentLink":{"dynamicRegistration":false},"colorProvider":{"dynamicRegistration":false},"rename":{"dynamicRegistration":false,"prepareSupport":true},"publishDiagnostics":{"relatedInformation":true},"foldingRange":{"dynamicRegistration":false,"rangeLimit":5,"lineFoldingOnly":false}}}}}'
initializeCommand=$(echo "$rawInitializeCommand" | jq -c "setpath([\"params\", \"rootPath\"]; \"${home}\")")
initializeCommand=$(echo "$initializeCommand" | jq -c "setpath([\"params\", \"rootUri\"]; \"file://${home}\")")
sendCommand cclsPipe "$initializeCommand"

echo $'\n\n*** Should see initialize response below ***\n'
