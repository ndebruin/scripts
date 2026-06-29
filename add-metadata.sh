#!/bin/bash

function usage() {
    printf "\nUsage: $0 [--artist] [--album]\n
    Options
        --artist        Specify Artist for metadata
        --album         Specify Album for metadata\n\n"
    exit 1
}

ARTIST=
ALBUM=

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for arg in "$@"; do
    case $arg in
    --artist)
        ARTIST=$2
        shift
        shift
        ;;
    --album)
        ALBUM=$2
        shift
        shift
        ;;
    -h | --help)
        usage
        exit 1
        ;;
    esac
done

LIST=$(ls *.mp3)
IFS=$'\n'
for LINE in $LIST
do
    ffmpeg -i $LINE -i cover.jpg -map 0:0 -map 1:0 -c copy "$LINE.new.mp3"
    rm $LINE
    mv "$LINE.new.mp3" $LINE
done
unset IFS

LIST=$(ls *.mp3)
IFS=$'\n'
for LINE in $LIST
do
    NAME=${LINE%.*}
	EXT=".${LINE##*.}"
	TRACK=${NAME%-*}
    TITLE=${NAME#*- }
    ffmpeg -i $LINE -metadata "TITLE=$TITLE" -metadata "TRACK=$TRACK" -metadata "ARTIST=$ARTIST" -metadata "ALBUM=$ALBUM" -c copy "$LINE.new.mp3"
    rm $LINE
    mv "$LINE.new.mp3" $LINE
done
unset IFS

