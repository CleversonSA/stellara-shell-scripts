#! /bin/bash

# Check if the monitor output was created before on PulseAudio server
MONITOR=$(pactl list | grep streamming)
if [ "${MONITOR}" != "" ]; then
  /usr/bin/pactl unload-module module-null-sink
  /usr/bin/pactl unload-module module-rtp-send
  echo "Monitor removed"
fi

killall -9 vlc

exit 0
