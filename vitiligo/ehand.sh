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

nii=${1%.*}.nii.gz
extracted=${1%.*}.extracted.png
red=${1%.*}.chR.png
green=${1%.*}.chG.png
blue=${1%.*}.chB.png
r_g=${1%.*}.r-g.nii.gz
maskrg=${1%.*}.mask.r-g.nii.gz
mask=${1%.*}.mask.nii.gz
maskpng=${1%.*}.mask.png

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

logCmd convert $1 -channel R -separate $red
logCmd convert $1 -channel G -separate $green
#logCmd convert $1 -channel B -separate $blue
logCmd ConvertImagePixelType $1 $nii 1
logCmd ImageMath 2 $r_g - $red $green

logCmd ThresholdImage 2 $r_g $maskrg Kmeans 1
logCmd ThresholdImage 2 $maskrg $mask 2 2 1 0
logCmd ImageMath 2 $mask GetLargestComponent $mask


logCmd ConvertImagePixelType $mask $maskpng 1

logCmd convert $1 $maskpng -alpha Off -compose CopyOpacity -composite $extracted
logCmd convert $extracted -flatten -fuzz 0% -fill black -opaque white $extracted

if [ $KEEP_TMP_IMAGES -eq "0" ]; then
    logCmd rm -rf ${nii} ${red} ${green} ${r_g} ${maskrg} ${mask}
fi

