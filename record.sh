#!/usr/bin/env bash

for url in `cat urls.txt` 
do
    room_id=${url##*/}
    room_id=${room_id%\?*}
    (
        filename=out/${room_id}_out.mpg
        vlc -I dummy $url --sout file/ts:${filename} &
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
