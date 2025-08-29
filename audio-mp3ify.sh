#!/bin/sh

for file in "$@"; do
  basename="${file%.*}"
  ffmpeg -i "${file}" -acodec libmp3lame -ab 192k "${basename}.mp3"
done

