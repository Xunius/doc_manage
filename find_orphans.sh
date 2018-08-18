#!/bin/bash

# Loop through files in a folder and find those without symlinks

#Author: guangzhi XU (xugzhi1987@gmail.com; guangzhi.xu@outlook.com)
#Update time: 2018-08-16 22:44:04.


# Path to folder used as library
LIB_FOLDER=~/Papers
# Path to folder storing document files for library
DOC_FOLDER="$LIB_FOLDER/collection"



function findLinks() {
# Get all sym links to a given file, inside $LIB_FOLDER folder
find -L $LIB_FOLDER -xtype l -samefile "$1" -print0 | \
	xargs --no-run-if-empty -0 -n1 dirname |\
	xargs --no-run-if-empty -n1 basename
}


# Loop through all docs and find those without links
echo -e "\n# <$(basename "$0")>: ----- Scan docs in collection folder -----"
echo -e "\n# <$(basename "$0")>: Docs without any links in $DOC_FOLDER:"
echo
for fileii in "$DOC_FOLDER"/*; do
	if [[ -f "$fileii" ]]; then
		aa=($(findLinks "$fileii"))
		if [[ "${#aa[*]}" -eq 0 ]]; then
			echo -e "\t$fileii"
		fi
	fi
done
