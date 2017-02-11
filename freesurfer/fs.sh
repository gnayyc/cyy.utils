#!/bin/sh

function Usage {
    cat <<USAGE

Usage:

`basename $0` INPUT_FILE FS_SUBJ_DIR 

Examples:

    `basename $0` ./input/012345/20160610/mri/3D_T1.nii.gz ./fs.output

USAGE
    exit 0
}

# parse command line
if [ $# -ne 2 ]; then #  must be two
    Usage >&2
fi

function logCmd() {
  cmd="$*"
  echo "BEGIN >>>>>>>>>>>>>>>>>>>>"
  echo $cmd
  $cmd

  cmdExit=$?

  if [[ $cmdExit -gt 0 ]];
    then
      echo "ERROR: command exited with nonzero status $cmdExit"
      echo "Command: $cmd"
      echo
      if [[ ! $DEBUG_MODE -gt 0 ]];
        then
          exit 1
        fi
    fi

  echo "END   <<<<<<<<<<<<<<<<<<<<"
  echo
  echo

  return $cmdExit
}

IF=`realpath $1`
SD=`realpath $2`
IN=`basename $IF`


if [ ! -d ${SD} ]; then
    mkdir -p ${SD}
fi

if [[ -f "$IF" ]]; then
    SID=`basename ${IF} | awk -F"_" '{print $1 "_" $2 }'` 
    if [[ -f ${SD}/${SID}/mri/rawavg.mgz ]]; then
	#logCmd recon-all -all -sd ${SD} -s ${SID}
	echo ${SD} exists! Skipped!
    else 
	logCmd recon-all -all -sd ${SD} -s ${SID} -i ${IF} #-parallel -openmp 5
    fi
else
    echo $IF does not exist!!
fi

