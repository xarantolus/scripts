#!/usr/bin/env bash 

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
elif [ -f "./build.sh" ]; then 
	./build.sh "$@"
else 
	echo "No deploy script found"
fi
