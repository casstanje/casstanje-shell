#!/bin/bash
osName=$(fastfetch -s os --format json | jq -r '.[0].result.name')
color="\033[0;32m"
printf "$color$(figlet -f smslant $osName)\033[0m\n" && fastfetch -l none