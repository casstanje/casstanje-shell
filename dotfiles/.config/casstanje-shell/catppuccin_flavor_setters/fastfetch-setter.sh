#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
if [ "$flavor" == "green" ]; then
    color="32"
    colorString="green"
elif [ "$flavor" == "mauve" ] || [ "$flavor" == "pink" ] || [ "$flavor" == "lavender" ]; then
    color="35"
    colorString="magenta"
elif [ "$flavor" == "sapphire" ] || [ "$flavor" == "blue" ]; then
    color="34"
    colorString="blue"
elif [ "$flavor" == "yellow" ]; then
    color="33"
    colorString="yellow"
elif [ "$flavor" == "sky" ] || [ "$flavor" == "teal" ]; then
    color="36"
    colorString="cyan"
else
    color="31"
    colorString="red"
fi
    
sed --follow-symlinks -i "/color=\"\\\033/c\color=\"\\\033\[0\;$color\m\"" "$HOME"/.config/casstanje-shell/casstanje-fastfetch.sh
sed --follow-symlinks -i "/      \"keys\": \"italic_bold_/c\      \"keys\": \"italic_bold_$colorString\"," "$HOME"/.config/fastfetch/config.jsonc
sed --follow-symlinks -i "/      \"title\": \"/c\      \"title\": \"bright_bold_$colorString\"," "$HOME"/.config/fastfetch/config.jsonc
