#!/bin/bash
echo "$(jq -c  '.defaultApps[]' $HOME/.config/casstanje-shell/config.json)"