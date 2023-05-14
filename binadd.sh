#!/bin/bash

# This code is successfully able to check & print name of the
# current branch
# Tested by creating a new branch and running script
# TODO: Print to stderr
# TODO: Change the "main" to "master" when the script works
currBranch=$(git rev-parse --abbrev-ref HEAD)
if ! [ $currBranch = "main" ]; then
	echo "ERROR: Current branch is $currBranch, not main." >&2 
	exit 1
fi

echo "Current branch is main."
echo "$PWD/*"
