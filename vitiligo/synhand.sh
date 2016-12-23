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
ODIR=${SID1}_${SID2}.output
OUTPUT_PREFIX=${ODIR}/${SID}

OPRE1=${ODIR}/${SID1}
OPRE2=${ODIR}/${SID2}


imask1=${IPRE1}_mask.nii.gz
imask2=${IPRE2}_mask.nii.gz
ihand1=${IPRE1}_hand.png
ihand2=${IPRE2}_hand.png

redhand1=${IPRE1}_hand_RGB0.png
greenhand1=${IPRE1}_hand_RGB1.png
bluehand1=${IPRE1}_hand_RGB2.png
yellowhand1=${IPRE1}_hand_RGB3.png
redhand2=${IPRE2}_hand_RGB0.png
greenhand2=${IPRE2}_hand_RGB1.png
bluehand2=${IPRE2}_hand_RGB2.png
yellowhand2=${IPRE2}_hand_RGB3.png

mask1=${OPRE1}_mask.nii.gz
mask2=${OPRE2}_mask.nii.gz
#hand1=${OPRE1}_hand.png
#hand2=${OPRE2}_hand.png
hand1=${ODIR}/hand_png_0fixed_${SID1}.png
hand2=${ODIR}/hand_png_2moving_${SID2}.png

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
	logCmd cp $ihand1 $hand1
	logCmd cp $ihand2 $hand2
	logCmd ConvertImagePixelType ${ihand1} ${ODIR}/hand_0fixed_${SID1}.nii.gz 1
	logCmd ConvertImagePixelType ${ihand2} ${ODIR}/hand_2moving_${SID2}.nii.gz 1
    fi
fi


if [[ ! -f ${OUTPUT_PREFIX}0GenericAffine.mat || ${FORCE} -eq 1 ]]; then
    #logCmd antsRegistrationSyNQuick.sh -d 2 -t bo -s 15 -f $hand1 -x $mask1 -m $hand2 -o ${OUTPUT_PREFIX} -n 10
    #logCmd antsRegistrationSyNQuick.sh -d 2 -t bo -s 15 -f $hand1 -m $hand2 -o ${OUTPUT_PREFIX} -n 10
#    logCmd /usr/local/ANTs/bin//antsRegistration \
#	--verbose 1 \
#	--dimensionality 2 \
#	--float 0 \
#	--output [${OUTPUT_PREFIX},${OUTPUT_PREFIX}Warped.nii.gz,${OUTPUT_PREFIX}InverseWarped.nii.gz] \
#	--interpolation Linear \
#	--use-histogram-matching 0 \
#	--winsorize-image-intensities [0.005,0.995] \
#	--initial-moving-transform [$hand1,$hand2,1] \
#	--transform BSplineSyN[0.1,15,0,3] \
#	--metric MI[$hand1,$hand2,1,32] \
#	--convergence [100x100x70x50x0,1e-6,10] \
#	--shrink-factors 10x6x4x2x1 \
#	--smoothing-sigmas 5x3x2x1x0vox \
#	--masks [$mask1,$mask2]
#    logCmd /usr/local/ANTs/bin//antsRegistration \
#	--verbose 1 \
#	--dimensionality 2 \
#	--float 0 \
#	--output [${OUTPUT_PREFIX},${OUTPUT_PREFIX}Warped.nii.gz,${OUTPUT_PREFIX}InverseWarped.nii.gz] \
#	--interpolation BSpline \
#	--use-histogram-matching 0 \
#	--winsorize-image-intensities [0.005,0.995] \
#	--initial-moving-transform [$mask1,$mask2,1] \
#	--transform Rigid[0.1] \
#	--metric MI[$hand1,$hand2,1,32,Regular,0.25] \
#	--convergence [1000x500x250x0,1e-6,10] \
#	--shrink-factors 12x8x4x2 \
#	--smoothing-sigmas 4x3x2x1vox \
#	--transform Affine[0.1] \
#	--metric MI[$hand1,$hand2,1,32,Regular,0.25] \
#	--convergence [1000x500x250x0,1e-6,10] \
#	--shrink-factors 12x8x4x2 \
#	--smoothing-sigmas 4x3x2x1vox \
#	--transform BSplineSyN[0.1,10,0,3] \
#	--metric MSQ[$mask1,$mask2,1,1] \
#	--convergence [1000x500x250x200x100,1e-6,10] \
#	--shrink-factors 8x6x4x2x1 \
#	--smoothing-sigmas 5x3x2x1x0vox \
#	--masks [$mask1,$mask2]

    #logCmd ImageMath 2 $hand1 PadImage $_hand1 100
    #logCmd ImageMath 2 $hand2 PadImage $_hand2 100
    #logCmd ImageMath 2 $mask1 PadImage $_mask1 100
    #logCmd ImageMath 2 $mask2 PadImage $_mask2 100

    logCmd /usr/local/ANTs/bin//antsRegistration \
	--verbose 1 \
	--dimensionality 2 \
	--float 0 \
	--output [${OUTPUT_PREFIX},${OUTPUT_PREFIX}Warped.nii.gz,${OUTPUT_PREFIX}InverseWarped.nii.gz] \
	--interpolation BSpline \
	--use-histogram-matching 0 \
	--winsorize-image-intensities [0.005,0.995] \
	--initial-moving-transform [$mask1,$mask2,1] \
	--transform Rigid[0.1] \
	--metric MI[$mask1,$mask2,1,32,Regular,0.25] \
	--convergence [1000x500x250x0,1e-6,10] \
	--shrink-factors 12x8x4x2 \
	--smoothing-sigmas 4x3x2x1vox \
	--transform Affine[0.1] \
	--metric MI[$mask1,$mask2,1,32,Regular,0.25] \
	--convergence [1000x500x250x0,1e-6,10] \
	--shrink-factors 12x8x4x2 \
	--smoothing-sigmas 4x3x2x1vox \
	--transform BSplineSyN[0.1,5,0,3] \
	--metric CC[$mask1,$mask2,1,5] \
	--convergence [1000x500x250x200x100,1e-6,10] \
	--shrink-factors 8x6x4x2x1 \
	--smoothing-sigmas 5x3x2x1x0vox \
	--masks [$mask1,$mask2]

	# Notes
	#--transform SyN[0.1,10,0,3] \ 
	# No good
	--metric MI[$mask1,$mask2,1,32,Regular,0.25] \
	# good
	#--metric CC[$redhand1,$redhand2,1,5] \ 
	# wavy contour
	#--metric MSQ[$mask1,$mask2,1,1] \ 
	# good
	#--metric Demons[$mask1,$mask2,1,1] \
	#--metric GC[$hand1, $hand2, 1, 1] \
	#--metric ICP[$hand1, $hand2, 1] \
	#--metric PSE[$hand1, $hand2, 1] \
	#--metric JHCT[$hand1, $hand2, 1] \
	#--metric IGDM[$hand1, $hand2, 1, $mask1, $mask2] \

    #logCmd ImageMath 2 $hand1 PadImage $_hand1 -100
    #logCmd ImageMath 2 $hand2 PadImage $_hand2 -100
    #logCmd ImageMath 2 $mask1 PadImage $_mask1 -100
    #logCmd ImageMath 2 $mask2 PadImage $_mask2 -100

    #if [[ ! -f ${OUTPUT_PREFIX}.png ]]; then
	logCmd antsApplyTransforms -d 2 -i $redhand2 -o $redhand2nii -r $2 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	logCmd antsApplyTransforms -d 2 -i $greenhand2 -o $greenhand2nii -r $2 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	logCmd antsApplyTransforms -d 2 -i $bluehand2 -o $bluehand2nii -r $2 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	logCmd antsApplyTransforms -d 2 -i $yellowhand2 -o $yellowhand2nii -r $2 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat

	logCmd ConvertImagePixelType $redhand2nii $redhand2png 1
	logCmd ConvertImagePixelType $greenhand2nii $greenhand2png 1
	logCmd ConvertImagePixelType $bluehand2nii $bluehand2png 1
	logCmd ConvertImagePixelType $yellowhand2nii $yellowhand2png 1

	logCmd convert $redhand2png $greenhand2png $bluehand2png -combine $warpedpng

	logCmd ConvertImagePixelType ${OUTPUT_PREFIX}Warped.nii.gz ${OUTPUT_PREFIX}Warped.png 1
	logCmd ConvertImagePixelType ${OUTPUT_PREFIX}InverseWarped.nii.gz ${OUTPUT_PREFIX}InverseWarped.png 1
	logCmd ConvertImagePixelType $warpedpng ${ODIR}/hand_1Warped_${SID2}to${SID1}.nii.gz 1
	logCmd CreateWarpedGridImage 2 ${OUTPUT_PREFIX}1Warp.nii.gz ${OUTPUT_PREFIX}WarpedGrid.nii.gz

    #fi
fi
if [ $KEEP_TMP_IMAGES -eq "0" ]; then
    echo
    #logCmd rm -f ${OUTPUT_PREFIX}*.nii.gz ${OUTPUT_PREFIX}*.mat
fi

#logCmd rm -f $r1_png $g1_png $b1_png

#antsMultivariateTemplateConstruction2.sh -d 2 -n 0 -i 4 -r 1 -y 0 -l 0 -o handmask -c 2 -j 10 ?.png
