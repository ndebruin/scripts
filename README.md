# scripts
A dumping ground for various scripts I write

# smart-email.sh
Emails the results of a SMART test to a provided email address.
Takes a single argument for the name of a drive.
```
./smart-email.sh sda
```
Just provide the short name, do not provide the full path of ``/dev/sda``.
Requires access to ``smartctl`` and ``mail``.

# youtube-dl-auto.sh
Downloads a playlist off of youtube, and populates metadata, including cover art.
```
Usage: ./youtube-dl-auto.sh [--artist] [--album] [youtube url]

    Options
        --artist        Specify Artist for metadata
        --album         Specify Album for metadata
        youtube url     Playlist of music you would like to download
```

# setup.sh
Setup script for setting up a new server, with SSH Keys, packages, and CAs.
Simply pull and run.
Requires ``sudo``.
