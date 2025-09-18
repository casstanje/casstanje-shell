#!/bin/bash
MONITORS="$(hyprctl monitors all)"
if echo "$MONITORS" | grep -q "eDP-1" ; then # Check if laptop screen exists
	if  echo "$MONITORS" | grep -q "(ID 1):" ; then # Check if there is more than one monitor, e.g, any external
		hyprctl keyword monitor eDP-1, disable
		NEW_MAIN="$(echo "$MONITORS" | sed -e '/(ID 1):/!d')"
		IFS=' ' read -ra LINE_ARR <<< "$NEW_MAIN"
		NEW_MAIN="${LINE_ARR[1]}"
		hyprctl keyword monitor , preffered, auto, 1, mirror, $NEW_MAIN 
	fi
fi # Was not laptop
