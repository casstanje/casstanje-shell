#!/bin/bash
JSON_STRING=$( jq -n \
                    --arg cb "$(brightnessctl g -d "$1")" \
                    --arg mb "$(brightnessctl m -d "$1")" \
                    '{currentbrightness: $cb, maxbrightness: $mb}' )
echo "$JSON_STRING"