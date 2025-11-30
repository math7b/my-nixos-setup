#!/bin/bash

STATE="on"
if [ -f /tmp/webcam_state ]; then
    STATE=$(cat /tmp/webcam_state)
fi

if ! lsmod | grep -q uvcvideo; then
    STATE="off"
fi

if [ "$STATE" = "on" ]; then
    ICON="󰄀"    # camera on
else
    ICON="󰗟"    # camera off
fi

echo "{\"text\":\"$ICON\", \"class\":\"$STATE\"}"

