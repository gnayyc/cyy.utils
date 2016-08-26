#!/bin/sh

nii=${1%.*}.nii.gz
extracted=${1%.*}.extracted.png
red=${1%.*}.chR.png
red_nii=${1%.*}.chR.nii.gz
green=${1%.*}.chG.png
blue=${1%.*}.chB.png
r_g=${1%.*}.r-g.nii.gz
maskrg=${1%.*}.mask.r-g.nii.gz
mask=${1%.*}.mask.nii.gz
maskpng=${1%.*}.mask.png

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
logCmd convert $1 -channel B -separate $blue
logCmd ConvertImagePixelType $1 $nii 1
logCmd ImageMath 2 $r_g - $red $green

logCmd ThresholdImage 2 $r_g $maskrg Kmeans 1
logCmd ThresholdImage 2 $maskrg $mask 2 2 1 0
logCmd ImageMath 2 $mask GetLargestComponent $mask


logCmd ConvertImagePixelType $mask $maskpng 1

logCmd convert $1 $maskpng -alpha Off -compose CopyOpacity -composite $extracted
logCmd convert $extracted -flatten -fuzz 0% -fill black -opaque white $extracted
