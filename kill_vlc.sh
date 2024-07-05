#!/usr/bin/env bash

export OUT_DIR="out"

for url in `cat urls.txt` 
do
    room_id=${url##*/}
    room_id=${room_id%\?*}
    filename=${OUT_DIR}/${room_id}_out.mpg
    if ! [ -f $filename ]
    then 
        if pid=$(pgrep -f file/ts:$filename)
        then
            echo $pid
        else
            echo vlc recording $filename not found, skipping
        fi
    fi
done

