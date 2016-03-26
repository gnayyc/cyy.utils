#!/bin/zsh

mkdir -p slicesdir

foreach var in FA
    echo "overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A mean_FA_skeleton 0.2 0.7 tbss_tfce_corrp_tstat1_${var}.nii.gz 0.95 1 overlay_${var} && slicer overlay_${var}.nii.gz -a slicesdir/slicer_${var}.png"
    overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A mean_FA_skeleton 0.2 0.7 tbss_tfce_corrp_tstat1_${var}.nii.gz 0.95 1 overlay_${var} && slicer overlay_${var}.nii.gz -a slicesdir/slicer_${var}.png

    echo "overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A tbss_tfce_corrp_tstat2_filled_${var}.nii.gz 0.95 1 overlay_filled_${var} && slicer overlay_filled_${var}.nii.gz -a slicesdir/slicer_filled_${var}.png"
    overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A tbss_tfce_corrp_tstat2_filled_${var}.nii.gz 0.95 1 overlay_filled_${var} && slicer overlay_filled_${var}.nii.gz -a slicesdir/slicer_filled_${var}.png

    echo "overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A mean_FA_skeleton 0.2 0.7 tbss_tfce_corrp_tstat1_${var}.nii.gz 0.95 1 overlay_${var} && slicer overlay_${var}.nii.gz -a slicesdir/slicer_${var}.png"
    overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A mean_FA_skeleton 0.2 0.7 tbss_tfce_corrp_tstat1_${var}.nii.gz 0.95 1 overlay_${var} && slicer overlay_${var}.nii.gz -a slicesdir/slicer_${var}.png

    echo "overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A tbss_tfce_corrp_tstat2_filled_${var}.nii.gz 0.95 1 overlay_filled_${var} && slicer overlay_filled_${var}.nii.gz -a slicesdir/slicer_filled_${var}.png"
    overlay 1 0 /usr/local/fsl/data/standard/MNI152_T1_1mm -A tbss_tfce_corrp_tstat2_filled_${var}.nii.gz 0.95 1 overlay_filled_${var} && slicer overlay_filled_${var}.nii.gz -a slicesdir/slicer_filled_${var}.png
end

echo "slicesdir overlay*.nii.gz"
slicesdir overlay*.nii.gz

