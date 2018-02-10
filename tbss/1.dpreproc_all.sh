#!/bin/sh

__pwd="`pwd`"
T=/usr/local/bin/tractor

touch .process.log
L=".process.log"

#### dir structures
## 0001/T1
## 0001/T2
## 0001/004_Ax_DTI1000
## 0001/007_ep2d_diff_
## 0001/401_Ax_DTI1000
## 0002/T1
## 0002/T2
## 0002/004_Ax_DTI1000
## 0002/401_Ax_DTI1000

for S in *; do
    if [ -d "$__pwd/${S}" ]; then
	echo "----------=============== $S ===============----------"
	echo "----------=============== $S ===============----------" >> $L
	#I=`ls $__pwd/$S|head -1`
	#I=
	#echo I=$I
	#echo ls "$__pwd/$S/$I"
	#D=`ls "$__pwd/$S/$I"|grep DTI|head -1`
	D=`ls "$__pwd/$S"|grep DTI|head -1`
	if [ -z "${D}" ]; then
	    #D=`ls "$__pwd/$S/$I"|grep diff|head -1`
	    #D=`ls "$__pwd/$S"|grep diff|head -1`
	    #D=`ls "$__pwd/$S"|grep OPTICNERVE_20D_ORIG|head -1`
	    D=`ls "$__pwd/$S"|grep Tensor|head -1`
	    if [ -z "${D}" ]; then
		echo "No DTI images found" 
		echo "No DTI images found" >> $L
		continue
	    fi
	fi
	#echo D=$D
	DTI="$__pwd/$S/$D"
	echo DTI=$DTI
	echo DTI=$DTI >> $L
	cd "$__pwd/$S"
	#~/bin/dpreproc.sh $DTI
	1.1.dpreproc.sh $DTI
	$T dpreproc Interactive:false DicomDirectory:$DTI
	#$T gradcheck
	$T gradrotate # Only if you previously used RotateGradients:true 
	$T tensorfit Method:fsl
	#$T bedpost
    else
	echo "$S not a directory..."
	echo "$S not a directory..." >> $L
    fi 
done

