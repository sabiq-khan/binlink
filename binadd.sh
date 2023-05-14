#!/bin/bash

# This code is successfully able to check & print name of the
# current branch
# Tested by creating a new branch and running script
# TODO: Print to stderr
currBranch=$(git rev-parse --abbrev-ref HEAD)
if ! [ $currBranch = "master" ]; then
	echo "Current branch is not main, it's $currBranch."
	exit 1
else 
	echo "Current branch is main."
	exit 0
fi

