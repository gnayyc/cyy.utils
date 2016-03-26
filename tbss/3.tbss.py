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

if len(sys.argv) != 3: 
    print "Usage:", sys.argv[0], "group1 group2"
    sys.exit()
for i in sys.argv[1:]:
    if not os.path.exists(i): 
        print i, "does not exist"
        sys.exit()
g = sys.argv[1:]
g.sort()

### Environmental setting
top_dir = os.getcwd()
TBSS_dir = os.path.join(top_dir, 'TBSS.'+g[0]+'.'+g[1])
if not os.path.exists(TBSS_dir): os.makedirs(TBSS_dir)

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

print "########"
print "######## TBSS [", g[0], "] vs. [", g[1], "]"
t = time.time()
if not os.path.exists(os.path.join(TBSS_dir,'.tbss.done')): 
    print "########"
    print "######## TBSS"
    print "######## - copy data from group_dirs into TBSS_dir"
    if not os.path.exists(os.path.join(TBSS_dir, '.tbss.data')):
        for d in g:
            d = os.path.join(top_dir, d)
            for f in os.listdir(d):
                shutil.copy(os.path.join(d,f), TBSS_dir)

        # move each vectors into corresponding folders
        print "########   - move data into each vector directory"
        for i in vectors[1:]:
            d = os.path.join(TBSS_dir, i)
            if not os.path.exists(d): os.makedirs(d)
            for f in glob.glob(os.path.join(TBSS_dir,'*'+i+'*.nii.gz')):
                os.rename(f, os.path.join(d, os.path.basename(f)))
        open(os.path.join(TBSS_dir,'.tbss.data'),'w').close
        print "########   - %.2f mins"% ((time.time()-t)/60,)


    # make FA skeleton first
    if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.done')): 
        os.chdir(TBSS_dir)
        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.tbss1.done')): 
            print "######## - tbss1"
            print ' '.join([tbss1, '*.nii.gz'])
            #print
            commands.getoutput(' '.join([tbss1, '*.nii.gz']))
            open(os.path.join(TBSS_dir,'.tbss.fa.tbss1.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)
        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.tbss2.done')): 
            print "######## - tbss2"
            print ' '.join([tbss2, '-T'])
            #print
            commands.getoutput(' '.join([tbss2, '-T']))
            open(os.path.join(TBSS_dir,'.tbss.fa.tbss2.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)
        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.tbss3.done')): 
            print "######## - tbss3"
            print ' '.join([tbss3, '-S'])
            #print
            commands.getoutput(' '.join([tbss3, '-S']))
            open(os.path.join(TBSS_dir,'.tbss.fa.tbss3.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)
        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.tbss4.done')): 
            print "######## - tbss4"
            print ' '.join([tbss4, '0.2'])
            #print
            commands.getoutput(' '.join([tbss4, '0.2']))
            open(os.path.join(TBSS_dir,'.tbss.fa.tbss4.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)
        #if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.imglob.done')): 
        #    print "######## - imglob"
        #    print ' '.join([imglob, '*_FA.*'])
        #    #print
        #    commands.getoutput(' '.join([imglob, '*_FA.*']))
        #    open(os.path.join(TBSS_dir,'.tbss.fa.imglob.done'),'w').close
        #    print "########   - %.2f mins"% ((time.time()-t)/60,)
        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.fa.ttest2.done')): 
            # get grup names (group number got to be 2)
            files = os.listdir(os.path.join(TBSS_dir,'origdata'))
            files.sort()
            for f in files: print f
            groups = [x.split("_")[0] for x in files]
            groups.sort()
            i = groups.count(groups[0])
            j = groups.count(groups[-1])
                 
            os.chdir(os.path.join(TBSS_dir, 'stats'))

            # t-test for two groups
            print "######## - ttest2"
            print ' '.join([ttest2, 'design', str(i), str(j)])
            #print
            commands.getoutput(' '.join([ttest2, 'design', str(i), str(j)]))
            open(os.path.join(TBSS_dir,'.tbss.fa.ttest2.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)

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
            os.rename('tbss_tfce_corrp_tstat1.nii.gz', 'tbss_tfce_corrp_tstat1_FA.nii.gz')
            os.rename('tbss_tfce_corrp_tstat2.nii.gz', 'tbss_tfce_corrp_tstat2_FA.nii.gz')
            os.rename('tbss_tfce_p_tstat1.nii.gz', 'tbss_tfce_p_tstat1_FA.nii.gz')
            os.rename('tbss_tfce_p_tstat2.nii.gz', 'tbss_tfce_p_tstat2_FA.nii.gz')
            os.rename('tbss_tstat1.nii.gz', 'tbss_tstat1_FA.nii.gz')
            os.rename('tbss_tstat2.nii.gz', 'tbss_tstat2_FA.nii.gz')
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

    # then non_FA
    for v in vectors[1:]:
        # mv v_* FA_*
        if not os.path.exists(os.path.join(TBSS_dir,v+'/.rename.done')): 
            for f in os.listdir(os.path.join(TBSS_dir,v)):
                os.chdir(os.path.join(TBSS_dir,v))
                des = re.sub(v+'.nii.gz', 'FA.nii.gz', f)
                os.rename(f, des)
            open(os.path.join(TBSS_dir,v+'/.rename.done'),'w').close

        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.'+v+'.done')): 
            os.chdir(TBSS_dir)
            print "######## - tbss_non_FA:", v
            print ' '.join([tbss_non_FA, v])
            print
            commands.getoutput(' '.join([tbss_non_FA, v]))
            open(os.path.join(TBSS_dir,'.tbss.'+v+'.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)

        if not os.path.exists(os.path.join(TBSS_dir,'.tbss.'+v+'.randomise.done')): 
            os.chdir(os.path.join(TBSS_dir,'stats'))
            print "######## - tbss_non_FA: randomise", v
            print ' '.join([randomise, '-i', 'all_'+v+'_skeletonised', '-o',
                'tbss', '-m', 'mean_FA_skeleton_mask', '-d', 'design.mat',
                '-t', 'design.con', '-n', '500', '--T2', '-V'])
            #print
            commands.getoutput(' '.join([randomise, '-i', 'all_'+v+'_skeletonised', '-o',
                'tbss', '-m', 'mean_FA_skeleton_mask', '-d', 'design.mat',
                '-t', 'design.con', '-n', '500', '--T2', '-V']))
            os.rename('tbss_tfce_corrp_tstat1.nii.gz',
                'tbss_tfce_corrp_tstat1_'+v+'.nii.gz')
            os.rename('tbss_tfce_corrp_tstat2.nii.gz',
                'tbss_tfce_corrp_tstat2_'+v+'.nii.gz')
            os.rename('tbss_tfce_p_tstat1.nii.gz',
                'tbss_tfce_p_tstat1_'+v+'.nii.gz')
            os.rename('tbss_tfce_p_tstat2.nii.gz',
                'tbss_tfce_p_tstat2_'+v+'.nii.gz')
            os.rename('tbss_tstat1.nii.gz', 'tbss_tstat1_'+v+'.nii.gz')
            os.rename('tbss_tstat2.nii.gz', 'tbss_tstat2_'+v+'.nii.gz')
            open(os.path.join(TBSS_dir,'.tbss.'+v+'.randomise.done'),'w').close
            print "########   - %.2f mins"% ((time.time()-t)/60,)
            print "Use fslview to see the result:"
            print 'fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1_'+v+' -l Red-Yellow -b 3,6 tbss_tstat2_'+v+' -l Blue-Lightblue -b 3,6'
            print
            print "# Raw T-stats:"
            print "fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1_"+v+" -l Red-Yellow -b 3,6 tbss_tstat2_"+v+" -l Blue-Lightblue -b 3,6"
            print "# Cluster threshold result  loads correct p-value image at 1-p, so here its .05"
            print "fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.7 tbss_tfce_corrp_tstat1_"+v+" -l Red-Yellow -b .95,1"
            print "# Using group-wise tempalte:"
            print "fslview mean_FA -l Green -b 0.2,0.7 tbss_tfce_corrp_tstat1_"+v+" -l Red-Yellow -b .95,1"

            
    open(os.path.join(TBSS_dir,'.tbss.done'),'w').close


os.chdir(top_dir)

