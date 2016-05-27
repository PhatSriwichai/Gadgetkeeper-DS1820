#!/bin/bash
###########################################################################
#This script update the API with the new data (temperature/humidity value)
#should be passed as floating value in command line argument
###########################################################################
 
if [ "$1" == "" ]; then
    echo "Usage $0 \"update-T\" || \"update-H\" || \"test-msg\""
    exit 1
fi
 
#Update following fields as required  
API_KEY="409e2a611c4f440d9c4b7627375c5226"
THING_ID="cd007761233411e69b064b58a7906d4e"
EVENT_ID="c132acd823c211e69b064b58a7906d4e"
 
URL="http://api.gadgetkeeper.com"
#DATE=`/bin/date +"%Y-%m-%dT%H:%M:%S"`
DATE=`/bin/date -u +"%Y-%m-%dT%H:%M:%S"`
#DATE="2013-06-02T21:05:04.150Z"
#echo $DATE
 
if [ "$1" == "test-msg" ]; then
    VALUE="100.00"
    echo "Test value: $VALUE"
elif [ "$1" == "update-T" ]; then
    #VALUE="11.11"
    VALUE=`/home/pi/gadgetkeeper/read_temperature.sh`
    echo "Temperature value: $VALUE"
elif [ "$1" == "update-H" ]; then
    #VALUE="22.22"
    VALUE=`/home/pi/gadgetkeeper/read_humidity.sh`
    echo "Humidity value: $VALUE"
else
    echo "Invalid argument"
    exit
fi
#echo "$VALUE"
TMP_FILE="/tmp/tmp.txt"
/usr/bin/curl -i -X POST -H "X-ApiKey: $API_KEY" -H "Content-Type: text/json; charset=UTF-8" -d '[{"value":'$VALUE',"at":"'$DATE'"}]' "$URL/v1/things/$THING_ID/events/$EVENT_ID/datapoints.json"  > "$TMP_FILE" 2> /dev/null
if [ -f "$TMP_FILE" ]; then
    RESPONSE=`cat "$TMP_FILE" | head -1`
    IS_OK=`/bin/echo "$RESPONSE" | /bin/grep "HTTP/1.1 204"`
    if [ "$IS_OK" != "" ]; then
        /bin/echo "Event update: OK"
    else
        /bin/echo "Event update: FAIL"
        /bin/echo "$RESPONSE"
    fi
else
    /bin/echo "Error.please try again!"
fi
