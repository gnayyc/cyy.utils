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

export T0_DIR=/Volumes/Data/ants_templates/ADNI
export T_DIR=/Volumes/Ramdisk/data/template/ADNI
if [[ ! -d $T_DIR ]];
  then
    echo "The template directory \"$T_DIR\" does not exist. Making it."
    mkdir -p $T_DIR
    cp -Rp $T0_DIR/* $T_DIR 
  fi
export T_T1=${T_DIR}/T_template0.nii.gz
export T_MASK=${T_DIR}/T_template0_BrainCerebellumExtractionMask.nii.gz
export T_PROB=${T_DIR}/T_template0_BrainCerebellumProbabilityMask.nii.gz
export T_T1BRAIN=${T_DIR}/T_template0_BrainCerebellum.nii.gz
export T_PRIORS_DIR=${T_DIR}/Priors

T_DEPENDENCIES=( $T_T1 $T_MASK $T_PROB $T_T1BRAIN $T_PRIORS_DIR )

for D in ${T_DEPENDENCIES[@]};
  do
    if [[ ! -s ${D} ]];
      then
        echo "Error:  we can't find the $D template"
        exit
      fi
  done

export FROM_DIR=${1}
export TO_DIR=${2}

echo "FROM_DIR=${FROM_DIR}"
echo "TO_DIR=${TO_DIR}"

echo paralleling...
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10
find ${FROM_DIR} -d 2 | \
    awk -F"/" '{print $(NF-1) " " $(NF)}' | \
    parallel --will-cite -j2 --linebuffer --colsep ' ' battery.sh {1} {2} # {SUBJ} {TIME}

