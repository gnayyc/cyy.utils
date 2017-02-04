#!/usr/bin/env zsh

function qa() {
    S_DIR=$SUBJECTS_DIR
    export SUBJECTS_DIR=$PWD
    export SUBJ="`find . -type d -mindepth 1 -maxdepth 1| grep -v fs.stats| grep -v average | grep -v qdec| grep -v QA | tr '\n' ' ' | sed "s/.\///g"`"
    eval recon_checker -s $SUBJ
    #eval recon_checker -snaps-only -snaps-overwrite -s $SUBJ
    export SUBJECTS_DIR=$S_DIR
}

function fs.stats() {
    S_DIR=$SUBJECTS_DIR
    SUBJECTS_DIR=$PWD
    STATS_DIR=./fs.stats
    mkdir -p ${STATS_DIR}
    SUBJ="`find . -type d -mindepth 1 -maxdepth 1| grep -v fs.stats| grep -v average | grep -v qdec| grep -v QA | tr '\n' ' ' | sed "s/.\///g"`"
    echo "subjects: $SUBJ"
    eval aparcstats2table --skip -d comma --hemi=rh --meas area --tablefile ${STATS_DIR}/rh.aparc.area.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh --meas volume --tablefile ${STATS_DIR}/rh.aparc.vol.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh --meas thickness --tablefile ${STATS_DIR}/rh.aparc.thickness.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh --meas thicknessstd --tablefile ${STATS_DIR}/rh.aparc.thicknessstd.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh --meas meancurv --tablefile ${STATS_DIR}/rh.aparc.meancurv.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh --meas area --tablefile ${STATS_DIR}/lh.aparc.area.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh --meas volume --tablefile ${STATS_DIR}/lh.aparc.vol.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh --meas thickness --tablefile ${STATS_DIR}/lh.aparc.thickness.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh --meas thicknessstd --tablefile ${STATS_DIR}/lh.aparc.thicknessstd.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh --meas meancurv --tablefile ${STATS_DIR}/lh.aparc.meancurv.csv --subjects $SUBJ

    eval aparcstats2table --skip -d comma --hemi=rh -p aparc.a2009s --meas area --tablefile ${STATS_DIR}/rh.a2009s.area.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh -p aparc.a2009s --meas volume --tablefile ${STATS_DIR}/rh.a2009s.vol.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh -p aparc.a2009s --meas thickness --tablefile ${STATS_DIR}/rh.a2009s.thickness.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh -p aparc.a2009s --meas thicknessstd --tablefile ${STATS_DIR}/rh.a2009s.thicknessstd.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=rh -p aparc.a2009s --meas meancurv --tablefile ${STATS_DIR}/rh.a2009s.meancurv.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh -p aparc.a2009s --meas area --tablefile ${STATS_DIR}/lh.a2009s.area.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh -p aparc.a2009s --meas volume --tablefile ${STATS_DIR}/lh.a2009s.vol.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh -p aparc.a2009s --meas thickness --tablefile ${STATS_DIR}/lh.a2009s.thickness.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh -p aparc.a2009s --meas thicknessstd --tablefile ${STATS_DIR}/lh.a2009s.thicknessstd.csv --subjects $SUBJ
    eval aparcstats2table --skip -d comma --hemi=lh -p aparc.a2009s --meas meancurv --tablefile ${STATS_DIR}/lh.a2009s.meancurv.csv --subjects $SUBJ

    eval asegstats2table --skip -d comma --meas volume --tablefile ${STATS_DIR}/aseg.vol.csv --subjects $SUBJ
    eval asegstats2table --skip -d comma --meas mean --tablefile ${STATS_DIR}/aseg.mean.csv --subjects $SUBJ
    eval asegstats2table --skip -d comma --meas std --tablefile ${STATS_DIR}/aseg.std.csv --subjects $SUBJ
    eval asegstats2table --skip -d comma --stats wmparc.stats --meas volume --tablefile ${STATS_DIR}/wm.vol.csv --subjects $SUBJ
    eval asegstats2table --skip -d comma --stats wmparc.stats --meas mean --tablefile ${STATS_DIR}/wm.mean.csv --subjects $SUBJ
    eval asegstats2table --skip -d comma --stats wmparc.stats --meas std --tablefile ${STATS_DIR}/wm.std.csv --subjects $SUBJ

    SUBJ=(`find . -type d -mindepth 1 -maxdepth 1| grep -v fs.stats| grep -v average | grep -v qdec| grep -v QA | sed "s/.\///g"`)
    echo
    echo "subjects: $SUBJ"
    echo
    for S in $SUBJ; do
	for H in rh lh; do
	    if [[ ! -f $S/label/$H.lobes.annot ]]; then
		echo 
		echo "mri_annotation2label --sd . --subject $S --hemi $H --lobesStrict lobes"
		mri_annotation2label --sd . --subject $S --hemi $H --lobesStrict lobes
	    fi
	    #if [[ ! -f ${STATS_DIR}/$S.$H.lobes.csv ]]; then
		echo 
		echo "mris_anatomical_stats -a $S/label/$H.lobes.annot -f ${STATS_DIR}/$S.$H.lobes.csv $S $H"
		mris_anatomical_stats -a $S/label/$H.lobes.annot -f ${STATS_DIR}/$S.$H.lobes.csv $S $H
	    #fi
	done
    done
    fs.aseg.R
    export SUBJECTS_DIR=$S_DIR
}

alias l2a="mris_label2annot --sd ."
alias a2l="mri_annotation2label --sd ."
alias tksurfer="env SUBJECTS_DIR=. tksurfer"
alias fs.="export SUBJECTS_DIR=\$PWD"
alias fv='freeview'

qa
fs.stats
