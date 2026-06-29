#!/bin/bash

#SET THESE VARIABLES
SERVEREMAIL="<PLEASE SET>" #email of server
EMAIL="<PLEASE SET>" #receiving email
SERVER="<PLEASE SET>" #server name

#DO NOT TOUCH
FILE="full.tmp"
DATA="data.tmp"
OUTPUT="email.tmp"

#get full output
/usr/local/sbin/smartctl -a /dev/$1 > $FILE

#get only raw smart stats
/usr/local/sbin/smartctl -A /dev/$1 > $DATA

#get rid of headers on data
tail -n +4 $FILE > $FILE.new
tail -n +7 $DATA > $DATA.new

#remove temp files
rm $FILE
rm $DATA

#clean up names
mv $FILE.new $FILE
mv $DATA.new $DATA

#set custom headers
echo "From: $SERVEREMAIL" > $OUTPUT
echo "To: $EMAIL" >> $OUTPUT
echo "Subject: SMART Test Results for /dev/$1 on $SERVER" >> $OUTPUT

#set formatting headers DO NOT CHANGE
echo 'Content-Type: multipart/alternative; boundary="boundary-string"' >> $OUTPUT
echo 'Content-Type: text' >> $OUTPUT
echo 'MIME-Version: 1.0' >> $OUTPUT
echo '--boundary-string' >> $OUTPUT
echo 'Content-Type: text/plain; charset="utf-8"' >> $OUTPUT
echo 'Content-Transfer-Encoding: quoted-printable' >> $OUTPUT
echo 'Content-Disposition: inline' >> $OUTPUT
echo '' >> $OUTPUT

#name of device
grep "Device Model:" $FILE >> $OUTPUT

#serial number
grep "Serial Number:" $FILE >> $OUTPUT

#size
CAPACITY=$(grep "User Capacity:" $FILE | pcregrep -o '\[.*?\]' | sed 's/\[//;s/\]//')
echo "Drive Capacity:   $CAPACITY" >> $OUTPUT

#server time
grep "Local Time is:" $FILE >> $OUTPUT

#result of test
RESULT=$(grep "SMART overall-health self-assessment test result:" $FILE | sed -n -e 's/^.*result: //p')
printf "Result of test:   $RESULT\n\n" >> $OUTPUT

#raw smart data
cat $DATA >> $OUTPUT

#remove temp files
rm $FILE
rm $DATA

#send email
cat $OUTPUT | sendmail -t

#remove temp email file
rm $OUTPUT
