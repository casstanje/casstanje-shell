#!/bin/bash
echo $(jq -r '.catppuccinflavor' $HOME/.config/casstanje-shell/config.json)