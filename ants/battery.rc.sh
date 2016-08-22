#!/usr/bin/env sh

if [[ ! -f ${T0_DIR}/T_template0.nii.gz ]]; then
    echo "No specified tempalte. Using MNI-2009c template."
    export T0_DIR=/Volumes/Data/Brain.MRI.templates/MNI-ICBM152-2009c
fi
export T_DIR=/Volumes/Ramdisk/data/ants.template
#export T0_DIR=/Volumes/Data/ants_templates/ADNI
#export T_DIR=/Volumes/Ramdisk/data/template/ADNI
#export T0_DIR=/Volumes/Data/ants_templates/OASIS-30_Atropos_template
#export T_DIR=/Volumes/Ramdisk/data/template/OASIS-30_Atropos_template

if [[ ! -d $T_DIR ]];
  then
    echo "The template directory \"$T_DIR\" does not exist. Making it from ${T0_DIR}."
    mkdir -p $T_DIR
    cp -Rp $T0_DIR/* $T_DIR 
  fi
export T_T1=${T_DIR}/T_template0.nii.gz
export T_MASK=${T_DIR}/T_template0_BrainCerebellumExtractionMask.nii.gz
export T_PROB=${T_DIR}/T_template0_BrainCerebellumProbabilityMask.nii.gz
export T_T1BRAIN=${T_DIR}/T_template0_BrainCerebellum.nii.gz
export T_PRIORS_DIR=${T_DIR}/Priors

T_DEPENDENCIES=( $T_T1 $T_MASK $T_PROB $T_T1BRAIN $T_PRIORS_DIR )

for D in ${T_DEPENDENCIES[@]};
  do
    if [[ ! -s ${D} ]];
      then
        echo "Error:  we can't find the $D template"
        exit
      fi
  done


echo "====== [Environments] ======"
echo "    T_T1 = ${T_DIR}/T_template0.nii.gz"
echo "    T_MASK = ${T_DIR}/T_template0_BrainCerebellumExtractionMask.nii.gz"
echo "    T_PROB = ${T_DIR}/T_template0_BrainCerebellumProbabilityMask.nii.gz"
echo "    T_T1BRAIN = ${T_DIR}/T_template0_BrainCerebellum.nii.gz"
echo "    T_PRIORS_DIR = ${T_DIR}/Priors"

export W_DIR="/Volumes/RamDisk/ants.tmp/output/$S_DIR"
echo "    W_DIR = /Volumes/RamDisk/data/output/$S_DIR"

export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10
echo "    ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS = ${ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS}"
echo "============================"
echo 

