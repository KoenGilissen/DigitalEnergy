#!/bin/bash
dayEpoch=86400000000000 #number of ns in a day
now=$(date +%s%N) #current EPOCH (ns)
tdiff=$((now - dayEpoch)) #time diff in EPOCH ns 

#build query
query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now""


#query
influx -database 'digitalEnergy' -execute "$query" -format csv > test.csv

