#! /bin/bash

gqrxIsRunning=$(ps -ef | grep /usr/bin/gqrx | awk '{ print $8 }' | head -n 1)
echo "${gqrxIsRunning}"
if [ "${gqrxIsRunning}" == "" -o "${gqrxIsRunning}" == "grep" ]; then
  /usr/bin/gqrx -c /home/stellara/scripts/hf.conf -s windows &
  echo "Waiting for gqrx..."
fi

# Maybe when GQRX is not closed properly, a crash window appears
# breaking the start up code
retries=3
while [ $retries -gt 0 ]
do	
  sleep 5
  gqrxCrashWindow=$(/usr/bin/xdotool search --name "Crash Detected!" | head -n 1)
  echo "Crash Window = ${gqrxCrashWindow}"
  if [ "${gqrxCrashWindow}" != "" ]; then
    echo "Crash detected, responding..."
    /usr/bin/xdotool windowactivate --sync ${gqrxCrashWindow} key N
    retries=0
  fi

  retries=$(( ${retries} - 1 ))
done
sleep 5


gqrxWindowFound="N"
while [ "${gqrxWindowFound}" == "N" ]
do
  gqrxWindowName="Gqrx 2.9"
  gqrxWindow=$(/usr/bin/xdotool search --name "${gqrxWindowName}" | head -n 1)

  if [ "${gqrxWindow}" != "" ]; then
     gqrxWindowFound="S"
  fi
  sleep 5
done

echo "GQRX Window ${gqrxWindow}"
/usr/bin/xdotool windowactivate --sync $gqrxWindow key ctrl+d

exit
