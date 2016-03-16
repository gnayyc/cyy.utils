#!/usr/bin/env sh

SID="${1}_${2}"
S_DIR="${1}/${2}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

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
	# --rsbold-flag BOLD/bold_fc_1.nii.gz/BOLD_ 
	# --pcasl-flag PCASL/pcasl_1.nii.gz/PCASL_ 
	--template-transform-name ${SID}_SubjectToTemplate
fi

