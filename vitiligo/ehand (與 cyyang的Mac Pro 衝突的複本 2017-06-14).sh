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
CHULL=1
PAD=1

if [[ $# -lt 1 ]] ; then
  Usage >&2
  exit 1
else
  while getopts "f:k:" OPT
    do
      case $OPT in
          k) # keep images
	      KEEP_TMP_IMAGES=1
	      shift
              ;;
          f) # force
	      FORCE=1
	      shift
              ;;
          *) # getopts issues an error message
              echo "ERROR:  unrecognized option -$OPT $OPTARG"
              exit 1
              ;;
      esac
  done
fi


ODIR=${1%.*}.hand
SID=${1%.*}
OPRE=${ODIR}/${SID}
nii=${OPRE}.nii.gz
hand=${OPRE}_hand.png
handnii=${OPRE}_hand.nii.gz
handnii_chull=${OPRE}_hand.nii.gz
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
yellowhand_chull=${OPRE}_hand_RGB3_chull.png
redhandnii_chull=${OPRE}_hand_RGB0.nii.gz
greenhandnii_chull=${OPRE}_hand_RGB1.nii.gz
bluehandnii_chull=${OPRE}_hand_RGB2.nii.gz
yellowhandnii_chull=${OPRE}_hand_RGB3.nii.gz

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
    mkdir -p ${ODIR}
    if [[ ! -d ${ODIR} ]]; then
	echo mkdir ${ODIR} failed! Exiting!
	exit 0
    fi
fi

    # get each RGB channel
    if [[ ! -f ${blue} ]]; then
	echo "Separating RGB channels..."
	convert $1 -separate ${OPRE}_RGB%d.png
	convert $blue -negate $yellow
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
	ImageMath 2 $r_g - $red $green
    fi

    if [[ ! -f ${maskpng} || ${FORCE} -eq 1 ]]; then
	echo "Generating hand mask..."
	# Using kmeans to get threshold from R-G image
	ThresholdImage 2 $r_g $maskrg Kmeans 1
	# Convert value 2 to 1
	ThresholdImage 2 $maskrg $mask 2 2 1 0
	# Get largest component (hand)
	ImageMath 2 $mask ME $mask 2
	ImageMath 2 $mask GetLargestComponent $mask
	ImageMath 2 $mask MD $mask 2
	ImageMath 2 $mask FillHoles $mask 2
	ImageMath 2 $mask MD $mask 4
	ImageMath 2 $mask ME $mask 4
	# try remove wrist
	W=`convert $1 -format "%w" info:`
	H=`convert $1 -format "%h" info:`
	if [[ $W -gt $H ]]; then
	    ((F=W/10))
	    ((F2=W/8))
	    ((F2=W/20))
	else
	    ((F=H/10))
	    ((F2=H/8))
	    ((F3=H/20))
	fi
	ImageMath 2 ${OPRE}1palmwrist.nii.gz ME $mask $F
	ImageMath 2 ${OPRE}1palmwrist.nii.gz MD ${OPRE}1palmwrist.nii.gz $F # remove fingers
	ImageMath 2 ${OPRE}1palmwrist.nii.gz * $mask ${OPRE}1palmwrist.nii.gz # in mask

	ImageMath 2 ${OPRE}2palm.nii.gz ME $mask $F2
	ImageMath 2 ${OPRE}2palm.nii.gz MD ${OPRE}2palm.nii.gz $F2 # palm
	ImageMath 2 ${OPRE}2palm.nii.gz * $mask ${OPRE}2palm.nii.gz # in mask

	ImageMath 2 ${OPRE}3wrist.nii.gz - $mask ${OPRE}2palm.nii.gz
	ImageMath 2 ${OPRE}4wrist.nii.gz * ${OPRE}3wrist.nii.gz ${OPRE}1palmwrist.nii.gz
	#ImageMath 2 ${OPRE}3wrist.nii.gz - ${OPRE}1palmwrist.nii.gz ${OPRE}2palm.nii.gz
	#ImageMath 2 ${OPRE}3wrist.nii.gz GetLargestComponent ${OPRE}3wrist.nii.gz
	#ImageMath 2 ${OPRE}3wrist.nii.gz ME ${OPRE}3wrist.nii.gz $F3
	#ImageMath 2 ${OPRE}3wrist.nii.gz MD ${OPRE}3wrist.nii.gz $F3
	#ImageMath 2 ${OPRE}3wrist.nii.gz * ${OPRE}1palmwrist.nii.gz ${OPRE}2palm.nii.gz
	ImageMath 2 ${OPRE}_hand_stripped.nii.gz - $mask ${OPRE}4wrist.nii.gz
	ImageMath 2 $mask GetLargestComponent ${OPRE}_hand_stripped.nii.gz 
	ImageMath 2 $mask FillHoles $mask 2

	ConvertImagePixelType $mask $maskpng 1 > /dev/null 2>&1
	ConvertImagePixelType $mask $maskpng 1 > /dev/null 2>&1
	ConvertImagePixelType ${OPRE}1palmwrist.nii.gz ${OPRE}1palmwrist.png 1 > /dev/null 2>&1
	ConvertImagePixelType ${OPRE}2palm.nii.gz ${OPRE}2palm.png 1 > /dev/null 2>&1
	ConvertImagePixelType ${OPRE}3wrist.nii.gz ${OPRE}3wrist.png 1 > /dev/null 2>&1


	if [ $CHULL -eq 1 ]; then
	    echo "Generating convex hull mask..."
	    chull.py ${mask} ${mask_chull}
	    ImageMath 2 ${mask_sub} - ${mask_chull} ${mask}
	    ImageMath 2 ${mask_sub255} m ${mask_sub} 255
	    #logCmd ImageMath 2 ${mask_chull_sub} - ${mask_chull} ${mask}
	    # convert mask from nii to png
	    ConvertImagePixelType $mask_chull $maskchullpng 1 > /dev/null 2>&1
	fi
    fi
    if [[ ! -f ${hand} || ${FORCE} -eq 1 ]]; then
	echo "Extract hand using mask and fill bg with black..."
	convert $1 $maskpng -alpha Off -compose CopyOpacity -composite $hand
	convert $red $maskpng -alpha Off -compose CopyOpacity -composite $redhand
	convert $green $maskpng -alpha Off -compose CopyOpacity -composite $greenhand
	convert $blue $maskpng -alpha Off -compose CopyOpacity -composite $bluehand
	convert $yellow $maskpng -alpha Off -compose CopyOpacity -composite $yellowhand

	convert $hand -flatten -fuzz 0% -fill black -opaque white $hand
	convert $redhand -flatten -fuzz 0% -fill black -opaque white $redhand
	convert $greenhand -flatten -fuzz 0% -fill black -opaque white $greenhand
	convert $bluehand -flatten -fuzz 0% -fill black -opaque white $bluehand
	convert $yellowhand -flatten -fuzz 0% -fill black -opaque white $yellowhand

	if [ $CHULL -eq 1 ]; then
	    convert $hand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $hand_chull
	    convert $redhand  -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $redhand_chull
	    convert $greenhand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $greenhand_chull
	    convert $bluehand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $bluehand_chull
	    convert $yellowhand -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite $yellowhand_chull
	fi

	if [[ $PAD -eq 1 ]]; then
	    echo "Start padding..."
	    convert -bordercolor black -border 256 $hand $hand 
	    convert -bordercolor black -border 256 $redhand $redhand 
	    convert -bordercolor black -border 256 $greenhand $greenhand 
	    convert -bordercolor black -border 256 $bluehand $bluehand 
	    convert -bordercolor black -border 256 $yellowhand $yellowhand 
	    ImageMath 2 $mask PadImage $mask +256
	    ImageMath 2 $maskrg PadImage $maskrg +256
	    if [[ $CHULL -eq 1 ]]; then
		convert -bordercolor black -border 256 $hand_chull $hand_chull
		convert -bordercolor black -border 256 $redhand_chull $redhand_chull
		convert -bordercolor black -border 256 $greenhand_chull $greenhand_chull
		convert -bordercolor black -border 256 $bluehand_chull $bluehand_chull
		convert -bordercolor black -border 256 $yellowhand_chull $yellowhand_chull
		convert -bordercolor black -border 256 $maskpng $maskpng 
		convert -bordercolor black -border 256 $maskchullpng $maskchullpng 
		ImageMath 2 $mask_chull PadImage $mask_chull +256
		ImageMath 2 $mask_sub PadImage $mask_sub +256
		ImageMath 2 $mask_sub255 PadImage $mask_sub255 +256
	    fi
	fi


	echo "Converting png to nii..."
	ConvertImagePixelType $hand $handnii 1 > /dev/null 2>&1
	ConvertImagePixelType $redhand $redhandnii 1 > /dev/null 2>&1
	ConvertImagePixelType $greenhand $greenhandnii 1 > /dev/null 2>&1
	ConvertImagePixelType $bluehand $bluehandnii 1 > /dev/null 2>&1
	ConvertImagePixelType $yellowhand $yellowhandnii 1 > /dev/null 2>&1

	#SmoothImage 2 $hand

	#if [[ $CHULL -eq 1 ]]; then
	#    ConvertImagePixelType $hand $handnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $redhand $redhandnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $greenhand $greenhandnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $bluehand $bluehandnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $yellowhand $yellowhandnii 1 > /dev/null 2>&1
	#fi 



    fi

#    if [ $KEEP_TMP_IMAGES -eq "0" ]; then
#	#logCmd rm -f ${nii} ${red} ${green} ${blue} ${r_g} ${maskrg} ${mask}
#	logCmd rm -f ${ODIR}/*.nii.gz
#    fi

