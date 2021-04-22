#! /bin/bash
FILE=~/uptime-logger.log

if [ -f "$FILE" ]; then
  touch $FILE
fi

uptime >> $FILE

exit 0
