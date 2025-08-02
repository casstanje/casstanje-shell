#!/bin/bash
while :
do
    STRING=$(hyprctl getoption general:layout)
    arrSTRING=(${STRING// set:/ })
    echo ${arrSTRING[1]}
    sleep 1
done