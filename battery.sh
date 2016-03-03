#!/usr/bin/env sh

export SID="${1}_${2}"
export S_DIR="${1}/${2}"
export I_DIR="$FROM_DIR/$S_DIR"
export O_DIR="$TO_DIR/$S_DIR"
echo "    SID   = ${1}_${2}"
echo "    S_DIR = ${1}/${2}"
echo "    I_DIR = $FROM_DIR/$S_DIR"
echo "    O_DIR = $TO_DIR/$S_DIR"


battery.t1.sh ${1} ${2}
battery.mm.sh ${1} ${2}
