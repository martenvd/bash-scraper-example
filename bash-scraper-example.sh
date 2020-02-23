#!/usr/bin/env bash

declare -a arr
URLOPTION=""

# Add arguments to the array.
for arg in $@
do
	arr+=($arg)
done

# Throw this when the user doesn't give any options.
if [ $# -eq 0 ]
then
	echo "You need options!"
	echo "Run $0 -h for help"
	exit 0
fi

# For loop that checks whether the user has declare an URL with the -u option.
for i in ${!arr[@]}
do
	if [[ ${arr[$i]} == "-u" && ${arr[$i+1]} == "" ]]
	then
		echo "You must spcify the URL on which you want to find pages!"
		exit 0
	
	elif [[ ${arr[$i]} == "-u" && ${arr[$i+1]} != "" ]]
	then
		URLOPTION=${arr[$i+1]}
		break
	fi
done

START="false"

# The first while loop is put in place so that the getopts ignores any other arguments besides OPTIND.
# The second while loop is for the getopts function. 
while :;
do
	while getopts "uh" OPTION; 
	do
		case $OPTION in

			u)	START="true"
				starturl=$URLOPTION
				;;

			h) 	echo "Usage:"
				echo "$0 -h for help"
				echo '$0 -u <url that ends with "page=" or something like that> to start scanning for pages on a website'
				exit 0
				;;
			
			*)	echo "Wrong argument, enter $0 -h for help!"
				;;
		esac
	done
	((OPTIND++))
	[ $OPTIND -gt $# ] && break
done

# Simple scraper that checks for existence of pages on a website.
# Only works if the URL ends with a page identifier like "page=".
if [ $START == "true" ]
then
	for i in {1..1000}
	do
		url="$starturl$i"
		status=$(curl -o /dev/null -s -w "%{http_code}\n" $url)
		sleep 0.5s
		if [ $status -eq 200 ]
		then
			echo $url | tee urls.txt
		fi
	done
fi
