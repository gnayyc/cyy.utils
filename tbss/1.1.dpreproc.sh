#!/bin/sh

T=/usr/local/tractor/bin/tractor

if [ "$#" -eq 1 ]; then
    # BetIntensityThreshold:0.3 MaskingMethod:bet 
    #$T dpreproc Interactive:false DicomDirectory:$1 
    $T dpreproc Interactive:false BetIntensityThreshold:0.3 MaskingMethod:bet DicomDirectory:$1 
else
    $T dpreproc Interactive:false 
fi
#$T gradcheck
$T gradrotate # Only if you previously used RotateGradients:true 
$T tensorfit Method:fsl
#$T bedpost

