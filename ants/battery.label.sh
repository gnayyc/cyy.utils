#!/bin/bash

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

SUBJECTID="${1}_${2}"
SUBJECTBOLDDIR="${W_DIR}/BOLD"
SUBJECTDTIDIR="${W_DIR}/DTI"
SUBJECTPCASLDIR="${W_DIR}/PCASL"
SUBJECTT1DIR="${W_DIR}"
TEMPLATEDIR=${T_TDIR}

if [[ ! -s ${T_DKT} ]];
then
    echo "Error:  we can't find the $T_DKT template"
else
    if [[ -s ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat ]];
    then
	${ANTSPATH}/antsApplyTransforms -d 3 \
	    -i ${T_DKT} \
	    -r ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTT1DIR}/${SUBJECTID}_DKT.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}/${SUBJECTID}_DKT.nii.gz m \
	    ${SUBJECTT1DIR}/${SUBJECTID}_DKT.nii.gz \
	    ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz
	echo "      Labeling T1 (DKT) for ${W_DIR} done"
    fi

    if [[ -s ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat ]];
    then
	${ANTSPATH}/antsApplyTransforms -d 3 \
	    -i ${T_DKT} \
	    -r ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz \
	    -t [ ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
	    -t ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_DKT.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_DKT.nii.gz m \
	    ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_DKT.nii.gz \
	    ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz
	echo "      Labeling BOLD (DKT) for ${W_DIR} done"
    fi

    if [[ -s ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat ]];
    then
	antsApplyTransforms -d 3 \
	    -i ${T_DKT} \
	    -r ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz \
	    -t [ ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
	    -t ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_1InverseWarp.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_DKT.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_DKT.nii.gz m \
	    ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_DKT.nii.gz \
	    ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz
	echo "      Labeling DTI (DKT) for ${W_DIR} done"
    fi

    if [[ -s ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat ]];
    then
	antsApplyTransforms -d 3 \
	    -i ${T_DKT} \
	    -r ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz \
	    -t [ ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
	    -t ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_DKT.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_DKT.nii.gz m \
	    ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_DKT.nii.gz \
	    ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz
	echo "      Labeling PCASL (DKT) for ${W_DIR} done"
    fi
fi

if [[ ! -s ${T_AAL} ]];
then
    echo "Error:  we can't find the $T_AAL template"
else
    if [[ -s ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat ]];
    then
	${ANTSPATH}/antsApplyTransforms -d 3 \
	    -i ${T_AAL} \
	    -r ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTT1DIR}/${SUBJECTID}_AAL.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}/${SUBJECTID}_AAL.nii.gz m \
	    ${SUBJECTT1DIR}/${SUBJECTID}_AAL.nii.gz \
	    ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz
	echo "      Labeling T1 (AAL) for ${W_DIR} done"
    fi

    if [[ -s ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat ]];
    then
	${ANTSPATH}/antsApplyTransforms -d 3 \
	    -i ${T_AAL} \
	    -r ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz \
	    -t [ ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
	    -t ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_AAL.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_AAL.nii.gz m \
	    ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_AAL.nii.gz \
	    ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz
	echo "      Labeling BOLD (AAL) for ${W_DIR} done"
    fi

    if [[ -s ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat ]];
    then
	antsApplyTransforms -d 3 \
	    -i ${T_AAL} \
	    -r ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz \
	    -t [ ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
	    -t ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_1InverseWarp.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_AAL.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_AAL.nii.gz m \
	    ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_AAL.nii.gz \
	    ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz
	echo "      Labeling DTI (AAL) for ${W_DIR} done"
    fi

    if [[ -s ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat ]];
    then
	antsApplyTransforms -d 3 \
	    -i ${T_AAL} \
	    -r ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz \
	    -t [ ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
	    -t ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
	    -t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
	    -o ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_AAL.nii.gz -n MultiLabel

	${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_AAL.nii.gz m \
	    ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_AAL.nii.gz \
	    ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz
	echo "      Labeling PCASL (AAL) for ${W_DIR} done"
    fi
fi

