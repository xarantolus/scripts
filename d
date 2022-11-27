#!/usr/bin/env bash
set -euo pipefail

# Script to start deploy scripts
# I keep deploy scripts somewhere in my projects,
# they automatically push them to the server they run on
# This tool allows me to deploy basically all my projects by just typing "d"
# into the command line in the right directory

if [ -f "./d" ]; then
	./d "$@"
elif [ -f "./deploy.sh" ]; then
	./deploy.sh "$@"
elif [ -f "./deploy/deploy.sh" ]; then
	./deploy/deploy.sh "$@"
elif [ -f "./Makefile" ]; then
	make "$@"
elif [ -f "./build.sh" ]; then
	./build.sh "$@"
elif [ -f "./pubspec.yaml" ]; then
	flutter run --release "$@"
elif [ -f "./dune-project" ]; then
	dune utop --profile release
elif [ -f "./dune" ]; then
	dune utop --profile release
elif [ -f ./*.ml ]; then
	utop -I +threads -init ./*.ml
elif [ -f "generate-all.sh" ]; then
	./generate-all.sh
elif [ -f "generate.sh" ]; then
	./generate.sh
elif [ -f "package.json" ]; then
	# if a build npm script exists, we execute it
	if grep "\"build\":" package.json > /dev/null 2>&1; then
		npm run build
		exit 0
	elif grep "\"start\":" package.json > /dev/null 2>&1; then
		npm run start
		exit 0
	fi
	echo "No deploy script found"
	exit 2
elif [ -d "./src" ]; then
	cd src && d
elif [ -d "generate" ]; then
	cd generate && d
else
	echo "No deploy script found"
	exit 1
fi
