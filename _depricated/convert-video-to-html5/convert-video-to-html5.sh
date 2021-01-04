#!/bin/bash
input=$1
output=$2

if [ -n "$2" ]
then
  echo 'Input': $1
  echo 'Output': $2
else
  # Exit if not given.
  echo 'Input and output parameter required!"'
  echo 'Usage "convert-video-to-html5 [input] [output] {prod|dev} {bitrate=2000} {maxrate=2000} {bufsize=1000}"'
  exit
fi

if [ -n "$4" ]
then
  enviroment=$4
else
  enviroment='dev'
fi

if [ -n "$4" ]
then
  bitrate=$4
else
  bitrate=2000
fi

echo 'Using bitrate': $4

if [ -n "$5" ]
then
  maxrate=$5
else
  maxrate=2000
fi

echo 'Using maxrate': $5

if [ -n "$6" ]
then
  bufsize=$6
else
  bufsize=1000
fi

echo 'Using bufsize': $6


echo "Creating $1.mp4 ..."
avconv -i $input -vcodec libx264 -filter:v yadif -vf scale=w=1280:h=720 -b:v ${bitrate}k -maxrate ${maxrate}k -bufsize ${bufsize}k -threads 0 -acodec libfaac -b:a 96k -aspect 16:9 $output.mp4

if [ "$3" = prod ]
then
  echo "Creating $1.webm ..."
  avconv -i $input -s 4cif -ab 96k -filter:v yadif -vf scale=w=1280:h=720 -vb ${bitrate}k -threads 0 -aspect 16:9 $output.webm
  echo "Creating $1.ogv ..."
  avconv -i $input -vcodec libtheora -acodec libvorbis -vf scale=w=1280:h=720 -b:v ${bitrate}k -threads 0 -aspect 16:9 $output.ogv
fi
