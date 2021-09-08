#!/bin/bash

echo "$1"
startTime="$1"
endTime="$2"
dayEpoch=86400000000000 #number of ns in a day

while [ $startTime -gt $endTime ]
do
	let startTime=startTime-dayEpoch
	sh ./dayRecovery.sh "$startTime"
done

