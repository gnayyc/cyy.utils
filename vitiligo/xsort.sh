#!/bin/sh

# Example
# $ idexif.sh 0123456_name IMG_0001.jpg

# set id to the Artist Tag
#exif -t 0x013b --ifd=0 --set-value="${1}" "${2}" -o "${2}"

I="$1"
orig=${I%.*}

name=`exif -t 0x013b -m "${I}"`
datetime=`exif -t 0x0132 -m "${I}" | sed "s/://g" | sed "s/ /_/g"`
date=`echo $datetime| awk -F"_" '{print $1}'`
time=`echo $datetime| awk -F"_" '{print $2}'`

mkdir -p $date
_to=$date/${name}_${datetime}_${orig}

if [ -f $_to ]; then
fi
