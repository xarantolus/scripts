#!/usr/bin/env bash 
set -e
# This script runs tests found in the current git repository


# Save the initial directory and return there on exit
INITIAL_DIR="$(pwd)"
trap "cd $INITIAL_DIR" EXIT

# Get the current git directory, but don't output on errors
GIT_REPO_DIR="$(git rev-parse --show-toplevel 2> /dev/null || true)"

# Go to the top level of the git repo if defined
if [ -n "$GIT_REPO_DIR" ]; then
    cd "$GIT_REPO_DIR"
fi


#
# Now run tests if we find any
#

# Go tests
if rg -g '*_test.go' --files > /dev/null
then
  go test ./...
fi

# Flutter tests
if [ -f "./pubspec.yaml" ]; then 
    flutter test
fi
