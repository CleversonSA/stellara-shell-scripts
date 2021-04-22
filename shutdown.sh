#!/bin/bash
shutdown -h $1
echo "Press ENTER to cancel the shutdown timer..."
read
shutdown -c
echo "Shutdown cancelled. Press Enter to close"
read
exit 0
