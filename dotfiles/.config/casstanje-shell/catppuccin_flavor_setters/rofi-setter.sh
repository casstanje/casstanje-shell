#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
sed --follow-symlinks -i "/  accent: @/c\\  accent: @$flavor;" $HOME/.config/rofi/config.rasi