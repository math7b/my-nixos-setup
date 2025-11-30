#!/bin/bash

# GUI sudo password prompt
PASSWORD=$(zenity --password --title="Webcam Control")

# Check if password was entered
if [ -z "$PASSWORD" ]; then
    zenity --error --text="No password entered. Aborting."
    exit 1
fi

# Run sudo commands using the password
run_sudo() {
    echo "$PASSWORD" | sudo -S "$@"
}

# Check webcam state
if lsmod | grep -q uvcvideo; then
    # Webcam is ON → turn it OFF
    if run_sudo modprobe -r uvcvideo; then
        zenity --info --text="Webcam turned OFF"
    else
        zenity --error --text="Failed to turn OFF the webcam"
    fi
else
    # Webcam is OFF → turn it ON
    if run_sudo modprobe uvcvideo; then
        zenity --info --text="Webcam turned ON"
    else
        zenity --error --text="Failed to turn ON the webcam"
    fi
fi

