#!/usr/bin/env bash
SOURCE="https://www.youtube.com/results?q=intitle%3A%22first+vlog%22&sp=EgIIAQ%253D%253D"
lynx --dump -listonly -nonumbers $SOURCE | grep watch | sort | uniq | sed -e 's/.*=//g' > .currentvideos
cd videos
while read entry; do
    if [ ! -e $entry.mp4 ]; then
        youtube-dl --id -f mp4 $entry
        mpv $entry.mp4 &
    fi
done < ../.currentvideos

