#!/bin/bash
# year.sh — 循环播放 ASCII 年度画面
file="$HOME/opt/myscripts/vr-script/font/*"
while [ 1 ]
do
    for i in $file
    do
        file_name=${i##*/}
        if [ ${file_name:0:5} == "year-" ]; then
            cat "$i"
            sleep 2
            clear
        fi
    done
done
