#!/bin/sh

# t-test for two groups
echo "######## - randomise"
#echo "$FSLDIR/bin/randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n 1000 --T2 -V"
$FSLDIR/bin/randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n 1000 --T2 -V


echo "Use fslview to see the result:"
echo "# Raw T-stats:"
echo "fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1_FA -l Red-Yellow -b 3,6 tbss_tstat2_FA -l Blue-Lightblue -b 3,6"
echo "# Now showing Cluster threshold result loads correct p-value image at 1-p, so here its .05"
echo "fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.7 tbss_tfce_corrp_tstat1 -l Red-Yellow -b .95,1"
echo "# Using tbss_fill:"
echo "#  tbss_fill tbss_tfce_corrp_tstat1_FA 0.95 mean_FA tbss_fill_FA"
echo "#  fslview mean_FA -b 0,.6 mean_FA_skeleton -l Green -b .2,.7 tbss_fill_FA -l Red-Yellow"

