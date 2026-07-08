#!/bin/bash
# moyu.sh — 循环播放 ASCII 摸鱼画面
file="$HOME/opt/myscripts/vr-script/font/*"
while [ 1 ]
do
    for i in $file
    do
        file_name=${i##*/}
        if [ ${file_name:0:5} == "moyu-" ]; then
            cat "$i" && echo "$(date '+%Y-%m-%d %a %X')"
            sleep 1
            clear
        fi
    done
done
