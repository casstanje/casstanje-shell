#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
sed -i "/\$accent=/c\\\$accent=\$$flavor" $HOME/.config/hypr/colors.conf