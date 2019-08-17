#!/bin/sh

i1=${1}
i2=${2}
label=${3}


a=`compare -metric rmse $i1 $i2 null: 2>&1 | sed 's/.*(//' | sed 's/).*//'`

if [ $(bc <<< "$a <= 0.05") -eq 1 ]; then 
    if [ ! -f ${i1}_${label}.csv ]; then
	touch ${i1}_${label}.csv
	echo i1,i2,label,rmse >> ${i1}_${label}.csv
    fi
    if [ ! -f ${label}.csv ]; then
	touch ${label}.csv
	echo i1,i2,label,rmse >> ${label}.csv
    fi
    if [ ! -d dup/${label} ]; then
	mkdir -p dup/${label}
    fi
    #echo $i1,$i2,$label,$a 
    echo "[+] \c"
    echo $i1,$i2,$label,$a >> ${label}.csv
    echo $i1,$i2,$label,$a >> ${i1}_${label}.csv
    cp $i1 $i2 dup/${label}
fi

