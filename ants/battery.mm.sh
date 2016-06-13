#!/usr/bin/env sh

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

if [ ! -f "$I_DIR/DTI/${SID}_DTI_rgb.nii.gz" ]; then
    echo sh ${PIPEDREAMPATH}/nii2dt/nii2dt.sh \
	--dwi ${I_DIR}/MRI/${SID}_*_Tensor*.nii.gz \
	--bvals ${I_DIR}/MRI/${SID}_*_Tensor*.bval \
	--bvecs ${I_DIR}/MRI/${SID}_*_Tensor*.bvec \
	--outroot ${SID}_DTI_ \
	--outdir ${I_DIR}/DTI
    sh ${PIPEDREAMPATH}/nii2dt/nii2dt.sh \
	--dwi ${I_DIR}/MRI/${SID}_*_Tensor*.nii.gz \
	--bvals ${I_DIR}/MRI/${SID}_*_Tensor*.bval \
	--bvecs ${I_DIR}/MRI/${SID}_*_Tensor*.bvec \
	--outroot ${SID}_DTI_ \
	--outdir ${I_DIR}/DTI
else
    echo "      DTI ($I_DIR/DTI) reconstructed"
fi

if [ -f "${O_DIR}/DTI/${SID}_DTI_rd_template.nii.gz" ]; then
    echo "      antsNeuroimagingBattery for ${O_DIR} done"
else
    echo ${ANTSPATH}/antsNeuroimagingBattery \
	--input-directory ${I_DIR} \
	--output-directory ${O_DIR}\
	--output-name ${SID}_ \
	--anatomical ${O_DIR}/${SID}_BrainExtractionBrain.nii.gz \
	--anatomical-mask ${O_DIR}/${SID}_BrainExtractionMask.nii.gz \
	--template ${T_T1} \
	--dti-flag DTI/dt.nii.gz/DTI_ \
	--template-transform-name ${SID}_SubjectToTemplate
    ${ANTSPATH}/antsNeuroimagingBattery \
	--input-directory ${I_DIR} \
	--output-directory ${O_DIR}\
	--output-name ${SID}_ \
	--anatomical ${O_DIR}/${SID}_BrainExtractionBrain.nii.gz \
	--anatomical-mask ${O_DIR}/${SID}_BrainExtractionMask.nii.gz \
	--template ${T_T1} \
	--dti-flag DTI/dt.nii.gz/DTI_ \
	--rsbold-flag MRI/rsfMRI_3x3x3.nii.gz/BOLD_ 
	# --pcasl-flag PCASL/pcasl_1.nii.gz/PCASL_ 
	--template-transform-name ${SID}_SubjectToTemplate
fi

