#!/bin/bash
IFS='¾' read -r -a newSettings <<< "$1" # Uses ¾ becuase it's highly unlikely that the user will ever use that in a command
IFS="," read -r -a keys <<< "$(bash $HOME/.config/casstanje-shell/get-app-defaults-keys.sh)"
for i in "${!keys[@]}"; do
    key="${keys[$i]}"
    cleanedKey="${key//\"/}"
    cleanedKey="${cleanedKey//\[/}"
    cleanedKey="${cleanedKey//\]/}"

    value="${newSettings[$i]}"
    cleanedValue="${value//\"/}"

    if [ "$key" != "${keys[-1]}" ] ; then
        suffix=","
    else
        suffix=""
    fi

    sed -i "/\"$cleanedKey\":/c\\        \"$cleanedKey\": \"$cleanedValue\"$suffix" $HOME/.config/casstanje-shell/config.json
done

bash $HOME/.config/casstanje-shell/apply-application-defaults.sh
