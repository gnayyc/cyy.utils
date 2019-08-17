#!/bin/sh

#for c in pneumonia consolidation infiltration; do
#for c in pneumonia consolidation; do
for c in consolidation; do
    echo ${c}:
    for f in stage_1_test_images_png/*.png; do
	if [ -f ${f}_${c}.csv ]; then
	    echo "-" ${f}_$c already done
	else
	    echo "+" ${f}_${c}
	    find $c -type f -name "*.png" |\
	    awk -v label=$c -v f=$f '{print f, $(0), label }' |\
	    parallel --will-cite -j10 --linebuffer --colsep ' ' ./compare.sh {1} {2} {3}
	    if [ ! -f ${f}_${c}.csv ]; then
		touch ${f}_${c}.csv
	    fi
	fi
    done
done
