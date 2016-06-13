#!/bin/bash

. `which battery.rc.sh`

FROM_DIR=${1}
TO_DIR=${2}
SID="${3}_${4}"
S_DIR="${3}/${4}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

echo FROM_DIR=$FROM_DIR
echo TO_DIR=$TO_DIR
echo SID=$SID
echo S_DIR=$S_DIR
echo I_DIR=$I_DIR
echo O_DIR=$O_DIR
echo 

SUBJECTID=$SID
SUBJECTBOLDDIR="${O_DIR}/BOLD"
SUBJECTDTIDIR="${O_DIR}/DTI"
SUBJECTPCASLDIR="${O_DIR}/PCASL"
SUBJECTT1DIR="${O_DIR}"
TEMPLATEDIR=${T_TDIR}

LABELS=( 'DKT' 'AAL' 'MalfLabeling' )

for L in ${LABELS[@]};
do
    T_LABEL="${T_DIR}/T_template0_${L}.nii.gz"
    if [[ ! -s ${T_LABEL} ]];
    then
	echo "Error:  we can't find the ${L} template"
    else
	if [[ -s ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat ]];
	then
	    ${ANTSPATH}/antsApplyTransforms -d 3 \
		-i ${T_LABEL} \
		-r ${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
		-o ${SUBJECTT1DIR}/${SUBJECTID}_${L}.nii.gz -n MultiLabel

	    ${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}/${SUBJECTID}_${L}.nii.gz m \
		${SUBJECTT1DIR}/${SUBJECTID}_${L}.nii.gz \
		${SUBJECTT1DIR}/${SUBJECTID}_BrainExtractionMask.nii.gz
	    echo "      Labeling T1 (${L}) for ${W_DIR} done"
	fi

	if [[ -s ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat ]];
	then
	    ${ANTSPATH}/antsApplyTransforms -d 3 \
		-i ${T_LABEL} \
		-r ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz \
		-t [ ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
		-t ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
		-o ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_${L}.nii.gz -n MultiLabel

	    ${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_${L}.nii.gz m \
		${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_${L}.nii.gz \
		${SUBJECTBOLDDIR}/${SUBJECTID}_BOLD_brainmask.nii.gz
	    echo "      Labeling BOLD (${L}) for ${W_DIR} done"
	fi

	if [[ -s ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat ]];
	then
	    antsApplyTransforms -d 3 \
		-i ${T_LABEL} \
		-r ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz \
		-t [ ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
		-t ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_1InverseWarp.nii.gz \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
		-o ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_${L}.nii.gz -n MultiLabel

	    ${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}/${SUBJECTID}_DTI_${L}.nii.gz m \
		${SUBJECTDTIDIR}/${SUBJECTID}_DTI_${L}.nii.gz \
		${SUBJECTDTIDIR}/${SUBJECTID}_DTI_brainmask.nii.gz
	    echo "      Labeling DTI (${L}) for ${W_DIR} done"
	fi

	if [[ -s ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat ]];
	then
	    antsApplyTransforms -d 3 \
		-i ${T_LABEL} \
		-r ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz \
		-t [ ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
		-t ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
		-t ${SUBJECTT1DIR}/${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
		-o ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_${L}.nii.gz -n MultiLabel

	    ${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_${L}.nii.gz m \
		${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_${L}.nii.gz \
		${SUBJECTPCASLDIR}/${SUBJECTID}_PCASL_brainmask.nii.gz
	    echo "      Labeling PCASL (${L}) for ${W_DIR} done"
	fi
    fi
done

