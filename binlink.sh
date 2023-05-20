#!/bin/bash
#
# Links scripts from the directory they're developed in to ~/bin

#####################################################################
# FUNCTIONS                                                         #
#####################################################################
# Adds a new link in ~/bin to another script from the main branch
# of a source repo
add() {
	# Checks that the current directory contains a git repository
	if ! [ -d $PWD/.git ]; then
		echo "ERROR: No git repository in current directory $PWD." >&2
		exit 1	
	fi

	# Checks that the current branch is master
	currBranch=$(git rev-parse --abbrev-ref HEAD)
	if ! [ $currBranch = "master" ]; then
		echo "ERROR: Current branch is $currBranch, not master." >&2 
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

#####################################################################
# ENTRYPOINT                                                        #
#####################################################################
# Checks if ~/bin exists, since all script actions depend on it
if ! [ -d $HOME/bin ]; then
	echo "ERROR: $HOME/bin does not exist." >&2
   	exit 1
fi

# Checks if the script was called with arguments
if [ $# -eq 0 ]; then
	echo "ERROR: No arguments specified." >&2
	exit 1
fi

# Parses arguments
while getopts ":a" option; do
	case $option in
		a)
			add
			exit
			;;
		\?) 
			echo "ERROR: Invalid option" >&2
			exit
			;;
	esac
done


