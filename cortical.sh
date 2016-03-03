#!/bin/bash

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

bash ${ANTSPATH}/antsCorticalThickness.sh -d 3 \
  -a ${T1} \
  -e ${ANTS_T1} \
  -m ${ANTS_PROB} \
  -p ${ANTS_PRIORS_DIR}/priors%d.nii.gz \
  -o ${O_DIR}/${SID}_ 

