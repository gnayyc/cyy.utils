#!/bin/sh

image_dir=${1}
class_dir=${2}

echo ${class_dir}:
for i in ${image_dir}/*.png; do
    if [ -f ${i}_${class_dir}.csv ]; then
	echo "  ${i} [${class_dir}] [done]"
    else
	echo "+ ${i} [${class_dir}] \c"
	find ${class_dir} -type f -name "*.png" |\
	awk -v label=${class_dir} -v image=$i '{print image, $(0), label }' |\
	parallel --will-cite -j10 --linebuffer --colsep ' ' ./compare.sh {1} {2} {3}
	echo "[done]"
	if [ ! -f ${i}_${class_dir}.csv ]; then
	    touch ${i}_${class_dir}.csv
	fi
    fi
done
