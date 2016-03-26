#!/bin/sh

__pwd="`pwd`"


#### dir structures
## 0001/SE1
## 0001/SE2
## 0001/SE3
## 0002/SE1
## 0002/SE2
## 0002/SE3

for S in *; do
    if [ -d "${S}" ]; then
	echo "----------=============== $S ===============----------"
	cd "${__pwd}/${S}"
	/usr/local/tractor/bin/tractor dicomsort
	echo "$S done:"
	echo "----------=============== $S ===============----------"
	echo
	cd "$__pwd"
    fi 
done
