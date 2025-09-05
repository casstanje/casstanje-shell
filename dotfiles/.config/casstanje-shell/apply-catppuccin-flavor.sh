#!/bin/bash
flavor=$(jq -r '.catppuccinflavor' $HOME/.config/casstanje-shell/config.json)
# You can add more applications that you want to follow the system flavor, 
# by just adding a setter script to $HOME/.config/casstanje-shell/catppuccin_flavor_setters/
# that takes CATPPUCCIN_FLAVOR as an argument. 
# The existing scripts may be good reference points if you're confused (don't worry, i hate bash too)
for f in $HOME/.config/casstanje-shell/catppuccin_flavor_setters/*; do
    CATPPUCCIN_FLAVOR="$flavor" bash $f
done
hyprctl reload