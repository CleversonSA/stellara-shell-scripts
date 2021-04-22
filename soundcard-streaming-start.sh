#! /bin/bash

# Check if the monitor output was created before on PulseAudio server
MONITOR=$(pactl list | grep streamming)
if [ "${MONITOR}" == "" ]; then
  /usr/bin/pactl load-module module-null-sink sink_name=streamming
  /usr/bin/pactl load-module module-rtp-send source=streamming.monitor destination_ip=0.0.0.0
  echo "Monitor created"
fi

# Audio source from PulseAudio server, that creates a null sound exit
# So all the sounds events of the station will be streammed
#SOURCE=pulse://auto_null.monitor
SOURCE=pulse://streamming.monitor

# Host of the streamming. Of course, 0.0.0.0 is always wrong, but the
# goal is not stream over the internet! Just over local or builtin AP Wifi
HOST=0.0.0.0
PORT=8888

# URL to be created to access the stream
URL=/stellara.ogg

# If you want to see the output for debbug, uncomment this section
#DEBUG=-vvv

SOUTCONFIG='#standard{access=http,mux=ogg,dst='${HOST}':'${PORT}${URL}'}'
echo ${SOUTCONFIG}

/usr/bin/cvlc ${DEBUG} ${SOURCE} --sout ${SOUTCONFIG}
