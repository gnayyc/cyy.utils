#!/bin/sh

#

function Usage {
    cat <<USAGE

`basename $0` performs extraction of hands and remove green background

Usage:

`basename $0` [-k] handimage

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

ODIR=${1%.*}.output
SID=${1%.*}
OPRE=${ODIR}/${SID}
nii=${OPRE}.nii.gz
hand=${OPRE}_hand.png
red=${OPRE}_RGB0.png
green=${OPRE}_RGB1.png
blue=${OPRE}_RGB2.png
yellow=${OPRE}_RGB3.png
redhand=${OPRE}_hand_RGB0.png
greenhand=${OPRE}_hand_RGB1.png
bluehand=${OPRE}_hand_RGB2.png
yellowhand=${OPRE}_hand_RGB3.png
blue_=${OPRE}_RGB2-.png
#r_g=${OPRE}_r-g.png
r_g=${OPRE}_r-g.nii.gz
maskrg=${OPRE}_mask.r-g.nii.gz
mask=${OPRE}_mask.nii.gz
maskpng=${OPRE}_mask.png

tmps=( ${nii} ${red} ${green} ${r_g} ${maskrg} ${mask} )

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

    # get each RGB channel
    if [[ ! -f ${blue} ]]; then
	logCmd convert $1 -separate ${OPRE}_RGB%d.png
	logCmd convert $blue -negate $yellow
    fi
    # get R-G image
    r_g=${OPRE}_r-g.nii.gz
    if [[ ! -f ${r_g} ]]; then
#	logCmd convert $1 \
#	    -channel R -evaluate multiply 1 \
#	    -channel G -evaluate multiply -1 \
#	    -channel B -evaluate multiply 0 \
#	    +channel -separate -compose add -flatten $r_g
	# imagemath works better
	logCmd ImageMath 2 $r_g - $red $green
    fi

    if [[ ! -f ${maskpng} ]]; then
	# Using kmeans to get threshold from R-G image
	logCmd ThresholdImage 2 $r_g $maskrg Kmeans 1
	# Convert value 2 to 1
	logCmd ThresholdImage 2 $maskrg $mask 2 2 1 0
	# Get largest component (hand)
	logCmd ImageMath 2 $mask GetLargestComponent $mask
	# convert mask from nii to png
	logCmd ConvertImagePixelType $mask $maskpng 1
    fi
    if [[ ! -f ${hand} ]]; then
	# extract hand from mask and fill bg with black
	logCmd convert $1 $maskpng -alpha Off -compose CopyOpacity -composite $hand
	logCmd convert $red $maskpng -alpha Off -compose CopyOpacity -composite $redhand
	logCmd convert $green $maskpng -alpha Off -compose CopyOpacity -composite $greenhand
	logCmd convert $blue $maskpng -alpha Off -compose CopyOpacity -composite $bluehand
	logCmd convert $yellow $maskpng -alpha Off -compose CopyOpacity -composite $yellowhand

	logCmd convert $hand -flatten -fuzz 0% -fill black -opaque white $hand
	logCmd convert $redhand -flatten -fuzz 0% -fill black -opaque white $redhand
	logCmd convert $greenhand -flatten -fuzz 0% -fill black -opaque white $greenhand
	logCmd convert $bluehand -flatten -fuzz 0% -fill black -opaque white $bluehand
	logCmd convert $yellowhand -flatten -fuzz 0% -fill black -opaque white $yellowhand

    fi

#    if [ $KEEP_TMP_IMAGES -eq "0" ]; then
#	#logCmd rm -f ${nii} ${red} ${green} ${blue} ${r_g} ${maskrg} ${mask}
#	logCmd rm -f ${ODIR}/*.nii.gz
#    fi
