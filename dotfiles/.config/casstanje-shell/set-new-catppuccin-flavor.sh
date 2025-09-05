#!/bin/bash
flavor="$1"
sed -i "/\"catppuccinflavor\":/c\\    \"catppuccinflavor\": \"$flavor\"," $HOME/.config/casstanje-shell/config.json
bash $HOME/.config/casstanje-shell/apply-catppuccin-flavor.sh