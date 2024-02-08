#!/bin/sh

# Get the monitor name with 5120x1440 resolution
MONITOR_NAME=$(xrandr | grep -E ' connected.*5120x1440' | awk '{print $1}')

# Check if a monitor was found
if [ -z "$MONITOR_NAME" ]; then
    echo "No monitor with 5120x1440 resolution found."
else
    # Set up the monitors
    xrandr --setmonitor "${MONITOR_NAME}-1" 1280/1280x1440/173+0+1440 none &&
    xrandr --setmonitor "${MONITOR_NAME}-2" 2560/2560x1440/173+1280+1440 none &&
    xrandr --setmonitor "${MONITOR_NAME}-3" 1280/1280x1440/173+3840+1440 none
    echo "Monitor configuration successful!"
fi
