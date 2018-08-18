#!/bin/bash

# Call add_links.sh on each doc in a folder, using folder name as tag

# $1: path to folder containing document files to add to library.

#Author: guangzhi XU (xugzhi1987@gmail.com; guangzhi.xu@outlook.com)
#Update time: 2018-08-16 22:58:25.


ADD_LINK_SCRIPT=~/Papers/add_links.sh

if [[ ! $# -eq 1 ]]; then
	echo -e "\n# <$(basename "$0")>: This script expects 1 args. Got $#. Exit"
	exit 1
fi

if [[ ! -d "$1" ]]; then
	echo -e "\n# <$(basename "$0")>: Input is not a directory. Exit"
	exit 1
fi

for fii in "$1"/*; do
	dirname=$(realpath "$1" | xargs -0 -n1 basename)
	echo -e "\n# <$(basename "$0")>: Processing file $fii, add tag: $dirname"
	# Call script
	"$ADD_LINK_SCRIPT" "$fii" "$dirname"
done

