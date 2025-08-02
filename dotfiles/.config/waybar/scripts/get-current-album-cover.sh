#!/bin/bash
coverUrl=$(playerctl -s --player=%any metadata --format {{mpris:artUrl}})
status=$(playerctl -s status)
if [ "${status}" = "" ]; then
    echo "$HOME/.config/waybar/resources/transparent_square.png"
elif [[ $coverUrl == *"file://"* ]]; then
    DATA=$coverUrl
    pattern="file://"
    DATA=${DATA/$pattern/}
    echo "${DATA}"
else
    # Path to download album art to
    file="$HOME/.config/waybar/resources/tmp/album-cover.png"

    # Check if file exists and set z falg accordingly
    if test -e "$file"
    then zflag="-z '$file'"
    else zflag=
    fi

    # if file was downloaded correctly, return the downloaded cover. Else, return the placeholder
    gotImage=false
    if [ "$coverUrl" != "" ]; then
        if curl -s -o "$file" $zflag "$coverUrl"
        then gotImage=true
        fi
    fi
    
    if [ "$gotImage" = true ];
    then echo "$file"
    else echo "$HOME/.config/waybar/resources/album_cover_placeholder.png"
    fi
fi