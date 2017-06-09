#!/bin/bash

######
#   pyca-script
#
#   This bash script demonstrates recording multiple sources for audio & video
#   with a single command. It is intended to be used with the pyca capture
#   agent by Lars Kiesow. Based in a script of Jan Koppe <jan.koppe@wwu.de>
#
#   @author  Mario Francia Rius <mariofranciarius@gmail.com>
#   @date     2017-06-09
#	
######

######
#
#
#   where...
#     directory:  where to put the recordings, relative to CWD
#     name:       basename for the files
#     time:       length of the recording in seconds
#
######


# ARGS
DIRECTORY=$1
NAME=$2
TIME=$3

# INTERNAL
pids=""         # pids for capture processes, used to check exit codes
delay_option=""

######
#   Capture webcam 1080
ffmpeg -nostats -re -f v4l2 -r 25 -i /dev/video0 -s 1920x1080 -t $TIME \
	"$DIRECTORY/$NAME presenter.mp4" \
  &             # run in background

pids+=" $!"     # save pid
#
######

######
#   Capture desktop debian
ffmpeg -f x11grab -r 25 -t $TIME \
	-s 1280x720 -i :0.0+0,24 -vcodec libx264 "$DIRECTORY/$NAME presentation.mp4" \
  &             # run in background

pids+=" $!"     # save pid
#
######

######
#   Capture audio micro
ffmpeg -f alsa -i hw:0 -t $TIME \
	"$DIRECTORY/$NAME presenter.mp3" \
  &             # run in background

pids+=" $!"     # save pid

######

######
#   Streaming and video mp4 output
timeout $TIME ffmpeg -nostats -f alsa -i hw:0 -f v4l2 -i /dev/video1 -s 1920x1080 -ar 11025 -f flv -r 30 "rtmpURL" $DIRECTORY/$NAME-streaming.mp4 \
  &             # run in background

pids+=" $!"     # save pid
#
######

#   Wait for recordings to finish (running as background processes), then finish
for p in $pids; do
  if wait $p; then
    echo "$p successful"
  else
    exit $?
  fi
done

