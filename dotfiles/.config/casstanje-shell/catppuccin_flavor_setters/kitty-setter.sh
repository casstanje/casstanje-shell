#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
sed -i "/include color_/c\\include color_$flavor.conf" $HOME/.config/kitty/kitty.conf