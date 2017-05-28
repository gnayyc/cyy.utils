#!/bin/sh

# Example
# $ xid.sh 0123456_name IMG_0001.jpg

# set id to the Artist Tag
id=$(echo ${1} | awk -F"_" '{printf("%07d", $1)}')
name=$(echo ${1} | awk -F"_" '{print $2}')
if [ -z "$name" ]; then
    id_name=${id}
else
    id_name=${id}_${name}
fi

file="$2"

xid() {
    #if [[ $(file -b "${2}" | awk '{print $1}') == "JPEG" ]]; then
	echo Writing \"${1}\" into Artist tag of "${2}" 
	exiftool -r -overwrite_original "-Artist=${id_name}" "${2}"
	exiftool -r "-Artist=${id_name}" '-Filename<ED_${artist}/${datetimeoriginal#;DateFmt("%Y%m%d")}/ED_${artist}_${datetimeoriginal#;DateFmt("%Y%m%d_%H%M%S")}.%le' "${2}"
    #fi

}

xid "${id_name}" "${file}"

#xid () {
#
#    for d in *; do
#	if [ -d "$d" ]; then
#	    (cd -- "$d" && xid)
#	fi
#	if [[ $(file -b "${d}" | awk '{print $1}') == "JPEG" ]]; then
#	    setid "${id_name}" "${d}"
#	fi
#    done
#}

#if [ -d "${file}" ]; then
#    (cd -- "${file}"; xid; cd -)
#elif [ -f "${file}" ]; then
#    if [[ $(file -b "${file}" | awk '{print $1}') == "JPEG" ]]; then
#	setid "${id_name}" "${file}"
#    fi
#fi

