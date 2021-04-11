#!/bin/bash

EMAIL="<DESTINATION EMAIL>"
SERVER="<SERVER NAME>"

FILE="full.tmp"
DATA="data.tmp"
OUTPUT="email.tmp"

smartctl -a /dev/$1 > $FILE
smartctl -A /dev/$1 > $DATA

tail -n +4 $FILE > $FILE.new
tail -n +7 $DATA > $DATA.new

rm $FILE
rm $DATA

mv $FILE.new $FILE
mv $DATA.new $DATA

grep "Device Model:" $FILE > $OUTPUT
grep "Serial Number:" $FILE >> $OUTPUT
CAPACITY=$(grep "User Capacity:" $FILE | grep -oP '\[.*?\]' | sed 's/\[//;s/\]//')
echo "Drive Capacity:   $CAPACITY" >> $OUTPUT
grep "Local Time is:" $FILE >> $OUTPUT
RESULT=$(grep "SMART overall-health self-assessment test result:" $FILE | sed -n -e 's/^.*result: //p')
printf "Result of test:   $RESULT\n\n" >> $OUTPUT
cat $DATA >> $OUTPUT

rm $FILE
rm $DATA

cat $OUTPUT | mail -s "SMART Test Results for /dev/$1 on $SERVER" $EMAIL
rm $OUTPUT
