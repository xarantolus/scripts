#!/usr/bin/env bash 
set -euo pipefail 

GO_FILES=$(rg --files -g "*.go" || true)

if [ "$GO_FILES" != "" ]; then
    echo "Formatting Go files..."
    go fmt ./... || true
    gofmt -s -w $GO_FILES || true
    gci -w $GO_FILES || true
fi

ML_FILES=$(rg --files -g "*.ml" || true)

if [ "$ML_FILES" != "" ]; then
    echo "Formatting Ocaml files..."
    ocamlformat -i $ML_FILES || true
fi


if [ -f "./pubspec.yaml" ]; then 
    echo "Formatting Flutter project..."
    flutter format --line-length 120 --fix "." || true
fi
