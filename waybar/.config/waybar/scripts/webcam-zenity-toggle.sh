#!/bin/bash

# Ask for sudo password via Zenity
PASSWORD=$(zenity --password --title="Webcam Toggle")

# User cancelled or empty
if [ -z "$PASSWORD" ]; then
    exit 0
fi

# Function to run sudo using typed password
run_sudo() {
    echo "$PASSWORD" | sudo -S "$@"
}

# Check current webcam state
if lsmod | grep -q uvcvideo; then
    # Webcam is ON → force turn OFF
    if run_sudo rmmod -f uvcvideo; then
        echo "off" > /tmp/webcam_state
    fi
else
    # Webcam is OFF → turn ON
    if run_sudo modprobe uvcvideo; then
        echo "on" > /tmp/webcam_state
    fi
fi


