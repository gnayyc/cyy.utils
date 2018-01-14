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
SMOOTH=1
GRAD=0 # Gradient image
CANNY=0 # Canny edge image
FFT=1
WAVE=1
#CH_all=( 'sRGB' 'LAB' 'LUV' 'YUV' 'XYZ' 'HSV' 'HSL' 'CMYK' )
CH_all=( 'sRGB' 'LAB' 'XYZ' 'HSV' 'HSL' 'CMYK' )
CHs=( 'sRGB' 'LAB' 'CMYK')

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
hand_phase=${OPRE}_hand_phase.png
hand_phase_smooth=${OPRE}_hand_phase_smooth.nii.gz
hand_canny=${OPRE}_hand_canny.nii.gz
mask=${OPRE}_mask.nii.gz
mask0=${OPRE}_mask0.nii.gz
mask_chull=${OPRE}_mask_chull.nii.gz
mask_sub=${OPRE}_mask_sub.nii.gz
mask_sub255=${OPRE}_mask_sub255.nii.gz
mask_canny=${OPRE}_mask_canny.nii.gz
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

echo 
echo ">>>>>>>> [${SID}] Extracting hand from green background <<<<<<<<"
if [[ ! -d ${ODIR} ]]; then
    echo "  - Directory \"${ODIR}\" not exists. Making it!"
    mkdir -p ${ODIR}
    if [[ ! -d ${ODIR} ]]; then
	echo mkdir ${ODIR} failed! Exiting!
	exit 0
    fi
fi

    # get each RGB channel
    if [[ ! -f ${OPRE}_sRGB0.png || ${FORCE} -eq 1 ]]; then
	echo "  - Separating sRGB/LAB/LUV/CMYK channels..."
	for CH in ${CH_all[@]}; do
	    convert $1 -colorspace ${CH} -separate ${OPRE}_${CH}%d.png
	done
    fi
    # get R-G image
    #r_g=${OPRE}_r-g.nii.gz
    #if [[ ! -f ${r_g} || ! -f ${OPRE}_CMYK4.nii.gz ]]; then
    if [[ ! -f ${OPRE}_CMYK4.nii.gz ]]; then
	# imagemath works better
	#ImageMath 2 $r_g - $red $green
	ImageMath 2 ${OPRE}_CMYK4.nii.gz Neg ${OPRE}_CMYK0.png
    fi

    if [[ ! -f ${maskpng} || ${FORCE} -eq 1 ]]; then
	echo "  - Generating hand mask..."
	# Using kmeans to get threshold from R-G image
	#ThresholdImage 2 $r_g $maskrg Kmeans 1 1 > /dev/null 2>&1
	ThresholdImage 2 ${OPRE}_CMYK4.nii.gz ${OPRE}_th_CMYK.nii.gz Kmeans 1 1 > /dev/null 2>&1
	# Convert value 2 to 1
	#ThresholdImage 2 $maskrg $mask 2 2 1 0
	# Try use CMYK
	#ThresholdImage 2 ${OPRE}_th_CMYK.nii.gz ${OPRE}_mask_CMYK.nii.gz 2 2 1 0
	ThresholdImage 2 ${OPRE}_th_CMYK.nii.gz $mask 2 2 1 0
	# Get largest component (hand)
	ImageMath 2 $mask ME $mask 2
	ImageMath 2 $mask GetLargestComponent $mask
	ImageMath 2 $mask MD $mask 2
	ImageMath 2 $mask FillHoles $mask 2
	ImageMath 2 $mask MD $mask 4
	ImageMath 2 $mask ME $mask 4
	cp $mask $mask0
	# try remove wrist
	W=`convert $1 -format "%w" info:`
	H=`convert $1 -format "%h" info:`
	if [[ $W -gt $H ]]; then
	    ((F1=W/10))
	    ((F2=W/8))
	    ((F3=W/20))
	else
	    ((F1=H/10))
	    ((F2=H/8))
	    ((F3=H/20))
	fi

	echo "  - Stripping palm/fingers..."
	#echo ImageMath 2 ${OPRE}1palmwrist.nii.gz ME $mask0 $F1
	ImageMath 2 ${OPRE}1palmwrist.nii.gz ME $mask0 $F1
	ImageMath 2 ${OPRE}1palmwrist.nii.gz MD ${OPRE}1palmwrist.nii.gz $F1 # remove fingers
	ImageMath 2 ${OPRE}1palmwrist.nii.gz m $mask0 ${OPRE}1palmwrist.nii.gz # in mask

	#echo ImageMath 2 ${OPRE}2palm.nii.gz ME $mask0 $F2
	ImageMath 2 ${OPRE}2palm.nii.gz ME $mask0 $F2
	ImageMath 2 ${OPRE}2palm.nii.gz MD ${OPRE}2palm.nii.gz $F2 # palm
	ImageMath 2 ${OPRE}2palm.nii.gz m $mask0 ${OPRE}2palm.nii.gz # in mask

	ImageMath 2 ${OPRE}3wrist.nii.gz - $mask0 ${OPRE}2palm.nii.gz
	ImageMath 2 ${OPRE}3wrist.nii.gz m ${OPRE}3wrist.nii.gz ${OPRE}1palmwrist.nii.gz
	ImageMath 2 ${OPRE}3wrist.nii.gz GetLargestComponent ${OPRE}3wrist.nii.gz
	#ImageMath 2 ${OPRE}3wrist.nii.gz ME ${OPRE}3wrist.nii.gz $F3
	#ImageMath 2 ${OPRE}3wrist.nii.gz MD ${OPRE}3wrist.nii.gz $F3
	#ImageMath 2 ${OPRE}3wrist.nii.gz * ${OPRE}1palmwrist.nii.gz ${OPRE}2palm.nii.gz
	ImageMath 2 ${OPRE}_hand_stripped.nii.gz - $mask0 ${OPRE}3wrist.nii.gz
	ImageMath 2 $mask GetLargestComponent ${OPRE}_hand_stripped.nii.gz 
	ImageMath 2 $mask MD $mask 50
	ImageMath 2 $mask ME $mask 50
	ImageMath 2 $mask m $mask0 $mask
	ImageMath 2 ${OPRE}4digits.nii.gz - $mask ${OPRE}2palm.nii.gz
	ImageMath 2 ${OPRE}4digits.nii.gz m $mask ${OPRE}4digits.nii.gz
	ImageMath 2 ${OPRE}4digits.nii.gz ME ${OPRE}4digits.nii.gz 4
	ImageMath 2 ${OPRE}4digits.nii.gz MD ${OPRE}4digits.nii.gz 4

	ImageMath 2 ${OPRE}4digits_me.nii.gz ME ${OPRE}4digits.nii.gz 20
	ImageMath 2 ${OPRE}2palm_me.nii.gz ME ${OPRE}2palm.nii.gz 20 
	ImageMath 2 ${OPRE}5label.nii.gz + $mask ${OPRE}2palm_me.nii.gz
	ImageMath 2 ${OPRE}5label.nii.gz + ${OPRE}5label.nii.gz ${OPRE}4digits.nii.gz
	ImageMath 2 ${OPRE}5label.nii.gz + ${OPRE}5label.nii.gz ${OPRE}4digits_me.nii.gz


	ConvertImagePixelType $mask $maskpng 1 > /dev/null 2>&1
	ConvertImagePixelType $mask $maskpng 1 > /dev/null 2>&1
	#ConvertImagePixelType ${OPRE}1palmwrist.nii.gz ${OPRE}1palmwrist.png 1 > /dev/null 2>&1
	#ConvertImagePixelType ${OPRE}2palm.nii.gz ${OPRE}2palm.png 1 > /dev/null 2>&1
	#ConvertImagePixelType ${OPRE}3wrist.nii.gz ${OPRE}3wrist.png 1 > /dev/null 2>&1


	if [ $CHULL -eq 1 ]; then
	    echo "  - Generating convex hull mask..."
	    chull.py ${mask} ${mask_chull}
	    ImageMath 2 ${mask_sub} - ${mask_chull} ${mask}
	    ImageMath 2 ${mask_sub255} m ${mask_sub} 255
	    #logCmd ImageMath 2 ${mask_chull_sub} - ${mask_chull} ${mask}
	    # convert mask from nii to png
	    ConvertImagePixelType $mask_chull $maskchullpng 1 > /dev/null 2>&1
	fi
    fi
    if [[ ! -f ${hand} || ${FORCE} -eq 1 ]]; then
	echo "  - Extract hand using mask and fill bg with black..."
	convert $1 $maskpng -alpha Off -compose CopyOpacity -composite png:- |\
	    convert - -flatten -fuzz 0% -fill black -opaque white ${OPRE}_hand.png
	for CH in ${CHs[@]}; do
	    for i in 0 1 2 3; do
		if [[ -f ${OPRE}_${CH}${i}.png ]]; then
		    convert ${OPRE}_${CH}${i}.png $maskpng -alpha Off -compose CopyOpacity -composite png:- |\
			convert - -flatten -fuzz 0% -fill black -opaque white ${OPRE}_hand_${CH}${i}.png
		fi
	    done
	done



	if [ $CHULL -eq 1 ]; then
	    convert ${OPRE}_hand.png -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite ${OPRE}_hand_chull.png
	    for CH in ${CHs[@]}; do
		for i in 0 1 2 3; do
		    if [[ -f ${OPRE}_hand_${CH}${i}.png ]]; then
			convert ${OPRE}_hand_${CH}${i}.png -fill white -opaque black $maskchullpng -alpha off -compose CopyOpacity -composite ${OPRE}_hand_${CH}${i}_chull.png
		    fi
		done
	    done
	fi

	if [[ $PAD -eq 1 ]]; then
	    echo "  - Start padding..."
	    convert -bordercolor black -border 256 ${OPRE}_hand.png ${OPRE}_hand.png
	    for CH in ${CHs[@]}; do
		for i in 0 1 2 3; do
		    if [[ -f ${OPRE}_hand_${CH}${i}.png ]]; then
			convert -bordercolor black -border 256 ${OPRE}_hand_${CH}${i}.png ${OPRE}_hand_${CH}${i}.png
		    fi
		done
	    done
	    ImageMath 2 $mask PadImage $mask +256
	    ImageMath 2 ${OPRE}_label.nii.gz PadImage ${OPRE}5label.nii.gz +256
	    #ImageMath 2 $maskrg PadImage $maskrg +256
	    if [[ $CHULL -eq 1 ]]; then
		convert -bordercolor black -border 256 ${OPRE}_hand_chull.png ${OPRE}_hand_chull.png
		for CH in ${CHs[@]}; do
		    for i in 0 1 2 3; do
			if [[ -f ${OPRE}_hand_${CH}${i}.png ]]; then
			    convert -bordercolor black -border 256 ${OPRE}_hand_${CH}${i}_chull.png ${OPRE}_hand_${CH}${i}_chull.png
			fi
		    done
		done
		convert -bordercolor black -border 256 $maskpng $maskpng 
		convert -bordercolor black -border 256 $maskchullpng $maskchullpng 
		ImageMath 2 $mask_chull PadImage $mask_chull +256
		ImageMath 2 $mask_sub PadImage $mask_sub +256
		ImageMath 2 $mask_sub255 PadImage $mask_sub255 +256
	    fi
	fi


	echo "  - Converting png to nii..."
	ConvertImagePixelType ${OPRE}_hand.png ${OPRE}_hand.nii.gz 1 > /dev/null 2>&1
	CopyImageHeaderInformation ${OPRE}_hand.nii.gz $mask $mask 1 1 1
	CopyImageHeaderInformation ${OPRE}_hand.nii.gz ${OPRE}_label.nii.gz ${OPRE}_label.nii.gz 1 1 1
	for CH in ${CHs[@]}; do
	    for i in 0 1 2 3; do
		if [[ -f ${OPRE}_hand_${CH}${i}.png ]]; then
		    ConvertImagePixelType ${OPRE}_hand_${CH}${i}.png ${OPRE}_hand_${CH}${i}.nii.gz 1 > /dev/null 2>&1
		fi
	    done
	done
	echo "  - N4 Bias Field Correction hand.nii.gz..."
	N4BiasFieldCorrection -d 2 -b [200] -c [50x50x40x30,0.00000001] -i ${OPRE}_hand.nii.gz -o ${OPRE}_hand_N4.nii.gz \
	    -r 0 -s 4 --verbose 1 > /dev/null 2>&1
	ImageMath 2 ${OPRE}_hand_N4_neg.nii.gz Neg ${OPRE}_hand_N4.nii.gz
	ImageMath 2 ${OPRE}_hand_N4_neg.nii.gz m ${OPRE}_hand_N4_neg.nii.gz ${mask}

    fi
	#if [[ ! -f $hand_smooth || $FORCE -eq 1 ]]; then
	#    echo "  - Smoothing..."
	#    R=10
	#    SmoothImage 2 $handnii $R $hand_smooth
	#    SmoothImage 2 $redhandnii $R $redhand_smooth
	#    SmoothImage 2 $greenhandnii $R $greenhand_smooth
	#    SmoothImage 2 $bluehandnii $R $bluehand_smooth
	#    SmoothImage 2 $yellowhandnii $R $yellowhand_smooth
	#fi

	GRAD=0
	if [[ $GRAD -eq 1 ]]; then
	    if [[ ! -f $hand_grad || $FORCE -eq 1 ]]; then
		echo "  - Calculating gradient..."
		R=20
		ImageMath 2 ${OPRE}_hand_grad.nii.gz Grade ${OPRE}_hand.nii.gz 1 > /dev/null 2>&1
		for CH in ${CHs[@]}; do
		    for i in 0 1 2 3; do
			if [[ -f ${OPRE}_hand_${CH}${i}.png ]]; then
			    ImageMath 2 ${OPRE}_hand_${CH}${i}_grad.nii.gz Grade ${OPRE}_hand_${CH}${i}.nii.gz 1 > /dev/null 2>&1
			fi
		    done
		done
	    fi
	fi

	CANNY=1
	if [[ $CANNY -eq 1 ]]; then
	    if [[ ! -f $hand_canny || $FORCE -eq 1 ]]; then
		echo "  - Calculating Canny edge..."
		R=20
		ImageMath 2 ${OPRE}_hand_canny.nii.gz Canny ${OPRE}_hand.nii.gz $R
		for CH in ${CHs[@]}; do
		    for i in 0 1 2 3; do
			if [[ -f ${OPRE}_hand_${CH}${i}.png ]]; then
			    ImageMath 2 ${OPRE}_hand_${CH}${i}_canny.nii.gz Canny ${OPRE}_hand_${CH}${i}.nii.gz $R > /dev/null 2>&1
			fi
		    done
		done
	    fi
	fi

	if [[ $FFT -eq 1 ]]; then
	    if [[ ! -f $hand_phase || $FORCE -eq 1 ]]; then
		echo "  - Producing FFT phase image..."
		#echo "convert $hand -fft +depth \( -clone 1 -write png:- \) NULL: | convert -size `identify -format "%wx%h" $hand` xc:gray1 - -ift $hand_phase"
		convert $hand -fft +depth \( -clone 1 -write png:- \) NULL: |\
		    convert -size `identify -format "%wx%h" $hand` xc:gray1 - -ift png:- |\
		    convert - $maskpng -alpha Off -compose CopyOpacity -composite png:- |\
		    convert - -flatten -fuzz 0% -fill black -opaque white $hand_phase
		SmoothImage 2 $hand_phase 10 $hand_phase_smooth
	    fi
	fi

	WAVE=1
	if [[ $WAVE -eq 1 ]]; then
	    if [[ ! -f ${OPRE}_hand_wavelet.png || $FORCE -eq 1 ]]; then
		echo "  - Producing Wavelet Denoise image..."
		convert $hand -wavelet-denoise 5%x.5 ${OPRE}_hand_wavelet.png
		echo "  - N4 Bias Field Correction wavelet..."
		N4BiasFieldCorrection -d 2 -b [200] -c [50x50x40x30,0.00000001] -i ${OPRE}_hand_wavelet.png -o ${OPRE}_hand_wavelet_N4.nii.gz \
		    -r 0 -s 4 --verbose 1 > /dev/null 2>&1
		ImageMath 2 ${OPRE}_hand_wavelet_N4_neg.nii.gz Neg ${OPRE}_hand_wavelet_N4.nii.gz
		ImageMath 2 ${OPRE}_hand_wavelet_N4_neg.nii.gz m ${OPRE}_hand_wavelet_N4_neg.nii.gz ${mask}
	    fi
	fi

	#SmoothImage 2 $hand

	#if [[ $CHULL -eq 1 ]]; then
	#    ConvertImagePixelType $hand $handnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $redhand $redhandnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $greenhand $greenhandnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $bluehand $bluehandnii 1 > /dev/null 2>&1
	#    ConvertImagePixelType $yellowhand $yellowhandnii 1 > /dev/null 2>&1
	#fi 



    echo ">>>>>>>> END <<<<<<<<" 

#    if [ $KEEP_TMP_IMAGES -eq "0" ]; then
#	#logCmd rm -f ${nii} ${red} ${green} ${blue} ${r_g} ${maskrg} ${mask}
#	logCmd rm -f ${ODIR}/*.nii.gz
#    fi


