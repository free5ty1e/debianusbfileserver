#!/bin/bash

echo "Lists largest N number of files recursively in the current or given folder.  Syntax with optional parameters / arguments is as follows:"
echo "largestfilesrecursively.sh <numberOfFiles> <rootFolderToSearch>/"
echo "for example, the following command would list the largest 15 files in the /temp/folder/ location:"
echo "largestfilesrecursively.sh 15 /temp/folder/"
echo "rootFolderToSearch defaults to the current folder . if omitted"
echo "numberOfFiles defaults to 10 if omitted"
echo
echo "To review, you passed numberOfFiles of $1 and rootFolderToSearch of $2"

#Parameter 1: numberOfFiles
if [[ $1 ]] ; then
	NUMBER_OF_FILES=$1
	echo "numberOfFiles param detected, NUMBER_OF_FILES is ${NUMBER_OF_FILES}"
else
	NUMBER_OF_FILES=10
	echo "no numberOfFiles param detected, NUMBER_OF_FILES is ${NUMBER_OF_FILES}"
fi 

#Parameter 2: rootFolderToSearch
if [[ $2 ]] ; then
	ROOT_FOLDER_TO_SEARCH="$2"
	echo "rootFolderToSearch param detected, ROOT_FOLDER_TO_SEARCH is ${ROOT_FOLDER_TO_SEARCH}"
else
	ROOT_FOLDER_TO_SEARCH="."
	echo "no rootFolderToSearch param detected, ROOT_FOLDER_TO_SEARCH is ${ROOT_FOLDER_TO_SEARCH}"
fi 

find "$ROOT_FOLDER_TO_SEARCH" -xdev \! -path /var/log/lastlog -printf '%s\t%p\n' |
  sort -rn | head --lines $NUMBER_OF_FILES | cut -f2- |
  xargs -n1 ls -lh | awk '{print $5, $NF}'
