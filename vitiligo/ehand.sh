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
CHULL=0
PAD=1

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
handnii=${OPRE}_hand.nii.gz
hand_chull=${OPRE}_hand_chull.png
red=${OPRE}_RGB0.png
green=${OPRE}_RGB1.png
blue=${OPRE}_RGB2.png
yellow=${OPRE}_RGB3.png
redhand=${OPRE}_hand_RGB0.png
greenhand=${OPRE}_hand_RGB1.png
bluehand=${OPRE}_hand_RGB2.png
yellowhand=${OPRE}_hand_RGB3.png
redhandnii=${OPRE}_hand_RGB0.nii.gz
greenhandnii=${OPRE}_hand_RGB1.nii.gz
bluehandnii=${OPRE}_hand_RGB2.nii.gz
yellowhandnii=${OPRE}_hand_RGB3.nii.gz

redhand_chull=${OPRE}_hand_RGB0_chull.png
greenhand_chull=${OPRE}_hand_RGB1_chull.png
bluehand_chull=${OPRE}_hand_RGB2_chull.png
blue_=${OPRE}_RGB2-.png
#r_g=${OPRE}_r-g.png
r_g=${OPRE}_r-g.nii.gz
maskrg=${OPRE}_mask.r-g.nii.gz
mask=${OPRE}_mask.nii.gz
mask_chull=${OPRE}_mask_chull.nii.gz
mask_sub=${OPRE}_mask_sub.nii.gz
mask_sub255=${OPRE}_mask_sub255.nii.gz
maskpng=${OPRE}_mask.png
maskchullpng=${OPRE}_mask_chull.png

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
    echo Directory "${ODIR}" not exists. Making it!
    logCmd mkdir -p ${ODIR}
    if [[ ! -d ${ODIR} ]]; then
	echo mkdir ${ODIR} failed! Exiting!
	exit 0
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
	logCmd ImageMath 2 $mask ME $mask 2
	logCmd ImageMath 2 $mask GetLargestComponent $mask
	logCmd ImageMath 2 $mask MD $mask 2
	logCmd ImageMath 2 $mask FillHoles $mask 2
	logCmd ImageMath 2 $mask MD $mask 4
	logCmd ImageMath 2 $mask ME $mask 4
	logCmd ConvertImagePixelType $mask $maskpng 1
	if [ $CHULL -eq 1 ]; then
	    logCmd chull.py ${mask} ${mask_chull}
	    logCmd ImageMath 2 ${mask_sub} - ${mask_chull} ${mask}
	    logCmd ImageMath 2 ${mask_sub255} m ${mask_sub} 255
	    #logCmd ImageMath 2 ${mask_chull_sub} - ${mask_chull} ${mask}
	    # convert mask from nii to png
	    logCmd ConvertImagePixelType $mask_chull $maskchullpng 1
	fi
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

	if [[ $PAD -eq 1 ]]; then
	    echo "Start padding..."
	    logCmd convert -bordercolor black -border 256 $hand $hand 
	    logCmd convert -bordercolor black -border 256 $redhand $redhand 
	    logCmd convert -bordercolor black -border 256 $greenhand $greenhand 
	    logCmd convert -bordercolor black -border 256 $bluehand $bluehand 
	    logCmd convert -bordercolor black -border 256 $yellowhand $yellowhand 
	fi

	logCmd ConvertImagePixelType $hand $handnii 1
	logCmd ConvertImagePixelType $redhand $redhandnii 1
	logCmd ConvertImagePixelType $greenhand $greenhandnii 1
	logCmd ConvertImagePixelType $bluehand $bluehandnii 1
	logCmd ConvertImagePixelType $yellowhand $yellowhandnii 1

	# Try convex hull
	if [ $CHULL -eq 1 ]; then
	    logCmd convert $hand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $hand
	    logCmd convert $redhand  -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $redhand
	    logCmd convert $greenhand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $greenhand
	    logCmd convert $bluehand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $bluehand
	    logCmd convert $yellowhand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $yellowhand
	fi


    fi

#    if [ $KEEP_TMP_IMAGES -eq "0" ]; then
#	#logCmd rm -f ${nii} ${red} ${green} ${blue} ${r_g} ${maskrg} ${mask}
#	logCmd rm -f ${ODIR}/*.nii.gz
#    fi
