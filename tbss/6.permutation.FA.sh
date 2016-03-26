#!/bin/zsh

N=1000

foreach var in FA
    echo /usr/local/fsl/bin/randomise -i all_${var}_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n $N --T2 -V -D
    /usr/local/fsl/bin/randomise -i all_${var}_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n $N --T2 -V -D
    mv tbss_tfce_corrp_tstat1.nii.gz tbss_tfce_corrp_tstat1_${var}.nii.gz
    mv tbss_tfce_corrp_tstat2.nii.gz tbss_tfce_corrp_tstat2_${var}.nii.gz
    mv tbss_tfce_p_tstat1.nii.gz tbss_tfce_p_tstat1_${var}.nii.gz
    mv tbss_tfce_p_tstat2.nii.gz tbss_tfce_p_tstat2_${var}.nii.gz
    mv tbss_tstat1.nii.gz tbss_tstat1_${var}.nii.gz
    mv tbss_tstat2.nii.gz tbss_tstat2_${var}.nii.gz
    echo "tbss_fill tbss_tfce_corrp_tstat1_${var} 0.949 mean_FA tbss_tfce_corrp_tstat1_filled_${var}"
    tbss_fill tbss_tfce_corrp_tstat1_${var} 0.949 mean_FA tbss_tfce_corrp_tstat1_filled_${var}
    echo "tbss_fill tbss_tfce_corrp_tstat2_${var} 0.949 mean_FA tbss_tfce_corrp_tstat2_filled_${var}"
    tbss_fill tbss_tfce_corrp_tstat2_${var} 0.949 mean_FA tbss_tfce_corrp_tstat2_filled_${var}
end
