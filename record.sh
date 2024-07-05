#!/usr/bin/env bash

export OUT_DIR="out"
export OUT_PID_FILE="vlc_pids_${RANDOM}.txt"

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
        echo $vlc_pid >> $OUT_PID_FILE
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

for pid in $(cat $OUT_PID_FILE)
    kill -9 $pid
do 
