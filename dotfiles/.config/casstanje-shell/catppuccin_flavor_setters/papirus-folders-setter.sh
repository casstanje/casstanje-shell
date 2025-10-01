#!/bin/bash
flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
papirus-folders -C "cat-mocha-$flavor"