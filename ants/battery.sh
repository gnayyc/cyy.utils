#!/usr/bin/env sh

source `which battery.rc.sh`

export FROM_DIR=${1}
export TO_DIR=${2}
export ID="${3}"
export SID="${3}_${4}"
export S_DIR="${1}/${2}"
export I_DIR="$FROM_DIR/$S_DIR"
export O_DIR="$TO_DIR/$S_DIR"
export W_DIR="/Volumes/RamDisk/ants.tmp/output/$S_DIR"
echo "    SID   = ${1}_${2}"
echo "    S_DIR = ${1}/${2}"
echo "    I_DIR = $FROM_DIR/$S_DIR"
echo "    O_DIR = $TO_DIR/$S_DIR"
echo "    W_DIR = /Volumes/RamDisk/data/output/$S_DIR"

battery.t1.sh ${1} ${2} ${3} ${4}
battery.mm.sh ${1} ${2} ${3} ${4}
battery.label.sh ${1} ${2} ${3} ${4}

#if [ ! -d $TO_DIR/${ID} ]; then
#    echo mkdir -p $TO_DIR/${ID}
#    mkdir -p $TO_DIR/${ID}
#fi

#echo "mv $W_DIR $TO_DIR/${ID}"
#mv $W_DIR $TO_DIR/${ID}

