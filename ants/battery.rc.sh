#!/usr/bin/env sh

export T0_DIR=/Volumes/Data/ants_templates/ADNI
export T_DIR=/Volumes/Ramdisk/data/template/ADNI
if [[ ! -d $T_DIR ]];
  then
    echo "The template directory \"$T_DIR\" does not exist. Making it."
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

