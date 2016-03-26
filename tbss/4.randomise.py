#!/usr/bin/env python
# -*- coding: utf-8 -*-

## do TBSS analysis between two groups
## g1/g1_s1_dti_FA.nii.gz
## g1/g1_s1_dti_L1.nii.gz
## g1/g1_s1_dti_L2.nii.gz
## g1/g1_s2_dti_FA.nii.gz
## g1/g1_s2_dti_L1.nii.gz
## g1/g1_s2_dti_L2.nii.gz
## g2/g2_s3_dti_FA.nii.gz
## g2/g2_s3_dti_L1.nii.gz
## g2/g2_s3_dti_L2.nii.gz
## g2/g2_s4_dti_FA.nii.gz
## g2/g2_s4_dti_L1.nii.gz
## g2/g2_s4_dti_L2.nii.gz

import os, string
import sys
import stat
import glob
import shutil
import re
import commands
import time

### Environmental setting
top_dir = os.getcwd()

dcm2nii = '/usr/local/bin/dcm2nii'
fsl_dir = "/usr/local/fsl"
bet = os.path.join(fsl_dir, "bin/bet")
eddy_correct = os.path.join(fsl_dir, "bin/eddy_correct")
dtifit = os.path.join(fsl_dir, "bin/dtifit")
tbss1 = os.path.join(fsl_dir, "bin/tbss_1_preproc")
tbss2 = os.path.join(fsl_dir, "bin/tbss_2_reg")
tbss3 = os.path.join(fsl_dir, "bin/tbss_3_postreg")
tbss4 = os.path.join(fsl_dir, "bin/tbss_4_prestats")
imglob = os.path.join(fsl_dir, "bin/imglob")
ttest2 = os.path.join(fsl_dir, "bin/design_ttest2")
randomise = os.path.join(fsl_dir, "bin/randomise")
tbss_non_FA = os.path.join(fsl_dir, "bin/tbss_non_FA")
#/usr/local/fsl/bin/tbss_fill
#/usr/local/fsl/bin/tbss_skeleton
#/usr/local/fsl/bin/tbss_sym
#/usr/local/fsl/bin/tbss_deproject

vectors = ["FA", "L1", "L2", "L3", "V1", "V2", "V3", "MD", "MO", "S0", "sse"]

t = time.time()
if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.randomise.done')): 
    os.chdir(os.path.join(TBSS_dir, 'stats'))

    # t-test for two groups
    print "######## - randomise"
    print ' '.join([randomise, '-i', 'all_FA_skeletonised', '-o',
        'tbss', '-m', 'mean_FA_skeleton_mask', '-d', 'design.mat',
        '-t', 'design.con', '-n', '500', '--T2', '-V'])
    print commands.getoutput(' '.join([randomise, '-i', 'all_FA_skeletonised', '-o',
        'tbss', '-m', 'mean_FA_skeleton_mask', '-d', 'design.mat',
        '-t', 'design.con', '-n', '500', '--T2', '-V']))

    stats_files = ['tbss_tfce_corrp_tstat1', 'tbss_tfce_corrp_tstat2',
            'tbss_tfce_p_tstat1', 'tbss_tfce_p_tstat2', 'tbss_tstat1',
            'tbss_tstat2']
    for s in stats_files[1:]:
        os.rename(s+'.nii.gz', s+'_FA.nii.gz')
    open(os.path.join(TBSS_dir,'.tbss.fa.randomise.done'),'w').close
    print "########   - %.2f mins"% ((time.time()-t)/60,)
    print
    print "Use fslview to see the result:"
    print "# Raw T-stats:"
    print "fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1_FA -l Red-Yellow -b 3,6 tbss_tstat2_FA -l Blue-Lightblue -b 3,6"
    print "# Cluster threshold result  loads correct p-value image at 1-p, so here its .05"
    print "fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.7 tbss_tfce_corrp_tstat1_FA -l Red-Yellow -b .95,1"
    print "# Using tbss_fill:"
    print "#  tbss_fill tbss_tfce_corrp_tstat1_FA 0.95 mean_FA tbss_fill_FA"
    print "#  fslview mean_FA -b 0,.6 mean_FA_skeleton -l Green -b .2,.7 tbss_fill_FA -l Red-Yellow"
    print

os.chdir(top_dir)

