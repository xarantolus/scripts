#!/usr/bin/env bash
set -euo pipefail
# This script runs tests found in the current git repository

run_tests() {
    TEST_DIR="$1"
    cd "$TEST_DIR"

    if grep "precommit:" Makefile > /dev/null 2>&1; then
        make precommit
        return 0
    fi

    # If a Makefile has been provided, use it
    if grep "test:" Makefile > /dev/null 2>&1; then
        make test
        return 0
    fi

    if grep "tests:" Makefile > /dev/null 2>&1; then
        make tests
        return 0
    fi

    # Go tests
    if [ -f "./go.mod" ]; then
        go test -cover ./...
        return 0
    fi

    # Flutter tests
    if [ -f "./pubspec.yaml" ]; then
        flutter test "$@"
        return 0
    fi

    # Rust tests
    if [ -f "./Cargo.toml" ]; then
        cargo test "$@"
        return 0
    fi

    return 127
}

# Basically we want to run tests in the current directory, but if it doesn't work there we might as well look in the git repo root path
INITIAL_DIR="$(pwd)"
GIT_REPO_DIR="$(git rev-parse --show-toplevel 2> /dev/null || true)" || exit 0
if [ "$INITIAL_DIR" = "$GIT_REPO_DIR" ]; then
    GIT_REPO_DIR=""
fi

set +e
if [ -n "$GIT_REPO_DIR" ]; then
    run_tests "$INITIAL_DIR"
    if [ $? -eq 127 ]; then
        run_tests "$GIT_REPO_DIR"
        if [ $? -eq 127 ]; then
            # No tests are also OK
            exit 0
        fi
    fi
else
    run_tests "$INITIAL_DIR"
    if [ $? -eq 127 ]; then
        exit 0
    fi
fi
