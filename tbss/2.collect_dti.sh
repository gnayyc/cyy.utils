#!/bin/sh

## 1. After dtifit by tractor (1.dpreproc_all.sh)
##    Collect subjects of same group in a directory
##	s1/tractor/fdt
##	s2/tractor/fdt
##	s3/tractor/fdt
## 2. cd the directory
## 3. execute this script and enter group tag
##	this script will cp and rename dti files of each subjects into the tag.FDT dir
##	the tag.FDT directory can be used for tbss.py

echo "Input group tag:";

read inputline
tag="$inputline"

if [ -z "${tag}" ];
then
    echo "tag needed!"
    exit
fi


__pwd="`pwd`"

FDT="$__pwd/${tag}.FDT"
mkdir -p $FDT

for S in *; do
    if [ -d "${S}" ]; then
	fdt="$__pwd/$S/tractor/fdt"
	echo fdt=$fdt
	if [ -d "${fdt}" ]; then
	    for f in ${fdt}/dti*.nii.gz; do
		f1=`basename $f`
		echo "cp $f $FDT/${tag}_${S}_${f1}"
		eval "cp $f $FDT/${tag}_${S}_${f1}"
	    done
	fi
	echo "$S done:"
	ls $FDT
	echo "----------=============== $S ===============----------"
	echo
	cd "$__pwd"
    fi 
done
