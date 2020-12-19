# Update avconv

Bash script which updates avconv to latest snapshot version on Mac OS X.

$ `chmod 755 update-avconv.sh`

$ `sh update-avconv.sh`

To access script anywhere place it to `/opt/local/bin/`

# Requirements

`sudo port install wget`

`sudo port install yasm`

`sudo port install ffmpeg +gpl +postproc +lame +theora +libogg +vorbis +xvid +x264 +a52 +faac +faad +dts +nonfree`