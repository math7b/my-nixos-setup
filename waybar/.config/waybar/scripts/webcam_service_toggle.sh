#!/bin/bash

# Check if module is loaded
if lsmod | grep -q uvcvideo; then
    LOADED=1
else
    LOADED=0
fi

# Toggle if requested
if [ "$1" = "toggle" ]; then
    if [ "$LOADED" -eq 1 ]; then
        sudo modprobe -r uvcvideo
    else
        sudo modprobe uvcvideo
    fi
fi

# Update status
if lsmod | grep -q uvcvideo; then
    echo '{"text": "󰖠", "tooltip": "Webcam enabled", "class": "on"}'
else
    echo '{"text": "󰗹", "tooltip": "Webcam disabled", "class": "off"}'
fi

