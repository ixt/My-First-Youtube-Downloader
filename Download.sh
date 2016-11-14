#!/usr/bin/env bash
SOURCE="https://www.youtube.com/results?q=intitle%3A%22first+vlog%22&sp=EgIIAQ%253D%253D"
COUNT=0
while true; do
    lynx --dump -listonly -nonumbers $SOURCE | grep watch | sort | uniq | sed -e 's/.*=//g' > .currentvideos
    cd videos
    while read entry; do
        if [ ! -e $entry.mp4 ]; then
            youtube-dl --id -f mp4 $entry
            mpv $entry.mp4 --quiet &
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
    sleep 60s
    echo $COUNT
done

