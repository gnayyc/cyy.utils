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
. `which battery.rc.sh`

export FROM_DIR=${1}
export TO_DIR=${2}

echo "FROM_DIR=${FROM_DIR}"
echo "TO_DIR=${TO_DIR}"

echo paralleling...
#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10
find ${FROM_DIR} -d 2 | \
    awk -F"/" '{print $(NF-1) " " $(NF)}' | \
    parallel --will-cite -j2 --linebuffer --colsep ' ' battery.sh ${FROM_DIR} ${TO_DIR} {1} {2} # {SUBJ} {TIME}

