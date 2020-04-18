#!/bin/bash
#
# folderize-media.sh
#
# Purpose: sorts media files into subdirectories
#
# Current implementation:
# * takes file date from filename
# * moves into subdirectories for year and month: `YYYY/YYYY-MM`
#
# Author: Felix Neumann <dev@fxnn.de>, https://fxnn.de
#
# Todo:
# * read data from EXIF, e.g. `exiv2 -r ':dirname:/%Y/%m/:basename:' mv *.jpg`
#
#

#
# Parse commandline arguments

WORK_DIR=${1%/}
if [ -z "${WORK_DIR}" ]; then
	echo "error: no work dir given" >&2
	exit 1
fi

#
# Scan & move files

echo "work dir: ${WORK_DIR}"

for filepath in ${WORK_DIR}/*; do
	# HINT: avoid the case of no matches, were filename contains the glob
	[ -e "$filepath" ] || continue
	[ -f "$filepath" ] || continue

	filename=${filepath##*/}
	# e.g. 
	# 20191231_235959_1.jpg
	# IMG_20191231_235959.JPG
	# IMG_20200326_160053~2.jpg
	# IMG_20200404_110534.MOV
	# MOV_20191231_235959.MP4
	# VIDEO_20191231_235959_fx.mp4
	# SL_MO_VID_20191012_170647.mp4
	target_subfolder=$(echo $filename | sed -En 's#^([A-Z][A-Z0-9_]{2,}[_-])?(20[0-9]{2})([0-9]{2})[0-9]{2}[_-][0-2][0-9][0-5][0-9][0-5][0-9]([_~-][A-Za-z0-9_~-]+)?\.([a-zA-Z0-9]+)$#\2/\2-\3#p')
	[ -n "$target_subfolder" ] || continue
	echo ${WORK_DIR}/${target_subfolder}/${filename}

	target_dir="${WORK_DIR}/${target_subfolder}"
	target_filepath="${target_dir}/${filename}"
	mkdir -p "${target_dir}"
	mv "${filepath}" "${target_filepath}"
done

