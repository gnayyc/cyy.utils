#!/bin/bash

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

SUBJECTID="${1}_${2}"
SUBJECTBOLDDIR="${O_DIR}/BOLD"
SUBJECTDTIDIR="${O_DIR}/DTI"
SUBJECTPCASLDIR="${O_DIR}/PCASL"
SUBJECTT1DIR="${O_DIR}"
TEMPLATEDIR=${ANTS_TDIR}

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${ANTS_AAL} \
-r ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz m \
${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz \
${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz
echo "      Labeling T1 for ${O_DIR} done"

${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz m \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${ANTS_AAL} \
-r ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz \
-t [ ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
-t ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz m \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz
echo "      Labeling BOLD for ${O_DIR} done"

antsApplyTransforms -d 3 \
-i ${ANTS_AAL} \
-r ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz \
-t [ ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
-t ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz m \
${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz \
${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz
echo "      Labeling DTI for ${O_DIR} done"

antsApplyTransforms -d 3 \
-i ${ANTS_AAL} \
-r ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz \
-t [ ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
-t ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz m \
${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz \
${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz
echo "      Labeling PCASL for ${O_DIR} done"
