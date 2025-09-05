#!/bin/bash
echo "$(jq '.defaultApps' $HOME/.config/casstanje-shell/config.json | jq -c -j 'keys_unsorted')"