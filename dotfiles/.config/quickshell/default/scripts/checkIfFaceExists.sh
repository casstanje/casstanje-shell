#!/bin/bash
eitherExists=false

if [ -e "$HOME/face.png" ]; then
    eitherExists=true
    filePath="$HOME/face.png"
elif [ -e "$HOME/face.jpeg" ]; then
    eitherExists=true
    filePath="$HOME/face.jpeg"
elif [ -e "$HOME/face.jpg" ]; then
    eitherExists=true
    filePath="$HOME/face.jpg"
fi

if $eitherExists; then
    width=$(identify -format "%w\n" "$filePath")
    height=$(identify -format "%h\n" "$filePath")
    width=$((width))
    height=$((height))
    # Also check if size is valid
    if [[ $width -lt 400 ]] && [[ $height -lt 400 ]]; then
        echo "$filePath"
    else
        echo "false"
    fi
else
    echo "false"
fi