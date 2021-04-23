#! /bin/bash

# Since the linux cron has no seconds configuration
# It's not acceptable that user has to wait 1 minute to swap gqrx mode

home_dir=/home/stellara/scripts
vhf_signal_file=${home_dir}/gqrx.vhf.swap
hf_signal_file=${home_dir}/gqrx.hf.swap
mode=

while [ true ];
do
  if [ -f "${hf_signal_file}" ]; then
      mode=hf
      rm -f ${hf_signal_file}
  fi

  if [ -f "${vhf_signal_file}" ]; then
      mode=vhf
      rm -f ${vhf_signal_file}
  fi

  if [ "${mode}" == "vhf" ]; then
      ${home_dir}/gqrx-autostart.sh vhf
  fi

  if [ "${mode}" == "hf" ]; then
      ${home_dir}/gqrx-autostart.sh
  fi

  # Clean the mode
  mode=

  sleep 5

  # Check if gqrx is active
  gqrxIsRunning=$(ps -ef | grep /usr/bin/gqrx | awk '{ print $8 }' | head -n 1)
  if [ "${gqrxIsRunning}" == "" -o "${gqrxIsRunning}" == "grep" ]; then
    echo "stopped" > ${home_dir}/gqrx.state
  else
    echo "running" > ${home_dir}/gqrx.state 
  fi
done

echo "Stopping..."
exit 0
