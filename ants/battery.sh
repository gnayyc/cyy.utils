#!/usr/bin/env sh

source `which battery.rc.sh`

export FROM_DIR=${1}
export TO_DIR=${2}
export ID="${3}"
export SID="${3}_${4}"
export S_DIR="${3}/${4}"
export I_DIR="$FROM_DIR/$S_DIR"
export O_DIR="$TO_DIR/$S_DIR"
export W_DIR="/Volumes/RamDisk/ants.tmp/output/$S_DIR"
echo "    SID   = ${SID}"
echo "    S_DIR = ${S_DIR}"
echo "    I_DIR = $I_DIR"
echo "    O_DIR = $O_DIR"
echo "    W_DIR = $W_DIR"

battery.dti.sh ${1} ${3} ${4}
battery.t1.sh ${1} ${2} ${3} ${4}
battery.mm.sh ${1} ${2} ${3} ${4}
battery.label.sh ${1} ${2} ${3} ${4}

#if [ ! -d $TO_DIR/${ID} ]; then
#    echo mkdir -p $TO_DIR/${ID}
#    mkdir -p $TO_DIR/${ID}
#fi

#echo "mv $W_DIR $TO_DIR/${ID}"
#mv $W_DIR $TO_DIR/${ID}

