#!/usr/bin/env bash

OUT_DIR="out"

rm -f vlc_pid.txt
mkdir -p $OUT_DIR

for url in `cat urls.txt` 
do
    room_id=${url##*/}
    room_id=${room_id%\?*}
    (
        filename=${OUT_DIR}/${room_id}_out.mpg
        if [ -f $filename ]
        then
            echo $filename exists, skipping...
            exit 1
        fi
        vlc -I dummy $url --sout file/ts:${filename} &> /dev/null &
        vlc_pid=$!
        echo $vlc_pid >> vlc_pid.txt
        sleep 3
        size=$(LANG=C stat ${filename} | head -2 | tail -1 | cut -d ' ' -f 4)
        if [[ ${size} == 0 ]]
        then
            kill $vlc_pid
            rm $filename
        fi
        wait
    ) &
done

wait

for pid in `cat vlc_pid.txt`
    kill -9 $pid
do 
