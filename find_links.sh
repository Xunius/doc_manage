#!/bin/bash

# Get all symlinks to a given file, inside ~/Papers folder

# $1: path to document file to search for symlinks point to it.

#Author: guangzhi XU (xugzhi1987@gmail.com; guangzhi.xu@outlook.com)
#Update time: 2018-08-16 22:48:14.


# Path to folder used as library
LIB_FOLDER=~/Papers

if [[ ! $# -eq 1 ]]; then
	echo -e "\n# <$(basename "$0")>: This script expects 1 args. Got $#. Exit"
	exit 1
fi

find -L $LIB_FOLDER -xtype l -samefile "$1" -print0 | \
	xargs --no-run-if-empty -0 -n1 dirname |\
	xargs --no-run-if-empty -n1 basename
