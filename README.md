# scripts
A dumping ground for various scripts I write.

# smart-email.sh
Emails the results of a SMART test to a provided email address.
Takes a single argument for the name of a drive.
```
./smart-email.sh sda
```
Just provide the short name, do not provide the full path of ``/dev/sda``.
Requires access to ``smartctl`` and ``mail``.

# smart-email-truenas.sh
Emails the results of a SMART test to a provided email address.
Takes a single argument for the name of a drive.

Fixed formatting to handle strange mail handling on TrueNAS, and changed path of ``smartctl``.
```
./smart-email.sh ada0
```
Just provide the short name, do not provide the full path of ``/dev/ada0``.
Requires access to ``smartctl`` and ``sendmail``.

# youtube-dl-auto.sh
Downloads a playlist off of youtube, and populates metadata, including cover art.
```
Usage: ./youtube-dl-auto.sh [--artist] [--album] [youtube url]

    Options
        --artist        Specify Artist for metadata
        --album         Specify Album for metadata
        youtube url     Playlist of music you would like to download
```
Requires ``youtube-dl``, ``ffmpeg`` and ``bash`` or compatible shell.

# setup.sh
Setup script for setting up a new server, with SSH Keys, packages, and CAs.
Simply pull and run. Only tested on Debian 10, will likely work on derivatives.
Requires ``sudo``.

# speedtest.sh
Work of: https://github.com/rsvp/speedtest-linux
I have a copy of it here because hey, that's how open source works.

# ffmpeg-resize-video.sh
Script to resize a mp4 file to a specific size.

Usage: ``./ffmpeg-resize-video.sh original-video.mp4 SIZE`` size being in MB.

Obviously requires ``ffmpeg``.
