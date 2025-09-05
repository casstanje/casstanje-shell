#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
sed -i "/theme=/c\\theme=catppuccin-mocha-$flavor" $HOME/.config/Kvantum/kvantum.kvconfig