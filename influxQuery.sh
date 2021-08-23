#!/bin/bash
dayEpoch=86400000000000
now=$(date +%s%N)
tdiff=$((now - dayEpoch))

echo "$now"
echo "$tdiff"

query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now""

#influx -database 'digitalEnergy' -execute 'SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now"' -format csv > test.csv
influx -database 'digitalEnergy' -execute "$query" -format csv > test.csv
# influx -database 'powerConsumption' -execute 'SELECT * FROM datapoint WHERE time > now() - 100d' -format csv > powerConsumption.csv
