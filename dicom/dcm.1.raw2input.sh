#!/bin/sh


r2i()
{
    r2b
    b2i
    #mri2nii
    tidy.input
}

r2b()
{
    CWD=`pwd`
    INPUT="$CWD/input"
    BIDS="$CWD/bids"
    mkdir -p "$INPUT" "$BIDS"

    if [ -n "$(ls -A $CWD/raw)" ]; then
	cd "$CWD/raw" 
	foreach s in *; 
	    if [ -d $CWD/raw/$s ]; then
		cd $CWD/raw/$s
		if [ -n "$(ls -A $CWD/raw/$s)" ]; then
		    foreach t in *; 
			if [ -d $CWD/raw/$s/$t ]; then
			    dcm2niix -b y -t y -m y -o "$BIDS" -f %i_%t_%s_%p_zzz "$CWD/raw/$s/$t" 
			    for d in `find "$CWD/raw/$s/$t" -type d`; do
				for f in `find "$d" -type f`; do
				    _f=`file -b --mime-type "$f"`
				    if [[ "x$_f" == "xapplication/dicom" ]]; then 
					echo "Found dicom file $f. Extracting info..."
					dcm2csv.py "$f" $BIDS
					break
				    else
					echo "Found non-dicom file $f. ($_f)"
				    fi 
				done
			    done
			fi
		    end
		fi
	    fi
	end
    else
	echo "No data in $CWD/raw"
    fi
    cd "$CWD"
}

b2i()
{
    CWD=`pwd`
    INPUT="$CWD/input"
    BIDS="$CWD/bids"

    cd $BIDS
    for i in *_zzz.*; do
	_TO=`echo $i | awk -v INPUT=$INPUT -F"_" '{print INPUT "/" $1 "/" $2 "/misc" }'`
	#echo _TO=$_TO
	if [ -d "$_TO" ]; then
	    echo mkdir -p "$_TO"
	    mkdir -p "$_TO"
	fi
	echo cp $i "$_TO"
	cp "$i" "$_TO"
    done
    cd "$CWD"
}

raw2mri()
{
    CWD=`pwd`
    echo "---=== raw2mri start ===---"
    if [ -n "$(ls -A $CWD/raw)" ]; then
	cd $CWD/raw; 
	foreach s in *; 
	    if [ -d $CWD/raw/$s ]; then
		cd $CWD/raw/$s
		if [ -n "$(ls -A $CWD/raw/$s)" ]; then
		    foreach t in *; 
			if [ -d $CWD/raw/$s/$t ]; then
			    if [ -d $CWD/MRI/$s/$t ]; then
				echo 
				echo "---===     processing $s/$t ===---"
				echo "$CWD/MRI/$s exists. Skipping it..."
				echo 
			    else
				echo 
				echo "---===     processing $s/$t ===---"
				echo "dicom2series $CWD/MRI/$s 0 0 $CWD/raw/$s/$t"
				echo 
				dicom2series $CWD/MRI/$s 0 0 $CWD/raw/$s/$t;
			    fi
			fi
		    end
		else
		    echo "No data in $CWD/raw/$s"
		fi
	    fi
	end
    else
	echo "No data in $CWD/raw"
    fi
    cd ${CWD}
    echo "---=== raw2mri done ===---"
}

mri2nii()
{
    CWD=`pwd`
    rm -rf $CWD/subject.txt $CWD/protocols.txt $CWD/protocol.txt
    touch $CWD/subject.txt $CWD/protocols.txt $CWD/protocol.txt
    echo "---=== Generating subject/protocol start ===---"
    if [ -n "$(ls -A $CWD/MRI)" ]; then
	cd $CWD/MRI
	foreach s in *; 
	    if [ -d $CWD/MRI/$s ];
	    then
		echo "echo $s >> $CWD/subject.txt"
		echo $s >> $CWD/subject.txt
		cd $CWD/MRI/$s
		foreach t in *; 
		    if [ -d $CWD/MRI/$s/$t ]; then
			cd $CWD/MRI/$s/$t
			/bin/ls | grep "^00" | sed 's/^[0-9]*_*[0-9]*_*//' | sed 's/_*$//' | grep -v Report | grep -v localizer | grep -v pl_T2 >> $CWD/protocols.txt
		    fi
		end
	    fi
	end
    else
	echo "No data in $CWD/MRI"
    fi
    cd ${CWD}
    sort protocols.txt | uniq >> protocol.txt
    echo 
    echo "---=== Generating subject/protocol done ===---"

    echo 
    echo "---=== dicom2nii start ===---"
    echo "dicom2nii \"none\" $CWD/subject.txt $CWD/protocol.txt $CWD/MRI $CWD/input misc"
    echo 
    dicom2nii "none" $CWD/subject.txt $CWD/protocol.txt $CWD/MRI $CWD/input misc
    cd $CWD
    echo "---=== dicom2nii done ===---"
}

tidy.input ()
{
    CWD=`pwd`
    echo 
    echo "---=== Tidying subject/protocol start ===---"
    echo 
    if [ -n "$(ls -A $CWD/input)" ]; then
	cd $CWD/input
	foreach s in *;
	    if [ -d $CWD/input/$s ];
	    then
		cd $CWD/input/$s
		if [ -n "$(ls -A $CWD/input/$s)" ]; then
		    foreach t in *; 
			if [ -d $CWD/input/$s/$t ];
			then
			    mkdir -p $CWD/input/$s/$t/BOLD
			    mkdir -p $CWD/input/$s/$t/MRI
			    if ls $CWD/input/$s/$t/misc/*[Tt][12]*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*[Tt][12]*.nii.gz $CWD/input/$s/$t/MRI
			    fi
			    if ls $CWD/input/$s/$t/misc/*[Mm][Pp][Rr][Aa][Gg][Ee]*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*[Mm][Pp][Rr][Aa][Gg][Ee]*.nii.gz $CWD/input/$s/$t/MRI
			    fi
			    if ls $CWD/input/$s/$t/misc/*[Ss][Pp][Gg][Rr]*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*[Ss][Pp][Gg][Rr]*.nii.gz $CWD/input/$s/$t/MRI
			    fi
			    if ls $CWD/input/$s/$t/misc/*[Ff][Ll][Aa][Ii][Rr]*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*[Ff][Ll][Aa][Ii][Rr]*.nii.gz $CWD/input/$s/$t/MRI
			    fi
			    if ls $CWD/input/$s/$t/misc/*_????_00??_*[Dd][Tt][Ii]* 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*_????_00??_*[Dd][Tt][Ii]* $CWD/input/$s/$t/MRI
			    fi
			    if ls $CWD/input/$s/$t/misc/*_????_00??_*3[Dd]* 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*_????_00??_*3[Dd]* $CWD/input/$s/$t/MRI
			    fi
			    if ls $CWD/input/$s/$t/MRI/*PA*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/MRI/*PA*.nii.gz $CWD/input/$s/$t/misc
			    fi
			    if ls $CWD/input/$s/$t/misc/*rsbold*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/misc/*rsbold*.nii.gz $CWD/input/$s/$t/BOLD
			    fi
			    cd $CWD/input/$s/$t/MRI
			    if ls $CWD/input/$s/$t/MRI/*b0*.nii.gz 1> /dev/null 2>&1; then
				for i in *b0*.nii.gz; do 
				    cp ~/bin/ants/b0x9.bval "$CWD/input/$s/$t/MRI/${i%.nii.gz}.bval" ; 
				    cp ~/bin/ants/b0x9.bvec "$CWD/input/$s/$t/MRI/${i%.nii.gz}.bvec" ; 
				done
			    fi
			    if ls $CWD/input/$s/$t/MRI/*C_*.nii.gz 1> /dev/null 2>&1; then
				mv $CWD/input/$s/$t/MRI/*C_*.nii.gz $CWD/input/$s/$t/misc
			    fi
			fi
		    end
		else
		    echo "No data in $CWD/input/$s/$t"
		fi
	    fi
	end
    else
	echo "No subjects in input directory"
    fi
    cd $CWD
    echo "---=== Tidying subject/protocol done ===---"

}
