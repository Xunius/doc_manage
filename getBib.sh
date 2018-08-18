#!/bin/bash

# Fetch an bibtex entry start from a grep search

#Author: guangzhi XU (xugzhi1987@gmail.com; guangzhi.xu@outlook.com)
#Update time: 2018-08-18 13:57:38.

# $1 grep search string
# $2 .bib file to search from

if [[ ! $# -eq 2 ]]; then
	echo -e "\n# <$(basename "$0")>: This script expects 2 args. Got $#. Exit"
	exit 1
fi

search_string=$1
bibfile=$2

function readLine() {
# Read a line from file
	tail -n+$1 "$2" | head -1
}

function checkBegin() {
# Check if a line is the start of bib entry, return 'y' if so
	echo "$1" | awk '/^@article{.*$/ {printf "y"}' 
}

function checkBegin2() {
# Check if a line is the start of bib entry, return 'y' if so
# use line number rather than line itself
	awk -v n=$1 'NR==n && /^@article{.*$/ {printf "y"; exit}' "$2"
}

function getEntry() {

	local line0=$1
	local bibfile="$2"

	# Get section from search line to end of entry
	part2=$(awk -v nn=$line0 'NR==nn,/^}$/' "$bibfile")

	# Skip search part1 if line0==1
	declare -a arr
	if [[ ! $line0 -eq 1 ]]; then
		# Go backward line by line till start of entry
		i=$line0
		idx=0
		lineii=$(readLine $i "$bibfile")
		while [[ ! $(checkBegin "$lineii") == 'y' ]]; do
			i=$((i-1))
			lineii=$(readLine $i "$bibfile")
			arr[$idx]="$lineii"
			idx=$((idx+1))
		done

		# Echo part1
		for (( i = (($idx-1)); i>=0; i-- )); do
			echo "${arr[$i]}"
		done
	fi
	echo "$part2"
}




# Check inputs
if [[ ! -e "$bibfile" ]]; then
	echo -e "\n# <$(basename "$0")>: bibfile not found. Exit."
	exit 1
fi

# Grep search to get line number(s)
line0=($(grep -i "$search_string" "$bibfile" -n | awk -F ':' '{print $1}'))

if [[ ${#line0[*]} -eq 0 ]]; then
	echo -e "\n# <$(basename "$0")>: String not found in bib file. Exit."
	exit 1
fi

# Create associative array to store results
declare -A dict
# Create an array to store keys
declare -a keys

# Loop through grep result lines
for i in ${!line0[*]}; do
	lineii=${line0[$i]}
	eii=$(getEntry $lineii "$bibfile")
	# Use first line as key, e.g. @article{citationkey,
	keyii=$(echo "$eii" | head -n 1)
	dict[$keyii]="$eii"
	keys[$i]="$keyii"
done

# Remove duplicate keys
newkeys=($(echo "${keys[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Echo out result
for (( i = 0; i < ${#newkeys[@]}; i++ )); do
	keyii=${newkeys[$i]}
	echo "${dict["$keyii"]}"
done



