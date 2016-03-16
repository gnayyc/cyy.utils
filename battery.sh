#!/usr/bin/env sh

export SID="${1}_${2}"
export S_DIR="${1}/${2}"
export I_DIR="$FROM_DIR/$S_DIR"
export O_DIR="$TO_DIR/$S_DIR"
echo "    SID   = ${1}_${2}"
echo "    S_DIR = ${1}/${2}"
echo "    I_DIR = $FROM_DIR/$S_DIR"
echo "    O_DIR = $TO_DIR/$S_DIR"

export TMP_DATA_DIR="/Volumes/RamDisk/data"
export TMP_FROM_DIR="$TMP_DATA_DIR/input"
export TMP_TO_DIR="$TMP_DATA_DIR/output"
export TMP_I_DIR="$TMP_DATA_DIR/input/$S_DIR"
export TMP_O_DIR="$TMP_DATA_DIR/output/$S_DIR"

echo "    TMP_FROM_DIR = $TMP_DATA_DIR/input"
echo "    TMP_TO_DIR = $TMP_DATA_DIR/output"
echo "    TMP_I_DIR = $TMP_DATA_DIR/input/$S_DIR"
echo "    TMP_O_DIR = $TMP_DATA_DIR/output/$S_DIR"

mkdir -p $TMP_I_DIR
cp -Rp $I_DIR/* $TMP_I_DIR
mkdir -p $TMP_O_DIR

battery.t1.sh ${1} ${2}
#battery.mm.sh ${1} ${2}
#battery.label.sh ${1} ${2}

mkdir -p $O_DIR
mv $TMP_TO_DIR/* $O_DIR
