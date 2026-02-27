#!/bin/bash
if [ -x "$(command -v brightnessctl)" ]; then echo "true"; else echo "false"; fi