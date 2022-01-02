#!/usr/bin/env bash 

GO_FILES=$(rg --files -g "*.go")

if [ "$GO_FILES" != "" ]; then
    go fmt ./...

    gci -w $GO_FILES
fi
