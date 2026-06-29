#!/bin/bash

#SET THESE VARIABLES
EMAIL="<PLEASE SET>" #receiving email
SERVER="<SERVER NAME>" #server name

#DO NOT TOUCH
FILE="full.tmp"
DATA="data.tmp"
OUTPUT="email.tmp"

#get full smartctl report
/usr/sbin/smartctl -a /dev/$1 > $FILE

#get only raw smart stats
/usr/sbin/smartctl -A /dev/$1 > $DATA

#clean up data
tail -n +4 $FILE > $FILE.new
tail -n +7 $DATA > $DATA.new

#remove temp files
rm $FILE
rm $DATA

#clean up names
mv $FILE.new $FILE
mv $DATA.new $DATA

#get device name
grep "Device Model:" $FILE > $OUTPUT

#get serial number
grep "Serial Number:" $FILE >> $OUTPUT

#get capacity
CAPACITY=$(grep "User Capacity:" $FILE | grep -oP '\[.*?\]' | sed 's/\[//;s/\]//')
echo "Drive Capacity:   $CAPACITY" >> $OUTPUT

#get server time
grep "Local Time is:" $FILE >> $OUTPUT

#get result
RESULT=$(grep "SMART overall-health self-assessment test result:" $FILE | sed -n -e 's/^.*result: //p')
printf "Result of test:   $RESULT\n\n" >> $OUTPUT

#include raw smart stats
cat $DATA >> $OUTPUT

#clean up temp files
rm $FILE
rm $DATA

#send email
cat $OUTPUT | mail -s "SMART Test Results for /dev/$1 on $SERVER" $EMAIL

#remove temp email file
rm $OUTPUT
