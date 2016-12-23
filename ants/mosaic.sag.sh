#!/bin/sh

CreateTiledMosaic -t -1x-1 -s -5 -d 1 -a 0 -i ${1} -r ${1} -o ${1%.nii.gz}_tiled.png
