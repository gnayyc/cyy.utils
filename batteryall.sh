#!/usr/bin/env sh

function Usage {
    cat <<USAGE

Usage:

`basename $0` input_repo_directory output_repo_directory

Examples:

    `basename $0` ./input ./output
    while ./input contains 
	./subject/timepoint/MRI/*.nii.gz

USAGE
    exit 0
}

# parse command line
if [ $# -ne 2 ]; then #  must be two
    Usage >&2
fi

#export T_DIR=/Users/cyyang/work/ants_templates/MICCAI2012-Multi-Atlas-Challenge-Data

export T_DIR=/Volumes/Ramdisk/data/template/OASIS
export T_T1=${ANTS_TDIR}/T_template0.nii.gz
export T_PROB=${ANTS_TDIR}/T_template0_BrainCerebellumProbabilityMask.nii.gz
export T_MASK=${ANTS_TDIR}/T_template0_BrainCerebellumExtractionMask.nii.gz
export T_T1BRAIN=${ANTS_TDIR}/T_template0_BrainCerebellum.nii.gz
export T_AAL=${ANTS_TDIR}/Labels/T_template0_AAL.nii.gz
export T_DKT=${ANTS_TDIR}/Labels/T_template0_DKT.nii.gz
export T_PRIORS_DIR=${ANTS_TDIR}/Priors

export FROM_DIR=${1}
export TO_DIR=${2}

echo "FROM_DIR=${FROM_DIR}"
echo "TO_DIR=${TO_DIR}"

echo paralleling...
find ${FROM_DIR} -d 2 | \
    awk -F"/" '{print $(NF-1) " " $(NF)}' | \
    parallel --will-cite -j6 --linebuffer --colsep ' ' battery.sh {1} {2}

