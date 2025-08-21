#!/bin/bash
current_profile=$(powerprofilesctl get)
if [ "$current_profile" = "balanced" ]; then
    powerprofilesctl set performance
elif [ "$current_profile" = "performance" ]; then 
    powerprofilesctl set power-saver
else
    powerprofilesctl set balanced
fi