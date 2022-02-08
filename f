#!/usr/bin/env bash 
set -euo pipefail 

GIT_DIFF=""
if [[ "${1-}" == "--fail-on-change" ]]; then
    GIT_DIFF="$(git diff .)"    
fi

GO_FILES=$(rg --files -g '!vendor/*' -g "*.go" || true)

if [ "$GO_FILES" != "" ]; then
    echo "Formatting Go files..."
    go fmt ./... || true
    gofmt -s -w $GO_FILES || true
    gci -w $GO_FILES || true
fi

ML_FILES=$(rg --files -g "*.ml" || true)

if [ "$ML_FILES" != "" ]; then
    echo "Formatting Ocaml files..."
    ocamlformat --enable-outside-detected-project -i $ML_FILES || true
fi


if [ -f "./pubspec.yaml" ]; then 
    echo "Formatting Flutter project..."
    flutter format --line-length 120 --fix "." || true
fi

# Now if we have a diff saved, we check if formatting changed anything
if [ "$GIT_DIFF" != "" ]; then
    GIT_DIFF_AFTER="$(git diff .)"    

    if [ "$GIT_DIFF" != "$GIT_DIFF_AFTER" ]; then
        echo "Files changed when formatting, not OK"
        exit 1
    fi
fi
