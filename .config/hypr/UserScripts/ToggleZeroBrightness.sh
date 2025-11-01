#!/bin/bash
# Get the current brightness percentage using brightnessctl
CURRENT=$(brightnessctl | grep -oP '\d+(?=%)')

# If brightness is not 0, set it to 0; otherwise, set it to 90
if [ "$CURRENT" -ne 0 ]; then
    brightnessctl set 0%
else
    brightnessctl set 90%
fi
