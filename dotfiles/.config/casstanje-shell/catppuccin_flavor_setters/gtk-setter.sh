#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
sed --follow-symlinks -i "/env = GTK_THEME,/c\\env = GTK_THEME,catppuccin-mocha-$flavor-standard+default" $HOME/.config/hypr/hyprenv.conf