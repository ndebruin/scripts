#!/bin/bash


while true
do
	IFS="\n"

	temp2=$(journalctl --since=-10s --no-pager -q | tail -n -1)
	if [ "$temp" == "$temp2" ]; then
		continue
	fi

	temp=$(journalctl --since=-10s --no-pager -q | tail -n -1)
#	printf $temp
	if [ ! "$temp" == "" ]; then
		json='{"content":"'"$temp"'"}'
		curl -H "Content-Type: application/json" -X POST -d "$json" "$url"
	fi

	sleep 0.5
	unset IFS
done
