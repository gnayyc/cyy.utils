#!/bin/sh

function Usage {
    cat <<USAGE

`basename $0` performs registration of two hands

Usage:

`basename $0` [-k] fixed_hand moving_hand

USAGE
    exit 1
}

KEEP_TMP_IMAGES=0

if [[ $# -lt 1 ]] ; then
  Usage >&2
  exit 1
else
  while getopts "k:" OPT
    do
      case $OPT in
          k) # keep images
	      KEEP_TMP_IMAGES=1
	      shift
              ;;
          *) # getopts issues an error message
              echo "ERROR:  unrecognized option -$OPT $OPTARG"
              exit 1
              ;;
      esac
  done
fi

SID1=${1%.*}
SID2=${2%.*}
IDIR1=${SID1}.output
IDIR2=${SID2}.output
IPRE1=${IDIR1}/${SID1}
IPRE2=${IDIR2}/${SID2}

SID=${SID1}_${SID2}
ODIR=${SID1}_${SID2}.output
OUTPUT_PREFIX=${ODIR}/${SID}

hand1=${IPRE1}_hand.png
hand2=${IPRE2}_hand.png
redhand1=${IPRE1}_hand_RGB0.png
greenhand1=${IPRE1}_hand_RGB1.png
bluehand1=${IPRE1}_hand_RGB2.png
yellowhand1=${IPRE1}_hand_RGB3.png
redhand2=${IPRE2}_hand_RGB0.png
greenhand2=${IPRE2}_hand_RGB1.png
bluehand2=${IPRE2}_hand_RGB2.png
yellowhand2=${IPRE2}_hand_RGB3.png

redhand2png=${OUTPUT_PREFIX}_Warped_RGB0.png
greenhand2png=${OUTPUT_PREFIX}_Warped_RGB1.png
bluehand2png=${OUTPUT_PREFIX}_Warped_RGB2.png
yellowhand2png=${OUTPUT_PREFIX}_Warped_RGB3.png
redhand2nii=${OUTPUT_PREFIX}_Warped_RGB0.nii.gz
greenhand2nii=${OUTPUT_PREFIX}_Warped_RGB1.nii.gz
bluehand2nii=${OUTPUT_PREFIX}_Warped_RGB2.nii.gz
yellowhand2nii=${OUTPUT_PREFIX}_Warped_RGB3.nii.gz

# Echos a command to both stdout and stderr, then runs it
function logCmd() {
  cmd="$*"
  echo "BEGIN >>>>>>>>>>>>>>>>>>>>"
  echo $cmd
  $cmd
  echo "END   <<<<<<<<<<<<<<<<<<<<"
  echo
  echo
}

if [[ ! -d ${ODIR} ]]; then
    echo ${ODIR} not exists. Making it!
    mkdir -p ${ODIR}
    if [[ ! -d ${ODIR} ]]; then
	echo mkdir ${ODIR} failed! Exiting!
	exit
    fi
fi

# extract hands
logCmd ehand.sh $1
logCmd ehand.sh $2

if [[ ! -f ${OUTPUT_PREFIX}1Warp.nii.gz ]]; then
    logCmd antsRegistrationSyNQuick.sh -d 2 -t bo -s 15 -f $hand1 -m $hand2 -o ${OUTPUT_PREFIX} -n 10
fi
if [[ ! -f ${SID}.png ]]; then
    logCmd antsApplyTransforms -d 2 -i $redhand2 -o $redhand2nii -r $1 \
	-t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
    logCmd antsApplyTransforms -d 2 -i $greenhand2 -o $greenhand2nii -r $1 \
	-t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
    logCmd antsApplyTransforms -d 2 -i $bluehand2 -o $bluehand2nii -r $1 \
	-t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat

    logCmd ConvertImagePixelType $redhand2nii $redhand2png 1
    logCmd ConvertImagePixelType $greenhand2nii $greenhand2png 1
    logCmd ConvertImagePixelType $bluehand2nii $bluehand2png 1
    logCmd ConvertImagePixelType $yellowhand2nii $yellowhand2png 1

    logCmd convert $redhand2png $greenhand2png $bluehand2png -combine ${SID}.png

    logCmd ConvertImagePixelType ${OUTPUT_PREFIX}Warped.nii.gz ${SID}_gray.png 1
fi
if [ $KEEP_TMP_IMAGES -eq "0" ]; then
    echo
    #logCmd rm -f ${OUTPUT_PREFIX}*.nii.gz ${OUTPUT_PREFIX}*.mat
fi

#logCmd rm -f $r1_png $g1_png $b1_png

#antsMultivariateTemplateConstruction2.sh -d 2 -n 0 -i 4 -r 1 -y 0 -l 0 -o handmask -c 2 -j 10 ?.png
