#!/bin/sh
# Removes any superfluous metadata that might confuse old mp3 playing devices
#

set -e

for file in "$@"; do
  echo "$file"
  tmpfile=`mktemp`
  cp "$file" "$tmpfile"
  rm "$file"
  ffmpeg \
    -v warning \
    -y \
    -i "$tmpfile" \
    -vn \
    -metadata lyrics= \
    -metadata LYRICS= \
    -metadata "id3v2_priv.WM/UniqueFileIdentifier=" \
    -metadata "id3v2_priv.WM/MediaClassSecondaryID=" \
    -metadata "id3v2_priv.WM/MediaClassPrimaryID=" \
    -metadata "id3v2_priv.WM/Provider=" \
    -metadata "id3v2_priv.WM/WMContentID=" \
    -metadata "id3v2_priv.WM/WMCollectionID=" \
    -metadata "id3v2_priv.WM/WMCollectionGroupID=" \
    -metadata "id3v2_priv.www.amazon.com=" \
    -metadata "copyright=" \
    -metadata "c0=" \
    -metadata "MusicBrainz Artist Id=" \
    -metadata "musicbrainz_artistid=" \
    -metadata "MusicBrainz Album Id=" \
    -metadata "musicbrainz_albumid=" \
    -metadata "MusicBrainz Album Artist Id=" \
    -metadata "musicbrainz_albumartistid=" \
    -metadata "encoded_by=" \
    -metadata "TOFN=" \
    -metadata "TDOR=" \
    -metadata "http://www.jamendo.com/=" \
    -c copy \
    "$file" \
    && rm "$tmpfile" \
    || mv "$tmpfile" "$file"
done
 
