#!/usr/bin/env sh

function Usage {
    cat <<USAGE

Usage:

`basename $0` input_repo_directory 

Examples:

    `basename $0` ./input ./output
    while ./input contains 
	./subject/timepoint/MRI/*DTI_*.nii.gz

USAGE
    exit 0
}

# parse command line
if [ $# -ne 2 ]; then #  must be two
    Usage >&2
fi

CWD=`pwd`

. `which battery.rc.sh`

export FROM_DIR=`realpath ${1}`
export GROUP=`basename ${1}`
T0_DIR=~/mnt/Data/Brain.MRI.templates/ADNI


T_DIR=`realpath ${TO_DIR}/T/template0`
echo "FROM_DIR=${FROM_DIR}"
echo "T_DIR=${T_DIR}"

mkdir -p ${T_DIR}/build
mkdir -p ${T_DIR}/MRI
mkdir -p ${T_DIR}/Priors


echo "Linking T1 images..."
find `realpath ${FROM_DIR}` -d 4 -name \*T1\*.nii.gz | \
    grep -v T/template0 | \
    parallel --will-cite -j1 --linebuffer --colsep ' ' ln -sf "{1}" ${T_DIR}/build

if [ ! -f "${T_DIR}/build/T_template0.nii.gz" ]; then
    cd ${T_DIR}/build
    antsMultivariateTemplateConstruction.sh -d 3 -m 30x50x20 -t GR -s CC -c 2 -j 10 -i 10 -b 1 -o T_ *T1*.nii.gz 
    cd ${CWD}
fi

if [ ! -f "${T_DIR}/T_template0.nii.gz" ]; then
    cd "${CWD}"
    cp "${T_DIR}/build/T_template0.nii.gz" "${T_DIR}/MRI/T_template0_T1.nii.gz"
    cp "${T_DIR}/build/T_template0.nii.gz" "${T_DIR}"
    cd "${CWD}"
fi

if [ ! -f "${T_DIR}/Priors/priors6.nii.gz" ]; then
    cd "${CWD}"
    echo "ANTS CT: ${TO_DIR}"
    env T0_DIR=${T0_DIR} ~/bin/ants/battery.t1.sh ${TO_DIR} ${TO_DIR} T template0
    cd ${T_DIR}
    #ln -sf T_template0_N4Corrected0.nii.gz T_template0.nii.gz
    #ln -sf T_template0_BrainExtractionBrain.nii.gz T_template0_BrainCerebellum.nii.gz
    #ln -sf T_template0_BrainExtractionMask.nii.gz T_template0_BrainCerebellumExtractionMask.nii.gz
    echo SmoothImage 3 T_template0_BrainExtractionMask.nii.gz 1.0 T_template0_BrainProbabilityMask.nii.gz
    SmoothImage 3 T_template0_BrainExtractionMask.nii.gz 1.0 T_template0_BrainProbabilityMask.nii.gz
    cd "${CWD}"
    
    cd "${CWD}"
    mkdir -p ${T_DIR}/Priors
    echo cd ${T_DIR}/Priors
    cd ${T_DIR}/Priors
    for i in 1 2 3 4 5 6; do
	echo "ln -sf ../*_BrainSegmentationPosteriors${i}.nii.gz priors${i}.nii.gz"
	ln -sf ../*_BrainSegmentationPosteriors${i}.nii.gz priors${i}.nii.gz
    done
    cd "${CWD}"
fi

echo "Template built! Please check the result by eyes!"
echo 

