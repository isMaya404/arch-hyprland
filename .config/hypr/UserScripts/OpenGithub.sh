#!/bin/bash

URL="https://github.com/isMaya404?tab=repositories"

# Open Messenger in an existing Firefox window or launch a new instance
if pgrep -x "firefox" > /dev/null; then
    firefox --new-tab "$URL"
else
    firefox "$URL" &
    sleep 1 # Give it time to start
fi

# Get the window ID of the last opened Firefox window
WIN_ID=$(hyprctl clients | grep -B4 "firefox" | grep "address: 0x" | tail -n1 | awk '{print $2}')

# Focus on that window
if [ -n "$WIN_ID" ]; then
    hyprctl dispatch focuswindow address:$WIN_ID
fi
