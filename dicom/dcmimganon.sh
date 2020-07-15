#!/bin/sh

# dcmimganon.sh orig.dcm deid_img.dcm [tmp_dir]
# ${1} ${2}

if [ -f ${1} ]; then
    fname=`basename ${1}`
    if [ -d ${2} ]; then
	tofile=${2}/$fname
    else
	tofile=${2}
    fi

    if [ -d "${3}" ]; then
	TMPDIR=${3}
	#echo "TMPDIR=$TMPDIR (3)"
    elif [ -d "/Volumes/RamDisk" ]; then
	TMPDIR="/Volumes/RamDisk"
	#echo TMPDIR=$TMPDIR
    elif [ -d "${2}" ]; then
	mkdir -p ${2}/tmp
	TMPDIR=${2}/tmp
	#echo TMPDIR=$TMPDIR
    else
	mkdir -p `dirname ${2}`/tmp
	TMPDIR=`dirname ${2}`/tmp
	#echo TMPDIR=$TMPDIR
    fi
    tmp=${TMPDIR}/${fname}

    gdcmimg --fill 0 --region 0,600,0,80 -i $1 -o $tmp
    ymax=`dcminfo -tag 0028 0011 $tmp|sed 's/\[0028,0011\] //'|sed 's/ //'`
    gdcmimg --fill 0 --region $((ymax-600)),${ymax},0,80 -i $tmp -o $tofile
    rm -f $tmp
fi

