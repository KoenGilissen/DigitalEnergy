#!/bin/bash

echo "$1"
startTime="$1"

#date --date='@2147483647'
time=$(( $1 / 1000000000))
currentDate=`date +"%Y%m%d_%a" -d@"$time"`

echo "date argument: $currentDate"

fileName="${currentDate}.csv" #construct filename e.g. 20210823_mon.csv
echo "filename: $fileName"

dayEpoch=86400000000000 #number of ns in a day
#dayEpoch=75202000000000
tdiff=$((startTime - dayEpoch)) #time diff in EPOCH ns 
echo "timediff: $tdiff"

#build query
query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$startTime""
echo "$query"
#query="SELECT * FROM datapoint WHERE TIME >= 1627596000918531249 AND TIME <= 1627671202154608607"
#query="SELECT * FROM datapoint WHERE TIME >= 1630188000000000000  AND TIME <= 1630274399000000000"

#query
influx -database 'digitalEnergy' -execute "$query" -format csv > "$fileName"
#influx -database 'digitalEnergy' -execute "$query" -format csv > sunday.csv

#backup to google drive
rclone -vv  copy "$fileName" pxl:PXL/DigitalEnergyData


