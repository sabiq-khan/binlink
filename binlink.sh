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
	if ! [[ -d $PWD/.git ]]; then
		echo "ERROR: No git repository in current directory $PWD." >&2
		exit 1	
	fi

	# Checks that the current branch is master
	local currBranch=$(git rev-parse --abbrev-ref HEAD)
	if ! [[ $currBranch = "master" ]]; then
		echo "ERROR: Current branch is $currBranch, not master." >&2 
		exit 1
	fi

	# For each script in current branch in current repo, links to ~/bin
	# If link already exists, an error is returned
	set -o errtrace
	trap "echo ERROR: Link creation failed." ERR
	local scripts=$(ls $PWD/*)
	for script in $scripts; do
		local link=$HOME/bin/$(basename $script | sed 's/\..*//g')
		echo "Creating link in $HOME/bin..."
		ln -s $script $link
		if [[ $? -eq 0 ]]; then
			echo "Link $link created."
		fi
	done
}

# Lists the links currently present in ~/bin
list(){
	# Creates the heading, accounts for variation in dir names
	local heading=$(header "Symlinks in $HOME/bin:")
	echo -e $heading

	# Lists symlinks
	ls -lh $HOME/bin | grep "^l"
	#echo
}

# Searches ~/bin for a specified link
search(){
	local matches=$(ls $HOME/bin | grep $1)
	if [[ -z $matches ]]; then
		echo "ERROR: No symlinks found in $HOME/bin like '$1'." >&2
	else
		local heading=$(header "Symlinks like '$1' in $HOME/bin:")
		echo -e $heading

		for match in $matches; do
			ls -lh $HOME/bin/$match
		done
	fi
}

# Delete a specified link from ~/bin 
delete(){
	# Checks if specified file exists in ~/bin and if it's a link
	if ! [[ -f $HOME/bin/$1 ]]; then
		echo "ERROR: $HOME/bin does not contain '$1'." >&2
		exit 1
	elif ! [[ "$(stat -c "%F" $HOME/bin/$1)" = "symbolic link" ]]; then
		echo "ERROR: $HOME/bin/$1 is not a symbolic link." >&2
		exit 1
	fi
	
	# Deletes link from ~/bin
	echo "Deleting link $HOME/bin/$1..."
	rm $HOME/bin/$1
	echo "Link $HOME/bin/$1 deleted."
}

# Explains how to use `binlink` and its options
help(){
	echo -e "\nUsage: binlink -[OPTIONS] [ARGUMENTS]\n"
	echo -e "Symlinks scripts from their respective repositories to ~/bin, making them executable by name like built-in bash commands and GNU utilities by adding them to the \$PATH.\n"
	echo "Options:"
	echo -e "\t-a\t\tLinks scripts from the master branch of the current repository to ~/bin."
	echo -e "\t-l\t\tLists the links currently present in ~/bin."
	echo -e "\t-s string\tSearches for links in ~/bin that match a specified search string."
	echo -e "\t-d string\tDeletes a specified link from ~/bin."
	echo -e "\t-h\t\tPrints this help message.\n"
}

# Creates a header for an STDOUT message, borders match its size
header(){
	local heading=$1

	local length=$(echo $heading | wc -m)
	local border="-"
	for ((i=1; i<=$((length - 2)); i++)); do
		border="$border""-"
	done

	echo "$border\n$heading\n$border"
}

#####################################################################
# ENTRYPOINT                                                        #
#####################################################################
# Checks if ~/bin exists, since all script actions depend on it
if ! [[ -d $HOME/bin ]]; then
	echo "ERROR: $HOME/bin does not exist." >&2
   	exit 1
fi

# Checks if the script was called with arguments
if [[ $# -eq 0 ]]; then
	help
	exit
fi

# Parses arguments
while getopts "als:d:h" option; do
	case $option in
		a)
			add
			exit
			;;
		l) 
			list
			exit
			;;
		s) 
			search $OPTARG
			exit
			;;
		d) 
			delete $OPTARG
			exit
			;;
		h) 
			help
			exit
			;;
	esac
done

