#!/usr/bin/env bash 

GO_FILES=$(rg --files -g "*.go")

if [ "$GO_FILES" != "" ]; then
    go fmt ./... || true
    gofmt -s -w $GO_FILES || true
    gci -w $GO_FILES || true
fi
