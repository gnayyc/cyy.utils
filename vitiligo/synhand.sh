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
FORCE=0

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

if [[ ! -f $1 || ! -f $2 ]]; then
    echo "Need both $1 and $2 exist"
    exit 1
fi

SID1=${1%.*}
SID2=${2%.*}
IDIR1=${SID1}.output
IDIR2=${SID2}.output
IPRE1=${IDIR1}/${SID1}
IPRE2=${IDIR2}/${SID2}
SID=${SID1}_${SID2}
SIDinv=${SID2}_${SID1}
ODIR=${SID}.output
OUTPUT_PREFIX=${ODIR}/${SID}
OUTPUT_PREFIXinv=${ODIR}/${SIDinv}

OPRE1=${ODIR}/${SID1}
OPRE2=${ODIR}/${SID2}

CHULL=0
if [ $CHULL -eq 1 ]; then
    imask1=${IPRE1}_mask_chull.nii.gz
    imask2=${IPRE2}_mask_chull.nii.gz
    imask_sub1=${IPRE1}_mask_sub255.nii.gz
    imask_sub2=${IPRE2}_mask_sub255.nii.gz
else
    imask1=${IPRE1}_mask.nii.gz
    imask2=${IPRE2}_mask.nii.gz
fi
ihandpng1=${IPRE1}_hand.png
ihandpng2=${IPRE2}_hand.png
ihandnii1=${IPRE1}_hand.nii.gz
ihandnii2=${IPRE2}_hand.nii.gz

USE_NII=1
if [ $USE_NII -eq 1 ]; then
    hand1=${ODIR}/hand_0fixed_${SID1}.nii.gz
    hand2=${ODIR}/hand_2moving_${SID2}.nii.gz
    redhand1=${IPRE1}_hand_RGB0.nii.gz
    greenhand1=${IPRE1}_hand_RGB1.nii.gz
    bluehand1=${IPRE1}_hand_RGB2.nii.gz
    yellowhand1=${IPRE1}_hand_RGB3.nii.gz
    redhand2=${IPRE2}_hand_RGB0.nii.gz
    greenhand2=${IPRE2}_hand_RGB1.nii.gz
    bluehand2=${IPRE2}_hand_RGB2.nii.gz
    yellowhand2=${IPRE2}_hand_RGB3.nii.gz
else
    hand1=${OPRE1}_hand.png
    hand2=${OPRE2}_hand.png
    redhand1=${IPRE1}_hand_RGB0.png
    greenhand1=${IPRE1}_hand_RGB1.png
    bluehand1=${IPRE1}_hand_RGB2.png
    yellowhand1=${IPRE1}_hand_RGB3.png
    redhand2=${IPRE2}_hand_RGB0.png
    greenhand2=${IPRE2}_hand_RGB1.png
    bluehand2=${IPRE2}_hand_RGB2.png
    yellowhand2=${IPRE2}_hand_RGB3.png
fi


redhand1png=${OUTPUT_PREFIXinv}_Warped_RGB0.png
greenhand1png=${OUTPUT_PREFIXinv}_Warped_RGB1.png
bluehand1png=${OUTPUT_PREFIXinv}_Warped_RGB2.png
yellowhand1png=${OUTPUT_PREFIXinv}_Warped_RGB3.png
redhand1nii=${OUTPUT_PREFIXinv}_Warped_RGB0.nii.gz
greenhand1nii=${OUTPUT_PREFIXinv}_Warped_RGB1.nii.gz
bluehand1nii=${OUTPUT_PREFIXinv}_Warped_RGB2.nii.gz
yellowhand1nii=${OUTPUT_PREFIXinv}_Warped_RGB3.nii.gz

redhand2png=${OUTPUT_PREFIX}_Warped_RGB0.png
greenhand2png=${OUTPUT_PREFIX}_Warped_RGB1.png
bluehand2png=${OUTPUT_PREFIX}_Warped_RGB2.png
yellowhand2png=${OUTPUT_PREFIX}_Warped_RGB3.png
redhand2nii=${OUTPUT_PREFIX}_Warped_RGB0.nii.gz
greenhand2nii=${OUTPUT_PREFIX}_Warped_RGB1.nii.gz
bluehand2nii=${OUTPUT_PREFIX}_Warped_RGB2.nii.gz
yellowhand2nii=${OUTPUT_PREFIX}_Warped_RGB3.nii.gz

warpedpng=${ODIR}/hand_png_1Warped_${SID2}to${SID1}.png
warpednii=${ODIR}/hand_1Warped_${SID2}to${SID1}.nii.gz
invwarpedpng=${ODIR}/hand_png_3Warped_${SID1}to${SID2}.png
invwarpednii=${ODIR}/hand_3Warped_${SID1}to${SID2}.nii.gz

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

# extract hands
logCmd ehand.sh $1
logCmd ehand.sh $2

if [[ ! -d ${ODIR} || ${FORCE} -eq 1 ]]; then
    echo ${ODIR} not exists. Making it!
    logCmd mkdir -p ${ODIR}
    if [[ ! -d ${ODIR} ]]; then
	echo mkdir ${ODIR} failed! Exiting!
	exit
    else
	logCmd cp $1 $2 $imask1 $imask2 ${ODIR}
	logCmd cp $ihandpng1 ${ODIR}/hand_png_0fixed_${SID1}.png
	logCmd cp $ihandpng2 ${ODIR}/hand_png_2moving_${SID2}.png
	logCmd cp $ihandnii1 ${hand1}
	logCmd cp $ihandnii2 ${hand2}
	#logCmd ConvertImagePixelType ${ihand1} ${hand1} 1
	#logCmd ConvertImagePixelType ${ihand2} ${hand2} 1
	if [ $CHULL -eq 1 ]; then
	    logCmd ImageMath 2 ${hand1} overadd ${hand1} $imask_sub1
	    logCmd ImageMath 2 ${hand2} overadd ${hand2} $imask_sub2
	fi
    fi
fi

PAD=0

if [[ ! -f ${OUTPUT_PREFIX}0GenericAffine.mat || ${FORCE} -eq 1 ]]; then
    #logCmd antsRegistrationSyNQuick.sh -d 2 -f $hand1 -m $hand2 -o ${OUTPUT_PREFIX} -n 10 -t b -s 256
    #logCmd antsRegistrationSyNQuick.sh -d 2 -f $redhand1 -m $redhand2 -f $greenhand1 -m $greenhand2 -f $bluehand1 -m $bluehand2 -o ${OUTPUT_PREFIX} -n 10 -t b -s 256
    #logCmd antsRegistrationSyNQuick.sh -d 2 -f $greenhand1 -m $greenhand2 -f $bluehand1 -m $bluehand2 -f $redhand1 -m $redhand2 -o ${OUTPUT_PREFIX} -n 10 -t b -s 256
    #logCmd antsRegistrationSyNQuick.sh -d 2 -f $redhand1 -m $redhand2 -o ${OUTPUT_PREFIX}R -n 10 -t b -s 256
    #logCmd antsRegistrationSyNQuick.sh -d 2 -f $greenhand1 -m $greenhand2 -o ${OUTPUT_PREFIX}G -n 10 -t b -s 256
    #logCmd antsRegistrationSyNQuick.sh -d 2 -f $bluehand1 -m $greenhand2 -o ${OUTPUT_PREFIX}B -n 10 -t b -s 256
    
    if [ $PAD -eq 1 ]; then
	logCmd ImageMath 2 $imask1 PadImage $imask1 +256
	logCmd ImageMath 2 $redhand1 PadImage $redhand1 +256
	logCmd ImageMath 2 $greenhand1 PadImage $greenhand1 +256
	logCmd ImageMath 2 $bluehand1 PadImage $bluehand1 +256
	logCmd ImageMath 2 $imask2 PadImage $imask2 +256
	logCmd ImageMath 2 $redhand2 PadImage $redhand2 +256
	logCmd ImageMath 2 $greenhand2 PadImage $greenhand2 +256
	logCmd ImageMath 2 $bluehand2 PadImage $bluehand2 +256
    fi
    logCmd antsRegistrationSyNQuick.sh -d 2 -f $imask1 -m $imask2 -f $redhand1 -m $redhand2 -f $greenhand1 -m $greenhand2 -f $bluehand1 -m $bluehand2 -o ${OUTPUT_PREFIX} -n 10 -t b -s 256


    #logCmd ImageMath 2 $hand1 PadImage $_hand1 -100
    #logCmd ImageMath 2 $hand2 PadImage $_hand2 -100
    #logCmd ImageMath 2 $mask1 PadImage $_mask1 -100
    #logCmd ImageMath 2 $mask2 PadImage $_mask2 -100

    #if [[ ! -f ${OUTPUT_PREFIX}.png ]]; then
	logCmd antsApplyTransforms -d 2 -i $redhand2 -o $redhand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	logCmd antsApplyTransforms -d 2 -i $greenhand2 -o $greenhand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	logCmd antsApplyTransforms -d 2 -i $bluehand2 -o $bluehand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	logCmd antsApplyTransforms -d 2 -i $yellowhand2 -o $yellowhand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat

	logCmd antsApplyTransforms -d 2 -i $redhand1 -o $redhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	logCmd antsApplyTransforms -d 2 -i $greenhand1 -o $greenhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	logCmd antsApplyTransforms -d 2 -i $bluehand1 -o $bluehand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	logCmd antsApplyTransforms -d 2 -i $yellowhand1 -o $yellowhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	#logCmd antsApplyTransforms -d 2 -o Linear[${OUTPUT_PREFIX}1InverseAffine.mat,1] -t ${OUTPUT_PREFIX}0GenericAffine.mat --verbose 1

	logCmd ConvertImagePixelType $redhand2nii $redhand2png 1
	logCmd ConvertImagePixelType $greenhand2nii $greenhand2png 1
	logCmd ConvertImagePixelType $bluehand2nii $bluehand2png 1
	logCmd ConvertImagePixelType $yellowhand2nii $yellowhand2png 1

	logCmd ConvertImagePixelType $redhand1nii $redhand1png 1
	logCmd ConvertImagePixelType $greenhand1nii $greenhand1png 1
	logCmd ConvertImagePixelType $bluehand1nii $bluehand1png 1
	logCmd ConvertImagePixelType $yellowhand1nii $yellowhand1png 1

	logCmd convert $redhand2png $greenhand2png $bluehand2png -combine $warpedpng
	logCmd convert $redhand1png $greenhand1png $bluehand1png -combine $invwarpedpng

	logCmd ConvertImagePixelType ${OUTPUT_PREFIX}Warped.nii.gz ${OUTPUT_PREFIX}Warped.png 1
	logCmd ConvertImagePixelType ${OUTPUT_PREFIX}InverseWarped.nii.gz ${OUTPUT_PREFIX}InverseWarped.png 1

	logCmd ConvertImagePixelType $warpedpng ${ODIR}/hand_1Warped_${SID2}to${SID1}.nii.gz 1
	logCmd ConvertImagePixelType $invwarpedpng ${ODIR}/hand_1Warped_${SID1}to${SID2}.nii.gz 1
	logCmd CreateWarpedGridImage 2 ${OUTPUT_PREFIX}1Warp.nii.gz ${OUTPUT_PREFIX}WarpedGrid.nii.gz
	logCmd ConvertImage 2 ${OUTPUT_PREFIX}1Warp.nii.gz ${OUTPUT_PREFIX}_ 10
	logCmd ConvertTransformFile 2 ${OUTPUT_PREFIX}0GenericAffine.mat ${OUTPUT_PREFIX}0GenericAffine.txt

    #fi
fi
if [ $KEEP_TMP_IMAGES -eq "0" ]; then
    echo
    #logCmd rm -f ${OUTPUT_PREFIX}*.nii.gz ${OUTPUT_PREFIX}*.mat
fi

#logCmd rm -f $r1_png $g1_png $b1_png

#antsMultivariateTemplateConstruction2.sh -d 2 -n 0 -i 4 -r 1 -y 0 -l 0 -o handmask -c 2 -j 10 ?.png
