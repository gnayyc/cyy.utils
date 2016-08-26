#!/bin/sh

#antsAffineInitializer 2 1.png 2.png affine.mat  30 0.5
#antsApplyTransforms -d 2 -i butterfly-15.jpg -o test.nii.gz -t butter.mat -r butterfly-3.jpg
#ConvertImagePixelType test.nii.gz ms_result.jpg 1 

antsRegistrationSyNQuick.sh -d 2 -m 1.png -f 2.png -o o -n 4
antsRegistrationSyN.sh -d 2 -m 1.png -f 2.png -o s -n 4
