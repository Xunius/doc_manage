#!/bin/bash

# Given an input document file and a tag name, search (case insensitively)
# folders with name of the tag within the library folder. If none exists, ask to
# create a new folder named "tag" under the library folder. Then (ask to) copy
# the file to the collection folder, and (ask to) create a symlink(s) from the
# new location iside collection folder to all subfolders with name "tag".

# $1: path to document to add to library.
# $2: tag to associate the document with, which is also the subfolder
#     name under library folder.

#Author: guangzhi XU (xugzhi1987@gmail.com; guangzhi.xu@outlook.com)
#Update time: 2018-08-16 22:50:11.

# Path to folder used as library
LIB_FOLDER=~/Papers
# Path to folder storing document files for library
DOC_FOLDER="$LIB_FOLDER/collection"

if [[ ! $# -eq 2 ]]; then
	echo -e "\n# <$(basename "$0")>: This script expects 2 args. Got $#. Exit"
	exit 1
fi

# Check $1 exists
if [[ ! -f "$1" ]]; then
	if [[ ! -f "$LIB_FOLDER/$1" ]]; then
		echo -e "\n# <$(basename "$0")>: Input not found. Exit."
		exit 1
	fi
fi

# check if folder exists under library folder
folders=($(find $LIB_FOLDER -type d -iname "$2"))

# If folder not exists, create folder
if [[ ${#folders[*]} -eq 0 ]]; then
	newfolder="$LIB_FOLDER/$2"
	if [[ ! -d $newfolder ]]; then
		read -p "# <add_links.sh>: Folder not found. Create new at "$newfolder"? (y|n)? " is_create
		if [[ "$is_create" == 'y' ]]; then
			mkdir -vp "$newfolder"
			folders=("$newfolder")
		else
			echo -e "\n# <$(basename "$0")>: Exit."
			exit 1
		fi
	else
		echo "# Folder found: $newfolder"
	fi
fi

# Copy to collection folder and create links
for i in ${!folders[*]}; do
	src=$(realpath "$1")
	copy_target="$DOC_FOLDER/$(basename "$1")"
	link_target="${folders[$i]}/$(basename "$1")"
	echo -e "\n# <$(basename "$0")>: Copy to collection folder"
	cp -iv "$src" "$copy_target"

	echo -e "\n# <$(basename "$0")>: Create symlink"
	ln -sirv "$copy_target" "$link_target"
done

