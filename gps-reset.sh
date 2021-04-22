#!/bin/bash
systemctl stop gpsd
systemctl start gpsd
systemctl status gpsd
exit 0
