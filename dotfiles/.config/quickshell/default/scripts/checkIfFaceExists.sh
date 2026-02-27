#!/bin/bash
exists=false
filePath="$HOME/.face"
if [ -e "$filePath" ]; then
    identifyRes="$(identify -format "%m" $HOME/.face)"
    if echo "$identifyRes" | grep -q "JPEG" || echo "$identifyRes" | grep "PNG" ; then
        exists=true
    fi
fi

if $exists; then
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