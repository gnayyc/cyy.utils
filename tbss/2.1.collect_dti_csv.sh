#!/bin/sh

## 1. After dtifit by tractor (1.dpreproc_all.sh)
##	s1/tractor/fdt
##	s2/tractor/fdt
##	s3/tractor/fdt
## 2. cd the directory
## 3. create csv file like this
##    s1,group1
##    s1,group1
##    s1,group2
##    s2,group3
##    s2,group4
## 3. execute this script and enter group tag
##	this script will cp and rename dti files of each subjects into the tag.FDT dir
##	the tag.FDT directory can be used for tbss.py

ROOT="`pwd`"
GROUP_DIR="work"
export IFS=","
#cat $1 | while read subj tag; do mkdir -p $GROUP_DIR/$tag/$subj; cp -Rp $subj/tractor $GROUP_DIR/$tag/$subj; done
cat $1 | 
    while read subj tag; 
    do 
	mkdir -p $ROOT/$GROUP_DIR/$tag/$subj; 
	#cp -Rp $subj/tractor $GROUP_DIR/$tag/$subj; 
	ln -s ../../../$subj/tractor $ROOT/$GROUP_DIR/$tag/$subj; 
    done

echo cd $ROOT/$GROUP_DIR
cd $ROOT/$GROUP_DIR
#mkdir -p tbss
for tag in * ; do
    echo "Tag: $tag"
    if [ -d "$ROOT/$GROUP_DIR/${tag}" ]; then 
	FDT="$ROOT/$GROUP_DIR/tbss/${tag}.FDT"
	mkdir -p $FDT
	echo "FDT: $FDT"

	echo cd $ROOT/$GROUP_DIR/$tag
	cd $ROOT/$GROUP_DIR/$tag
	for S in *; do
	    #if [ -d "${S}" ]; then # now use sym link, so don't check this
		fdt="$ROOT/$GROUP_DIR/$tag/$S/tractor/fdt"
		echo fdt=$fdt
		if [ -d "${fdt}" ]; then
		    for f in ${fdt}/dti*.nii.gz; do
			f1=`basename $f`
			echo "ln -s $f $FDT/${tag}_${S}_${f1}"
			eval "ln -s $f $FDT/${tag}_${S}_${f1}"
		    done
		fi
		echo "$S done:"
		#ls $FDT
		echo "----------=============== $S ===============----------"
		echo
		cd "$__pwd"
	    #fi 
	done
    fi
done
