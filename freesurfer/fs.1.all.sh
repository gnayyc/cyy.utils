#!/bin/sh


function Usage {
    cat <<USAGE

Usage:

`basename $0` input_repo_directory output_repo_directory

Examples:

    `basename $0` ./input ./output
    while ./input contains 
	./subject/timepoint/MRI/*.nii.gz
    ./output will be result subjects directory of FreeSurfer

USAGE
    exit 0
}

# parse command line
if [ $# -ne 2 ]; then #  must be two
    Usage >&2
fi

export FROM_DIR=`realpath ${1}`
export SD=`realpath ${2}`

function logCmd() {
  cmd="$*"
  echo "BEGIN >>>>>>>>>>>>>>>>>>>>"
  echo $cmd
  #$cmd

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


echo paralleling...

if [ ! -d ${SD} ]; then
    mkdir -p ${SD}
fi

#find ${1} -name "*3D*" |grep -v C.nii.gz| grep -v TOF |grep -v 3DC | grep -v 3D_C|wc
#recon-all -sd ${2} -sid $SID -all
#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10
find ${FROM_DIR} -name "*3D*.nii.gz" | \
    grep -v C.nii.gz| grep -v TOF |grep -v 3DC | grep -v 3D_C | grep -v C_ | \
    parallel --will-cite -j10 --linebuffer --colsep ' ' \
	fs.sh {1} ${SD}

#recon-all -base <templateid> -tp <tp1id> -tp <tp2id> ... -all
