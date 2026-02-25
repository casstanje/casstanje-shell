#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
sed --follow-symlinks -i "/property color accent:/c\\    property color accent: $flavor" $HOME/.config/quickshell/default/Theme.qml