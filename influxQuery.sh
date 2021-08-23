#!/bin/bash

#
# Script is run every day at 00:00
# 0 0 * * * /home/pi/DigitalEnergy/influxQuery.sh
#

fileName=$(date +"/home/pi/influxExport/%Y%m%d_%a.csv") #construct filename e.g. 20210823_mon.csv

dayEpoch=86400000000000 #number of ns in a day
now=$(date +%s%N) #current EPOCH (ns)
tdiff=$((now - dayEpoch)) #time diff in EPOCH ns 

#build query
query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now""

#query
influx -database 'digitalEnergy' -execute "$query" -format csv > "$fileName"


