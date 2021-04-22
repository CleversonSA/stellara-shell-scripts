#! /bin/bash

systemctl stop chronyd
systemctl start chronyd
systemctl status chronyd
exit
