#!/bin/bash
JQ_OUTPUT=$(jq --compact-output 'recurse(.[]?) | objects | select(has("type"))' $HOME/.config/casstanje-shell/config.json)
while IFS= read -r line; do
    name="$(echo $line | jq -r '.name')"
    type="$(echo $line | jq -r '.type')"
    value="$(echo $line | jq -r '.value')"
    if [ "$type" == "string" ]; then
        value="\"$value\""
    elif [ "$type" == "SystemClock" ]; then
        if [ "$value" == "0" ]; then 
            value="SystemClock.Seconds"
        elif [ "$value" == "1" ]; then 
            value="SystemClock.Minutes"
        else
            value="SystemClock.Hours"
        fi
    elif [ "$type" == "int" ]; then
        if ![[ $value =~ ^-?[0-9]+$ ]]; then
            $value = "0"
        fi
    fi

    sed -i "/property $type $name:/c\\    property $type $name: $value" $HOME/.config/quickshell/default/Config.qml
done <<< "$JQ_OUTPUT"