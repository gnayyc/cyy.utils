#!/bin/bash

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$TMP_FROM_DIR/$S_DIR"
O_DIR="$TMP_TO_DIR/$S_DIR"

SUBJECTID="${1}_${2}"
SUBJECTBOLDDIR="${O_DIR}/BOLD"
SUBJECTDTIDIR="${O_DIR}/DTI"
SUBJECTPCASLDIR="${O_DIR}/PCASL"
SUBJECTT1DIR="${O_DIR}"
TEMPLATEDIR=${T_TDIR}

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${T_DKT} \
-r ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz m \
${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz \
${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz
echo "      Labeling T1 (DKT) for ${O_DIR} done"

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${T_DKT} \
-r ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz \
-t [ ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
-t ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz m \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz
echo "      Labeling BOLD (DKT) for ${O_DIR} done"

antsApplyTransforms -d 3 \
-i ${T_DKT} \
-r ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz \
-t [ ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
-t ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz m \
${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz \
${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz
echo "      Labeling DTI (DKT) for ${O_DIR} done"

antsApplyTransforms -d 3 \
-i ${T_DKT} \
-r ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz \
-t [ ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
-t ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz m \
${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz \
${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz
echo "      Labeling PCASL (DKT) for ${O_DIR} done"



${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${T_AAL} \
-r ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz m \
${SUBJECTT1DIR}/${SUBJECTID}_aal.nii.gz \
${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz
echo "      Labeling T1 (AAL) for ${O_DIR} done"

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${T_AAL} \
-r ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz \
-t [ ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
-t ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz m \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_aal.nii.gz \
${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz
echo "      Labeling BOLD (AAL) for ${O_DIR} done"

antsApplyTransforms -d 3 \
-i ${T_AAL} \
-r ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz \
-t [ ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
-t ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz m \
${SUBJECTDTIDIR}/${SUBJECTID}_DTI_aal.nii.gz \
${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz
echo "      Labeling DTI (AAL) for ${O_DIR} done"

antsApplyTransforms -d 3 \
-i ${T_AAL} \
-r ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz \
-t [ ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
-t ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz -n MultiLabel

${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz m \
${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_aal.nii.gz \
${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz
echo "      Labeling PCASL (AAL) for ${O_DIR} done"

