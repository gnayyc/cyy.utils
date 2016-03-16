#!/usr/bin/env sh

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$TMP_FROM_DIR/$S_DIR"
O_DIR="$TMP_TO_DIR/$S_DIR"

if [ -f "${O_DIR}/${SID}_BrainSegmentationTiledMosaic.png" ]; then
    echo "      antsCorticalThickness.sh for ${O_DIR} done"
else
    if [ -f ${I_DIR}/MRI/${SID}_*3D*.nii.gz ]; then
	T1=${I_DIR}/MRI/${SID}_*3D*.nii.gz
    elif [ -f ${I_DIR}/MRI/${SID}_*mprage*.nii.gz ]; then
	T1=${I_DIR}/MRI/${SID}_*mprage*.nii.gz
    elif [ -f ${I_DIR}/MRI/${SID}_*SPGR*.nii.gz ]; then
	T1=${I_DIR}/MRI/${SID}_*SPGR*.nii.gz
    elif [ -f ${I_DIR}/MRI/${SID}_*T1*.nii.gz ]; then
	T1=${I_DIR}/MRI/${SID}_*T1*.nii.gz
    else
	exit
    fi
    ${ANTSPATH}/antsCorticalThickness.sh -d 3 \
	-a ${T1} \
	-e ${T_T1} \
	-m ${T_PROB} \
	-f ${T_MASK} \
	-p ${T_PRIORS_DIR}/priors%d.nii.gz \
	-t ${T_T1BRAIN} \
	-k 1 \
	-n 3 \
	-w 0.25 \
	-q 1 \
	-o ${O_DIR}/${SID}_ 
fi
