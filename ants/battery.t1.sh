#!/usr/bin/env sh

. `which battery.rc.sh`

FROM_DIR=${1}
TO_DIR=${2}
SID="${3}_${4}"
S_DIR="${3}/${4}"
I_DIR="$FROM_DIR/$S_DIR"
O_DIR="$TO_DIR/$S_DIR"

echo FROM_DIR=$FROM_DIR
echo TO_DIR=$TO_DIR
echo SID=$SID
echo S_DIR=$S_DIR
echo I_DIR=$I_DIR
echo O_DIR=$O_DIR
echo 

if [ -f "${O_DIR}/${SID}_BrainSegmentationTiledMosaic.png" ]; then
    echo "      antsCorticalThickness.sh for ${O_DIR} done"
elif [ -f "${W_DIR}/${SID}_BrainSegmentationTiledMosaic.png" ]; then
    echo "      antsCorticalThickness.sh for ${W_DIR} done"

else
    T1=`find ${I_DIR}/MRI -maxdepth 1 -name "*T1*" \
	-o -name "*MPRAGE*" \
	-o -name "*SPGR*" \
	-o -name "*t1*" \
	-o -name "*mprage*" \
	-o -name "*spgr*" |\
	head -1`

    if [ -f ${T1} ]; then
	${ANTSPATH}/antsCorticalThickness.sh -d 3 \
	    -a ${T1} \
	    -e ${T_T1} \
	    -m ${T_PROB} \
	    -f ${T_MASK} \
	    -p ${T_PRIORS_DIR}/priors%d.nii.gz \
	    -t ${T_T1BRAIN} \
	    -k 1 \
	    -n 3 \
	    -w 0.25 \
	    -q 1 \
	    -o ${O_DIR}/${SID}_
    fi
fi

