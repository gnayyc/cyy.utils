#!/usr/bin/env sh

. `which battery.rc.sh`

FROM_DIR=${1}
SID="${2}_${3}"
S_DIR="${2}/${3}"
I_DIR="$FROM_DIR/$S_DIR"

echo FROM_DIR=$FROM_DIR
echo SID=$SID
echo S_DIR=$S_DIR
echo I_DIR=$I_DIR
echo 

if [ ! -f "$I_DIR/DTI/${SID}_DTI_rgb.nii.gz" ]; then
    echo sh ${PIPEDREAMPATH}/nii2dt/nii2dt.sh \
	--dwi ${I_DIR}/MRI/${SID}_*_DTI*.nii.gz \
	--bvals ${I_DIR}/MRI/${SID}_*_DTI*.bval \
	--bvecs ${I_DIR}/MRI/${SID}_*_DTI*.bvec \
	--outroot ${SID}_DTI_ \
	--outdir ${I_DIR}/DTI
    sh ${PIPEDREAMPATH}/nii2dt/nii2dt.sh \
	--dwi ${I_DIR}/MRI/${SID}_*_DTI*.nii.gz \
	--bvals ${I_DIR}/MRI/${SID}_*_DTI*.bval \
	--bvecs ${I_DIR}/MRI/${SID}_*_DTI*.bvec \
	--outroot ${SID}_DTI_ \
	--outdir ${I_DIR}/DTI
else
    echo "      DTI ($I_DIR/DTI) reconstructed"
fi

