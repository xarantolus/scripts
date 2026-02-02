#!/usr/bin/env bash
set -euo pipefail

GIT_DIFF=""
if [[ "${1-}" == "--fail-on-change" ]]; then
    GIT_DIFF="$(git diff .)" || exit 0
fi

# if there's a defined "fmt" makefile target, use that
if grep "^fmt:" Makefile > /dev/null 2>&1; then
    make fmt
    exit 0
fi


GO_FILES=$(rg --files -g '!vendor/*' -g "*.go" || true)

if [ "$GO_FILES" != "" ]; then
    echo "Formatting Go files..."
    go fmt ./... || true
    # gofmt -s -w $GO_FILES || true
    # gci -w $GO_FILES || true
fi

ML_FILES=$(rg --files -g "*.ml" || true)

if [ "$ML_FILES" != "" ]; then
    echo "Formatting Ocaml files..."
    ocamlformat --enable-outside-detected-project -i $ML_FILES || true
fi

RUST_FILES=$(rg --files -g "*.rs" || true)
if [ "$RUST_FILES" != "" ]; then
    echo "Formatting Rust files..."
    cargo fix --allow-staged && cargo fmt
fi

if [ -f "./pubspec.yaml" ]; then
    echo "Formatting Flutter project..."
    flutter format --line-length 120 --fix "." || true
fi

if [ -f "pyproject.toml" ]; then
    uvx ruff check . --fix || true
    uvx ruff format . || true
fi

# If we find CMakelists or similar, use clang-format on all c, c++ etc. files recursively
if [ -f "./CMakeLists.txt" ] || [ -f "../CMakeLists.txt" ]; then
    echo "Formatting CMake project..."
    find . -print0 -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.hpp" -o -name "*.cc" -o -name "*.hh" -o -name "*.cxx" -o -name "*.hxx" | xargs -0 clang-format -i
fi


# Now if we have a diff saved, we check if formatting changed anything
if [ "$GIT_DIFF" != "" ]; then
    GIT_DIFF_AFTER="$(git diff .)"

    if [ "$GIT_DIFF" != "$GIT_DIFF_AFTER" ]; then
        echo "Files changed when formatting, not OK"
        exit 1
    fi
fi
