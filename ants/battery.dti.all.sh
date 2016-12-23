#!/usr/bin/env sh

function Usage {
    cat <<USAGE

Usage:

`basename $0` input_repo_directory 

Examples:

    `basename $0` ./input 
    while ./input contains 
	./subject/timepoint/MRI/*DTI_*.nii.gz

USAGE
    exit 0
}

# parse command line
if [ $# -ne 1 ]; then #  must be two
    Usage >&2
fi

. `which battery.rc.sh`

export FROM_DIR=${1}

echo "FROM_DIR=${FROM_DIR}"

echo paralleling...
#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10
find ${FROM_DIR} -d 2 | \
    awk -F"/" '{print $(NF-1) " " $(NF)}' | \
    parallel --will-cite -j10 --linebuffer --colsep ' ' battery.dti.sh ${FROM_DIR} {1} {2} # {SUBJ} {TIME}

