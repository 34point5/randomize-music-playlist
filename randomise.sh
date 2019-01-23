#!/bin/bash

clear

# setting colours to beautify messages
green='\033[0;32m'
nocol='\033[0m'

# store all music files in an array, then sort it randomly
contents=(/home/tfpf/Music/*)
IFS=$'\n' random=($(sort -R <<< "${contents[*]}"))
unset IFS

# number of tracks to be played
# which is the number of elements in the array
size=${#random[@]}

# number of digits in the variable 'size'
# used to format information messages
length=${#size}

# display the order in which the tracks will be played
count=1
echo -e "${green}The tracks will be played in the following order.${nocol}"
for item in ${random[@]}; do
	printf "%*d\t" $length $count
	echo $(basename ${item%.*})
	count=$(($count+1))
done
echo

# play tracks in that order
count=1
for item in ${random[@]}; do

	# send a desktop notification to tell
	# which track is currently playing
	# no idea why this works
	# I copied it from the code for a program called 'undistract-me'
	notify=$(command -v notify-send)
	if [ -x "$notify" ]; then
		$notify \
		-i dialog-information \
		-u low \
		"$count" \
		"$(basename ${item%.*})"
	else
		echo -ne "\a"
	fi

	# display the same information on the Terminal
	echo -en "${green}"
	printf "now playing %*d of %*d" $length $count $length $size
	echo -e "${nocol}\t$(basename ${item%.*})"

	# display the PID of this script for kicks
	echo -e "${green}process ID: $$${nocol}"

	# open VLC without interface and play one track
	cvlc --play-and-exit $item

	# track has ended
	count=$(($count+1))
	clear
done
