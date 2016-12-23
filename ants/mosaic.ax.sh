#!/bin/sh

CreateTiledMosaic -t -1x-1 -s -2 -d y -a 0 -f 1x1 -i ${1} -r ${1} -o ${1%.nii.gz}_tiled.png
