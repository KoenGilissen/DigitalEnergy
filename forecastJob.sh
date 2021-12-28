#!/bin/bash

#$crontab -e
# Script is run every day at 05:00
# 00 5 * * * /home/.../xxx.sh
#
echo "start of forecast job script" > logForeCast.txt
logger -s  "start of forecast job script"
fileNameGFS=$(date +"/home/wizard/%Y%m%d_gfs.json")
fileNameSolcast=$(date +"/home/wizard/%Y%m%d_solcast.json")
fileNameOpenweather=$(date +"/home/wizard/%Y%m%d_openweather.json")


echo "Running python script"
logger -s "Running python script"
/usr/local/bin/python3.9 /home/wizard/digitalEnergy/JetsonEnergy.py

echo "rclone upload to Onedrive"
logger -s "rclone upload to Onedrive"
logger -s "$fileNameGFS"
logger -s "$fileNameSolcast"
logger -s "$fileNameOpenweather"

rclone copy "$fileNameGFS" pxl:PXL/DigitalEnergyData
rclone copy "$fileNameSolcast" pxl:PXL/DigitalEnergyData
rclone copy "$fileNameOpenweather" pxl:PXL/DigitalEnergyData

