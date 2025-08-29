#!/bin/sh

for file in "$@"; do
  echo "${file}"
  ffprobe -v error -show_format "${file}"
  echo
done

