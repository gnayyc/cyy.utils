#!/usr/bin/env sh

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

${ANTSPATH}/antsJointLabelFusion.sh \
  -d 3 \
  -c 2 -j 4 \ # PEXEC
  -x or \ # all the warped atlas images to defined foreground/background
  -o ${O_DIR}/JLF/${SID}_ \
  -p ${O_DIR}/JLF/${SID}_Posteriors%02d.nii.gz \
  -t ${O_DIR}/JLF/${SID}_JLF_target.nii.gz \ # target image to be labled
  -g ${inputPath}/Atlases/OASIS-TRT-20-10_slice118.nii.gz \ # atlas
  -l ${inputPath}/Labels/OASIS-TRT-20-10_DKT31_CMA_labels_slice118.nii.gz \ # label 
  -g ${inputPath}/Atlases/OASIS-TRT-20-11_slice118.nii.gz \
  -l ${inputPath}/Labels/OASIS-TRT-20-11_DKT31_CMA_labels_slice118.nii.gz \
  -k 1 # Keep warped atlas and label files


