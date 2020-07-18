#!/bin/sh

function Usage {
    cat <<USAGE

Usage:

`basename $0` dixon_liver_3echo.nii.gz

Examples:

    `basename $0` dixon_liver.nii.gz
    will process dixon_liver.nii.gz in the current directory
    will output
	dixon_liver_fat_fraction.nii.gz
	dixon_liver_fat_fraction_thr.nii.gz

USAGE
    exit 0
}

function logCmd() {
  cmd="$*"
  echo $cmd
  $cmd
}

# parse command line
if [ $# -ne 1 ]; then #  must be one
    Usage >&2
fi

export base=${1%.nii.gz}
export f1=${base}0000.nii.gz
export f2=${base}0001.nii.gz
export f3=${base}0002.nii.gz
export f2_adj=${base}0001_adj.nii.gz
export ip=${base}_ip.nii.gz
export op=${base}_op.nii.gz
export water=${base}_water.nii.gz
export fat=${base}_fat.nii.gz
export fat_fraction=${base}_fat_fraction_thr.nii.gz
export fat_fraction_thr=${base}_fat_fraction_thr.nii.gz

fslsplit "${1}" "${1%.nii.gz}"
fslmaths "${f1}" -mul "${f3}" -sqrt "${f2_adj}"
fslmaths "${f2_adj}" -add "${f2}" -div 2 ${water}
fslmaths "${f2_adj}" -sub "${f2}" -abs -div 2 ${fat}
fslmaths "${water}" -add "${fat}" ${ip}
fslmaths "${water}" -sub "${fat}" ${op}
fslmaths "${fat}" -div "${ip}" -mul 100 "${fat_fraction}"
fslmaths "${fat}" -div "${ip}" -mul 100 -thr 0 -uthr 50 "${fat_fraction_thr}"

