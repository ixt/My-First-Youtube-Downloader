#!/usr/bin/env bash
SOURCE="https://www.youtube.com/results?q=intitle%3A%22first+vlog%22&sp=EgIIAQ%253D%253D"
COUNT=0
DISPLAY=:0
cd $(dirname $0)
while true; do
    lynx --dump -listonly -nonumbers $SOURCE | grep watch | sort | uniq | sed -n -e 's/.*?v=//gp' > .currentvideos
    cd videos
    while read entry; do
        if [ ! -e $entry.mp4 ]; then
            ../youtube-dl --max-views 200 --id -f 18 $entry
            omxplayer $entry.mp4 &
            # mpv $entry.mp4 --quiet --osc=no --geometry=$(($RANDOM % 100))%:$(($RANDOM % 100))% &
        fi
    done < ../.currentvideos
    cd ..
    ls ./videos -1 | sed -e 's/.mp4//g'  > .downloadedvideos
    while read downloaded; do
        if [ ! $(grep $downloaded .currentvideos) ]; then
            rm videos/$downloaded.mp4
        fi
    done < .downloadedvideos
    (( COUNT++ ))
    sleep 30s
    echo $COUNT
done
