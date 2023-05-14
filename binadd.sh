#!/bin/bash

# TODO: Consider splitting into functions
currBranch=$(git rev-parse --abbrev-ref HEAD)
if ! [ $currBranch = "bin-add" ]; then
	echo "ERROR: Current branch is $currBranch, not bin-add." >&2 
	exit 1
fi

echo "Current branch is bin-add."
set -o errtrace
trap "echo ERROR: Link creation failed." ERR
scripts=$(ls $PWD/*)
for script in $scripts; do
	link=$HOME/bin/$(basename $script | sed 's/\..*//g')
	echo "Creating link in $HOME/bin..."
	ln -s $script $link
	if [ $? -eq 0 ]; then
		echo "Link $link created."
	fi
done

