#!/usr/bin/env bash
set -euo pipefail
# This script runs lints for files in the current repo

# Save the initial directory and return there on exit
INITIAL_DIR="$(pwd)"
trap "cd \"$INITIAL_DIR\"" EXIT

# Get the current git directory, but don't output on errors
GIT_REPO_DIR="$(git rev-parse --show-toplevel 2> /dev/null || true)"

# Go to the top level of the git repo if defined
if [ -n "$GIT_REPO_DIR" ]; then
    cd "$GIT_REPO_DIR"
fi




if [ -f "./go.mod" ]; then
    echo "Running Go linter"
    golangci-lint run --enable-all --disable gci,nonamedreturns,gofumpt,cyclop,maligned,interfacer,varnamelen,tagliatelle,errorlint,paralleltest,wrapcheck,exhaustivestruct,nestif,nlreturn,noctx,testpackage,godot,goerr113,gomnd,stylecheck,goimports,gochecknoglobals,unparam,lll,nakedret,goconst,golint,wsl,gochecknoinits,scopelint,funlen,prealloc,gocognit,ineffassign,gocyclo

fi
