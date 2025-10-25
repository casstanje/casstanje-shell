#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi

# If folders aren't already the correct color, change it
currentFlavor=$(papirus-folders -l | grep ">") # Outputs " > <flavor>"
if ! [ "$currentFlavor" = " > $flavor" ]; then
    pkexec papirus-folders -C "cat-mocha-$flavor"
fi