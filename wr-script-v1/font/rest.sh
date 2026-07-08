#!/bin/bash
# rest.sh — 循环播放 ASCII 休息画面
file="$HOME/opt/myscripts/vr-script/font/*"
while [ 1 ]
do
    for i in $file
    do
        file_name=${i##*/}
        if [ ${file_name:0:5} == "rest-" ]; then
            cat "$i" && echo "$(date '+%Y-%m-%d %a %X')"
            sleep 1
            clear
        fi
    done
done
