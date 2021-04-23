#! /bin/bash

user_param=$1
home_dir=/home/stellara/scripts/

# Unfortunality, HF mode on RTL-SDR requires direct_sampl=2 and can tune under 24Mhz
# VHF mode does not require the direct_sampl parameter, but can tune only over 25 Mhz
# So one gqrx instance is not enougth to do the task, just one at time
hf_conf=${home_dir}hf.conf
vhf_conf=${home_dir}vhf.conf
gqrx_choosen_conf=${hf_conf}
gqrx_choosen_mode=hf

# This file controls the mode of gqrx usase
gqrx_control_file=${home_dir}/gqrx_mode.pid

startgqrx() {
    touch ${gqrx_control_file}

    if [ "${user_param}" == "vhf" ]; then
       gqrx_choosen_conf=${vhf_conf}
       gqrx_choosen_mode=vhf
       echo "Modo vhf ativado"
    fi

    echo ${gqrx_choosen_mode} > ${gqrx_control_file}
    /usr/bin/gqrx -c ${gqrx_choosen_conf} -s windows &
    echo "Waiting for gqrx..."
    sleep 15
}

# Starts or restarts gqrx
gqrxIsRunning=$(ps -ef | grep /usr/bin/gqrx | awk '{ print $8 }' | head -n 1)
if [ "${gqrxIsRunning}" == "" -o "${gqrxIsRunning}" == "grep" ]; then
  startgqrx
else
   killall -9 gqrx
   startgqrx
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
