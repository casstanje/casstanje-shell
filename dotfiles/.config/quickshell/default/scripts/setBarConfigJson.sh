#!/bin/bash
PRETTY_JSON="$(echo "$1" | jq '.')"
tmp=$(mktemp)
# Remove existing value in a temp file
jq '.barConfig = ""' $HOME/.config/casstanje-shell/config.json > "$tmp"

startingLineNumber="$(grep -n "\"barConfig\":" $HOME/.config/casstanje-shell/config.json | head -n 1 | cut -d: -f1)"
lineNumber="$startingLineNumber"
fullString=""
while IFS= read -r line ; do
    if [[ $lineNumber -eq $startingLineNumber ]]; then
        sed -i "/\"barConfig\":/c\\  \"barConfig\": ${line}" $tmp
    else
        sed -i "${lineNumber}i\  ${line}" $tmp
    fi
    # echo "$lineNumber"
    lineNumber="$(($lineNumber + 1))"
done <<< "$PRETTY_JSON"

#replace content with temp file
mv "$tmp" $HOME/.config/casstanje-shell/config.json

# Apply new settings
bash $HOME/.config/casstanje-shell/apply-bar-config.sh