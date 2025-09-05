#!/bin/bash
JQ_OUTPUT=$(jq '.barConfig' $HOME/.config/casstanje-shell/config.json)
echo "$JQ_OUTPUT"