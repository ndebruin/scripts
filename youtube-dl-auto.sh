#!/bin/bash

function usage() {
    printf "\nUsage: $0 [--artist] [--album] [youtube url]\n
    Options
        --artist        Specify Artist for metadata
        --album         Specify Album for metadata
        youtube url     Playlist of music you would like to download\n\n"
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

if [[ $ARTIST == "" ]]; then
    echo "You must provide an Artist";
    exit 1;
fi

if [[ $ALBUM == "" ]]; then
    echo "You must provide an Album Name";
    exit 1;
fi

youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 --output "%(autonumber)s - %(title)s.%(ext)s" $1
youtube-dl --write-thumbnail --playlist-items 1 --skip-download --output "cover" $1
ffmpeg -i cover.webp cover.jpg
rm cover.webp
COVER="cover.jpg"
LIST=$(ls *.mp3)
IFS=$'\n'
for LINE in $LIST
do
    LINEW=${LINE:3}
    mv "$LINE" "$LINEW"
done
unset IFS
read -p "Please confirm that cover.jpg is the correct cover art for the album. If it is not, then please correct it. [y] "
LIST=$(ls *.mp3)
IFS=$'\n'
for LINE in $LIST
do
    ffmpeg -i $LINE -i $COVER -map 0:0 -map 1:0 -c copy "$LINE.new.mp3"
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
    echo "$TRACK    $TITLE"
    ffmpeg -i $LINE -metadata "TITLE=$TITLE" -metadata "TRACK=$TRACK" -metadata "ARTIST=$ARTIST" -metadata "ALBUM=$ALBUM" -c copy "$LINE.new.mp3"
    rm $LINE
    mv "$LINE.new.mp3" $LINE
done
unset IFS

mkdir "$ARTIST - $ALBUM"
mv *.mp3 "$ARTIST - $ALBUM/"
mv cover.jpg "$ARTIST - $ALBUM/"
exit 0