#!/bin/bash
IFS="," read -r -a keys <<< "$(bash $HOME/.config/casstanje-shell/get-app-defaults-keys.sh)"
mapfile -t values < <( bash $HOME/.config/casstanje-shell/get-app-defaults-values.sh )

for i in "${!keys[@]}"; do
    key="${keys[$i]}"
    cleanedKey="${key//\"/}"
    cleanedKey="${cleanedKey//\[/}"
    cleanedKey="${cleanedKey//\]/}"

    value="${values[$i]}"
    cleanedValue="${value//\"/}"

    echo "$cleanedValue"

    # Hyprland Binds
    sed -i "/\$$cleanedKey =/c\\\$$cleanedKey = $cleanedValue" $HOME/.config/hypr/hyprbinds.conf

    # XDG-MIME TODO
done