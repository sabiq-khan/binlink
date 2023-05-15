#!/bin/bash
#
# Links scripts from the directory they're developed in to ~/bin

# TODO: 
#	Consider splitting into functions
# 	`binadd.sh` should be renamed `binlink.sh`
# 	The current code should be encapsulated in an "add" function

add() {
	# Checks that the current branch is master
	currBranch=$(git rev-parse --abbrev-ref HEAD)
	if ! [ $currBranch = "bin-link" ]; then
		echo "ERROR: Current branch is $currBranch, not bin-link." >&2 
		exit 1
	fi

	# For each script in current branch in current repo, links to ~/bin
	# If link already exists, an error is returned
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
}

# Entrypoint
main() {
	add
}

main

