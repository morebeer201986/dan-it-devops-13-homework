#!/bin/bash

THRESHOLD=$1

# Log file
LOGFILE="/var/log/disk.log"

# Check: if no argument is passed, the script terminates
if [ -z "$THRESHOLD" ]; then
    echo "Error: Please provide a threshold percentage."
    exit 1
fi

# Get the percentage of root partition “/” usage
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')

# Compare current usage with threshold
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    # If usage exceeds the threshold, write a message to the log
    echo "$(date '+%Y-%m-%d %H:%M:%S') - WARNING: High disk utilization: $USAGE% (Threshold: $THRESHOLD%)" >> $LOGFILE
fi