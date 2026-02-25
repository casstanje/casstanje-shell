#!/bin/bash
(lspci | grep -E 'VGA|Display') |
while read -r line 
do
    if ! [ -z "$gpus" ]; then 
        gpus="$gpus\n"
    fi
    echo "$line" | sed 's/\[/\n/g' | sed -n '2p' | sed 's/\]/\n/g' | head -n 1
    # gpus="$gpus $(echo "$line" | sed 's/\[/\n/g' | sed -n '2p' | sed 's/\]/\n/g' | head -n 1)"
done