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
IDIR1=${SID1}.hand
IDIR2=${SID2}.hand
IPRE1=${IDIR1}/${SID1}
IPRE2=${IDIR2}/${SID2}
SID=${SID1}_${SID2}
SIDinv=${SID2}_${SID1}
ODIR=${SID}.syn
OUTPUT_PREFIX=${ODIR}/${SID}
OUTPUT_PREFIXinv=${ODIR}/${SIDinv}

OPRE1=${ODIR}/${SID1}
OPRE2=${ODIR}/${SID2}

imask1=${IPRE1}_mask.nii.gz
imask2=${IPRE2}_mask.nii.gz
imask1_canny=${IPRE1}_mask_canny.nii.gz
imask2_canny=${IPRE2}_mask_canny.nii.gz

ilabel1=${IPRE1}_label.nii.gz
ilabel2=${IPRE2}_label.nii.gz

CHULL=0
if [ $CHULL -eq 1 ]; then
    affinemask1=${IPRE1}_mask_chull.nii.gz
    affinemask2=${IPRE2}_mask_chull.nii.gz
    affinemask2to1=${OUTPUT_PREFIX}_1Affine_mask_chull.nii.gz
    affinemask2to1png=${OUTPUT_PREFIX}_1Affine_mask_chull.png
    imask_sub1=${IPRE1}_mask_sub255.nii.gz
    imask_sub2=${IPRE2}_mask_sub255.nii.gz
else
    affinemask1=${IPRE1}_mask.nii.gz
    affinemask2=${IPRE2}_mask.nii.gz
fi
ihandpng1=${IPRE1}_hand.png
ihandpng2=${IPRE2}_hand.png
ihandnii1=${IPRE1}_hand.nii.gz
ihandnii2=${IPRE2}_hand.nii.gz
hand1_b=${IPRE1}_hand_sRGB2.nii.gz
hand2_b=${IPRE2}_hand_sRGB2.nii.gz
hand1_n4=${IPRE1}_hand_N4.nii.gz
hand2_n4=${IPRE2}_hand_N4.nii.gz
hand1_canny=${IPRE1}_hand_canny.nii.gz
hand2_canny=${IPRE2}_hand_canny.nii.gz
hand1_phase=${IPRE1}_hand_phase.png
hand2_phase=${IPRE2}_hand_phase.png
hand1_phase_smooth=${IPRE1}_hand_phase_smooth.nii.gz
hand2_phase_smooth=${IPRE2}_hand_phase_smooth.nii.gz
hand1_lab0=${IPRE1}_hand_LAB0.png
hand2_lab0=${IPRE2}_hand_LAB0.png
hand1_lab1=${IPRE1}_hand_LAB1.png
hand2_lab1=${IPRE2}_hand_LAB1.png
hand1_cmyk=${IPRE1}_hand_CMYK2.png
hand2_cmyk=${IPRE2}_hand_CMYK2.png
hand1_wavelet=${IPRE1}_hand_wavelet.png
hand2_wavelet=${IPRE2}_hand_wavelet.png
hand1_wavelet_n4=${IPRE1}_hand_wavelet_N4.nii.gz
hand2_wavelet_n4=${IPRE2}_hand_wavelet_N4.nii.gz
hand1_wavelet_n4n=${IPRE1}_hand_wavelet_N4_neg.nii.gz
hand2_wavelet_n4n=${IPRE2}_hand_wavelet_N4_neg.nii.gz

USE_NII=1
SMOOTH=1
if [ $USE_NII -eq 1 ]; then
    hand1=${ODIR}/hand_0fixed_${SID1}.nii.gz
    hand2=${ODIR}/hand_2moving_${SID2}.nii.gz
    redhand1=${IPRE1}_hand_sRGB0.nii.gz
    greenhand1=${IPRE1}_hand_sRGB1.nii.gz
    bluehand1=${IPRE1}_hand_sRGB2.nii.gz
    #yellowhand1=${IPRE1}_hand_sRGB3.nii.gz
    redhand2=${IPRE2}_hand_sRGB0.nii.gz
    greenhand2=${IPRE2}_hand_sRGB1.nii.gz
    bluehand2=${IPRE2}_hand_sRGB2.nii.gz
    #yellowhand2=${IPRE2}_hand_sRGB3.nii.gz
    if [[ $SMOOTH -eq 1 ]]; then
	redhand1_smooth=${IPRE1}_hand_sRGB0_smooth.nii.gz
	greenhand1_smooth=${IPRE1}_hand_sRGB1_smooth.nii.gz
	bluehand1_smooth=${IPRE1}_hand_sRGB2_smooth.nii.gz
	#yellowhand1_smooth=${IPRE1}_hand_sRGB3_smooth.nii.gz
	redhand2_smooth=${IPRE2}_hand_sRGB0_smooth.nii.gz
	greenhand2_smooth=${IPRE2}_hand_sRGB1_smooth.nii.gz
	bluehand2_smooth=${IPRE2}_hand_sRGB2_smooth.nii.gz
	#yellowhand2_smooth=${IPRE2}_hand_sRGB3_smooth.nii.gz
    fi
else
    hand1=${OPRE1}_hand.png
    hand2=${OPRE2}_hand.png
    redhand1=${IPRE1}_hand_sRGB0.png
    greenhand1=${IPRE1}_hand_sRGB1.png
    bluehand1=${IPRE1}_hand_sRGB2.png
    #yellowhand1=${IPRE1}_hand_sRGB3.png
    redhand2=${IPRE2}_hand_sRGB0.png
    greenhand2=${IPRE2}_hand_sRGB1.png
    bluehand2=${IPRE2}_hand_sRGB2.png
    #yellowhand2=${IPRE2}_hand_sRGB3.png
fi

hand1_chull=${ODIR}/hand_0fixed_${SID1}_chull.nii.gz
hand2_chull=${ODIR}/hand_2moving_${SID2}_chull.nii.gz
redhand1_chull=${IPRE1}_hand_sRGB0_chull.nii.gz
greenhand1_chull=${IPRE1}_hand_sRGB1_chull.nii.gz
bluehand1_chull=${IPRE1}_hand_sRGB2_chull.nii.gz
#yellowhand1_chull=${IPRE1}_hand_sRGB3_chull.nii.gz
redhand2_chull=${IPRE2}_hand_sRGB0_chull.nii.gz
greenhand2_chull=${IPRE2}_hand_sRGB1_chull.nii.gz
bluehand2_chull=${IPRE2}_hand_sRGB2_chull.nii.gz
#yellowhand2_chull=${IPRE2}_hand_sRGB3_chull.nii.gz

redhand1png=${OUTPUT_PREFIXinv}_Warped_sRGB0.png
greenhand1png=${OUTPUT_PREFIXinv}_Warped_sRGB1.png
bluehand1png=${OUTPUT_PREFIXinv}_Warped_sRGB2.png
#yellowhand1png=${OUTPUT_PREFIXinv}_Warped_sRGB3.png
redhand1nii=${OUTPUT_PREFIXinv}_Warped_sRGB0.nii.gz
greenhand1nii=${OUTPUT_PREFIXinv}_Warped_sRGB1.nii.gz
bluehand1nii=${OUTPUT_PREFIXinv}_Warped_sRGB2.nii.gz
#yellowhand1nii=${OUTPUT_PREFIXinv}_Warped_sRGB3.nii.gz

redhand2png=${OUTPUT_PREFIX}_Warped_sRGB0.png
greenhand2png=${OUTPUT_PREFIX}_Warped_sRGB1.png
bluehand2png=${OUTPUT_PREFIX}_Warped_sRGB2.png
#yellowhand2png=${OUTPUT_PREFIX}_Warped_sRGB3.png
redhand2nii=${OUTPUT_PREFIX}_Warped_sRGB0.nii.gz
greenhand2nii=${OUTPUT_PREFIX}_Warped_sRGB1.nii.gz
bluehand2nii=${OUTPUT_PREFIX}_Warped_sRGB2.nii.gz
#yellowhand2nii=${OUTPUT_PREFIX}_Warped_sRGB3.nii.gz

redhand2png_affine=${OUTPUT_PREFIX}_Affine_sRGB0.png
greenhand2png_affine=${OUTPUT_PREFIX}_Affine_sRGB1.png
bluehand2png_affine=${OUTPUT_PREFIX}_Affine_sRGB2.png
#yellowhand2png_affine=${OUTPUT_PREFIX}_Affine_sRGB3.png
redhand2nii_affine=${OUTPUT_PREFIX}_Affine_sRGB0.nii.gz
greenhand2nii_affine=${OUTPUT_PREFIX}_Affine_sRGB1.nii.gz
bluehand2nii_affine=${OUTPUT_PREFIX}_Affine_sRGB2.nii.gz
#yellowhand2nii_affine=${OUTPUT_PREFIX}_Affine_sRGB3.nii.gz

warpedpng=${ODIR}/hand_png_1Warped_${SID2}to${SID1}.png
warpednii=${ODIR}/hand_1Warped_${SID2}to${SID1}.nii.gz
affinepng=${ODIR}/hand_png_1ZAffine_${SID2}to${SID1}.png
affinenii=${ODIR}/hand_1ZAffine_${SID2}to${SID1}.nii.gz
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
    if [[ ! -d ${ODIR} ]]; then
	echo ${ODIR} not exists. Making it!
	mkdir -p ${ODIR}
    fi
    if [[ ! -d ${ODIR} ]]; then
	echo mkdir ${ODIR} failed! Exiting!
	exit
    else
	echo "  Copying original files..."
	cp $1 $2 $imask1 $imask2 ${ODIR}
	cp $ihandpng1 ${ODIR}/hand_png_0fixed_${SID1}.png
	cp $ihandpng2 ${ODIR}/hand_png_2moving_${SID2}.png
	cp $ihandnii1 ${hand1}
	cp $ihandnii2 ${hand2}
	#logCmd ConvertImagePixelType ${ihand1} ${hand1} 1 > /dev/null 2>&1
	#logCmd ConvertImagePixelType ${ihand2} ${hand2} 1 > /dev/null 2>&1
	if [ $CHULL -eq 1 ]; then
	    echo "  Overadd convex hull...."

	    ImageMath 2 ${hand1_chull} overadd ${hand1} $imask_sub1
	    ImageMath 2 ${hand2_chull} overadd ${hand2} $imask_sub2
	    ImageMath 2 ${redhand1_chull} overadd ${redhand1} $imask_sub1
	    ImageMath 2 ${redhand2_chull} overadd ${redhand2} $imask_sub2
	    ImageMath 2 ${greenhand1_chull} overadd ${greenhand1} $imask_sub1
	    ImageMath 2 ${greenhand2_chull} overadd ${greenhand2} $imask_sub2
	    ImageMath 2 ${bluehand1_chull} overadd ${bluehand1} $imask_sub1
	    ImageMath 2 ${bluehand2_chull} overadd ${bluehand2} $imask_sub2
	    #ImageMath 2 ${yellowhand1_chull} overadd ${yellowhand1} $imask_sub1
	    #ImageMath 2 ${yellowhand2_chull} overadd ${yellowhand2} $imask_sub2
	fi
    fi
fi

PAD=1

if [[ ! -f ${OUTPUT_PREFIX}0GenericAffine.mat || ${FORCE} -eq 1 ]]; then
    QUICK=0
    if [[ $QUICK -eq 1 ]]; then
        logCmd antsRegistrationSyNQuick.sh -d 2 \
    	-f $imask1 -m $imask2 \
    	-f $redhand1 -m $redhand2 \
    	-f $greenhand1 -m $greenhand2 \
    	-f $bluehand1 -m $bluehand2 \
    	-o ${OUTPUT_PREFIX} -n 10 -t b -s 256
	# actual call
	#/usr/local/ANTs/bin//antsRegistration --verbose 1 --dimensionality 2 --float 0 
	#--interpolation Linear 
	#--use-histogram-matching 0 
	#--winsorize-image-intensities [0.005,0.995] 
	#--initial-moving-transform [1.output/1_mask_chull.nii.gz,2.output/2_mask_chull.nii.gz,1] 
	#--transform Rigid[0.1] 
	#--metric MI[1.output/1_mask_chull.nii.gz,2.output/2_mask_chull.nii.gz,1,32,Regular,0.25] 
	#--convergence [1000x500x250x0,1e-6,10 ] 
	#--shrink-factors 12x8x4x2 
	#--smoothing-sigmas 4x3x2x1vox 
	#--transform Affine[0.1] 
	#--metric MI[1.output/1_mask_chull.nii.gz,2.output/2_mask_chull.nii.gz,1,32,Regular,0.25] 
	#--convergence [1000x500x250x0 ,1e-6,10] 
	#--shrink-factors 12x8x4x2 
	#--smoothing-sigmas 4x3x2x1vox 
	#--transform BSplineSyN[0.1,256,0,3 ] 
	#--metric MI[1.output/1_mask_chull.nii.gz,2.output/2_mask_chull.nii.gz,1,32] 
	#--metric MI[1.output/1_hand_sRGB0.nii.gz,2.output/2_hand_sRGB0.nii.gz,1,32] 
	#--metric MI[1.output/1_hand_sRGB1.nii.gz,2.output /2_hand_sRGB1.nii.gz,1,32] 
	#--metric MI[1.output/1_hand_sRGB2.nii.gz,2.output/2_hand_sRGB2.nii.gz,1,32] 
	#--convergence [100x100x70x50x0,1e-6,10] 
	#--shrink-factors 10x6x4x2x1 
	#--smoothing-sigmas 5x3x2x1x0vox
    else
	logCmd /usr/local/ANTs/bin//antsRegistration \
	    --verbose 1 \
	    --dimensionality 2 \
	    --float 0 \
	    --output [${OUTPUT_PREFIX},${OUTPUT_PREFIX}Warped.nii.gz,${OUTPUT_PREFIX}InverseWarped.nii.gz] \
	    --interpolation Linear \
	    --winsorize-image-intensities [0.001,0.999] \
	    --use-histogram-matching 0 \
	    --initial-moving-transform [${ilabel1},${ilabel2},1] \
	    --transform Rigid[0.1] \
	    --metric MI[${ilabel1},${ilabel2},1,32,Regular,0.25] \
	    --convergence [1000x500x250x100,1e-6,10] \
	    --shrink-factors 12x8x4x2 \
	    --smoothing-sigmas 4x3x2x1vox \
	    --transform Affine[0.1] \
	    --metric MI[${ilabel1},${ilabel2},1,32,Regular,0.25] \
	    --convergence [1000x1000x500x250x100,1e-6,10] \
	    --shrink-factors 16x12x8x4x2 \
	    --smoothing-sigmas 5x4x3x2x1vox \
	    --transform BSplineSyN[0.1,128,0,3] \
	    --metric MI[${hand1_b},${hand2_b},1,32,Regular,0.5] \
	    --convergence [200x200x200x0x0,1e-8,20] \
	    --shrink-factors 16x8x4x2x1 \
	    --smoothing-sigmas 6x3x2x1x0vox \
	    --verbose 1

	    --initial-moving-transform [${affinemask1},${affinemask2},1] \

	    --metric MI[${affinemask1},${affinemask2},1,32,Regular,0.25] \

	    --metric Mattes[${imask1},${imask2},1,16] \
	    --metric Mattes[${ilabel1},${ilabel2},1,16] \
	    --metric MI[${hand1_n4},${hand2_n4},1,32,Regular,0.5] \
	    --metric MI[${hand1_b},${hand2_b},1,32,Regular,0.5] \
	    --metric MI[${hand1_lab0},${hand2_lab0},1,32,Regular,0.5] \
	    --metric MI[${hand1_wavelet_n4n},${hand2_wavelet_n4n},1,32,Regular,0.5] \
	    --metric MI[${hand1_cmyk},${hand2_cmyk},1,32,Regular,0.5] \

	    --metric Mattes[${imask1},${imask2},1,16] \
	    --metric MI[${hand1_wavelet},${hand2_wavelet},1,32] \
	    --metric MI[${hand1_phase},${hand2_phase},1,32] \
	    --metric MI[${hand1_lab1},${hand2_lab1},1,32,Regular,0.5] \


	    --masks [${imask1},${imask2}] \
	    --transform BSplineSyN[0.1,256,0,3] \
	    --metric MI[${imask1},${imask2},1,32] \
	    --metric Mattes[${hand1_canny},${hand2_canny},1,32] \
	    --convergence [1000x1000x1000x700x100x0,1e-6,10] \
	    --shrink-factors 16x10x6x4x2x1 \
	    --smoothing-sigmas 8x5x3x2x1x0vox \

	    # mask_canny will cause malalignment
	    --metric Mattes[${imask1_canny},${imask2_canny},1,32] \

	    --metric MI[${redhand1},${redhand2},1,32] \
	    --metric MI[${greenhand1},${greenhand2},1,32] \
	    --metric MI[${bluehand1},${bluehand2},1,32] \
	    #--metric MI[${redhand1_smooth},${redhand2_smooth},1,32] \
	    #--metric MI[${greenhand1_smooth},${greenhand2_smooth},1,32] \
	    #--metric MI[${bluehand1_smooth},${bluehand2_smooth},1,32] \
    fi

    #if [[ ! -f ${OUTPUT_PREFIX}.png ]]; then
	echo "Applying transforms..."
	#INTER=Linear
	#INTER=BSpline
	INTER=NearestNeighbor
	antsApplyTransforms -d 2 -n ${INTER} -i $redhand2 -o $redhand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	antsApplyTransforms -d 2 -n ${INTER} -i $greenhand2 -o $greenhand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	antsApplyTransforms -d 2 -n ${INTER} -i $bluehand2 -o $bluehand2nii -r $hand1 \
	    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat
	#antsApplyTransforms -d 2 -n ${INTER} -i $yellowhand2 -o $yellowhand2nii -r $hand1 \
	#    -t ${OUTPUT_PREFIX}1Warp.nii.gz -t ${OUTPUT_PREFIX}0GenericAffine.mat

	antsApplyTransforms -d 2 -n ${INTER} -i $hand2 -o $affinenii -r $hand1 \
	    -t ${OUTPUT_PREFIX}0GenericAffine.mat
	antsApplyTransforms -d 2 -n ${INTER} -i $redhand2 -o $redhand2nii_affine -r $hand1 \
	    -t ${OUTPUT_PREFIX}0GenericAffine.mat
	antsApplyTransforms -d 2 -n ${INTER} -i $greenhand2 -o $greenhand2nii_affine -r $hand1 \
	    -t ${OUTPUT_PREFIX}0GenericAffine.mat
	antsApplyTransforms -d 2 -n ${INTER} -i $bluehand2 -o $bluehand2nii_affine -r $hand1 \
	    -t ${OUTPUT_PREFIX}0GenericAffine.mat
	#antsApplyTransforms -d 2 -n ${INTER} -i $yellowhand2 -o $yellowhand2nii_affine -r $hand1 \
	#    -t ${OUTPUT_PREFIX}0GenericAffine.mat
	antsApplyTransforms -d 2 -n ${INTER} -i $affinemask2 -o $affinemask2to1 -r $hand1 \
	    -t ${OUTPUT_PREFIX}0GenericAffine.mat

	antsApplyTransforms -d 2 -n ${INTER} -i $redhand1 -o $redhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	antsApplyTransforms -d 2 -n ${INTER} -i $greenhand1 -o $greenhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	antsApplyTransforms -d 2 -n ${INTER} -i $bluehand1 -o $bluehand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	#antsApplyTransforms -d 2 -n ${INTER} -i $yellowhand1 -o $yellowhand1nii -r $hand1 \
	#    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 

	antsApplyTransforms -d 2 -n ${INTER} -i $redhand1 -o $redhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	antsApplyTransforms -d 2 -n ${INTER} -i $greenhand1 -o $greenhand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	antsApplyTransforms -d 2 -n ${INTER} -i $bluehand1 -o $bluehand1nii -r $hand1 \
	    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 
	#antsApplyTransforms -d 2 -n ${INTER} -i $yellowhand1 -o $yellowhand1nii -r $hand1 \
	#    -t [${OUTPUT_PREFIX}0GenericAffine.mat,1] -t ${OUTPUT_PREFIX}1InverseWarp.nii.gz 


	#logCmd antsApplyTransforms -d 2 -o Linear[${OUTPUT_PREFIX}1InverseAffine.mat,1] -t ${OUTPUT_PREFIX}0GenericAffine.mat --verbose 1

	echo "Converting nii to png..."
	ConvertImagePixelType $redhand2nii $redhand2png 1 > /dev/null 2>&1
	ConvertImagePixelType $greenhand2nii $greenhand2png 1 > /dev/null 2>&1
	ConvertImagePixelType $bluehand2nii $bluehand2png 1 > /dev/null 2>&1
	#ConvertImagePixelType $yellowhand2nii $yellowhand2png 1 > /dev/null 2>&1

	ConvertImagePixelType $redhand2nii_affine $redhand2png_affine 1 > /dev/null 2>&1
	ConvertImagePixelType $greenhand2nii_affine $greenhand2png_affine 1 > /dev/null 2>&1
	ConvertImagePixelType $bluehand2nii_affine $bluehand2png_affine 1 > /dev/null 2>&1
	#ConvertImagePixelType $yellowhand2nii_affine $yellowhand2png_affine 1 > /dev/null 2>&1
	ConvertImagePixelType $affinemask2to1 $affinemask2to1png 1 > /dev/null 2>&1
	ConvertImagePixelType $redhand1nii $redhand1png 1 > /dev/null 2>&1
	ConvertImagePixelType $greenhand1nii $greenhand1png 1 > /dev/null 2>&1
	ConvertImagePixelType $bluehand1nii $bluehand1png 1 > /dev/null 2>&1
	#ConvertImagePixelType $yellowhand1nii $yellowhand1png 1 > /dev/null 2>&1

	echo "Combining rgb channels to color png..."
	convert $redhand2png $greenhand2png $bluehand2png -set colorspace sRGB -combine $warpedpng
	convert $redhand2png_affine $greenhand2png_affine $bluehand2png_affine -set colorspace sRGB -combine $affinepng
	convert $redhand1png $greenhand1png $bluehand1png -set colorspace sRGB -combine $invwarpedpng

	echo "Convert Warped.nii to png..."
	ConvertImagePixelType ${OUTPUT_PREFIX}Warped.nii.gz ${OUTPUT_PREFIX}Warped.png 1 > /dev/null 2>&1
	ConvertImagePixelType ${OUTPUT_PREFIX}InverseWarped.nii.gz ${OUTPUT_PREFIX}InverseWarped.png 1 > /dev/null 2>&1

	echo "Converting warped color png to nii..."
	ConvertImagePixelType $warpedpng $warpednii 1 > /dev/null 2>&1
	ConvertImagePixelType $invwarpedpng $invwarpednii 1 > /dev/null 2>&1
	echo "Creating warped grid image..."
	CreateWarpedGridImage 2 ${OUTPUT_PREFIX}1Warp.nii.gz ${OUTPUT_PREFIX}WarpedGrid.nii.gz
	echo "Creating Jacobian image..."
	CreateJacobianDeterminantImage 2 ${OUTPUT_PREFIX}1Warp.nii.gz ${OUTPUT_PREFIX}1WarpJ.nii.gz 0 1

	echo "Creating displacement vector image..."
	ConvertImage 2 ${OUTPUT_PREFIX}1Warp.nii.gz ${OUTPUT_PREFIX}_ 10 > /dev/null 2>&1
	#logCmd ConvertTransformFile 2 ${OUTPUT_PREFIX}0GenericAffine.mat ${OUTPUT_PREFIX}0GenericAffine.txt

    #fi
fi

if [ $KEEP_TMP_IMAGES -eq "0" ]; then
    echo
    #logCmd rm -f ${OUTPUT_PREFIX}*.nii.gz ${OUTPUT_PREFIX}*.mat
fi

#logCmd rm -f $r1_png $g1_png $b1_png



