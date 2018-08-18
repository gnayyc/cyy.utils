#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
Read a DICOM directory and print protocol to a CSV directory

Usage:  python dicom.3echo.py dixon_3echo_file

Example: python dicom.3echo.py dixon.nii.gz

"""
# Copyright (c) 2008-2012 Darcy Mason
# This file is part of pydicom, released under an MIT license.
#    See the file license.txt included with this distribution, also
#    available at http://pydicom.googlecode.com

from __future__ import print_function

import os
import sys
import pydicom
import magic

# check command line arguments make sense
if len(sys.argv) != 2:
    print(__doc__)
    sys.exit()

def do(cmd):
    print(">>>> %s" % (cmd))
    os.system(cmd)

path = sys.argv[1]

pydicom.dcmread(path, force = True)
print("")
print("3 echo file path: %s" % (path))
base = os.path.basename(path).replace(".nii.gz","")
do("fslsplit \"%s\" \"%s\"" % (path, base))

f1 = path.replace(".nii.gz", "0000.nii.gz")
f2 = path.replace(".nii.gz", "0001.nii.gz")
f3 = path.replace(".nii.gz", "0002.nii.gz")
ip1 = path.replace(".nii.gz", "_ip1.nii.gz")
ip2 = path.replace(".nii.gz", "_ip2.nii.gz")
ipc = path.replace(".nii.gz", "_ipc.nii.gz")
op = path.replace(".nii.gz", "_op.nii.gz")
water = path.replace(".nii.gz", "_water.nii.gz")
fat = path.replace(".nii.gz", "_fat.nii.gz")
fat_fraction = path.replace(".nii.gz", "_fat_fraction.nii.gz")
fat_fraction_thr = path.replace(".nii.gz", "_fat_fraction_thr.nii.gz")

if os.path.exists(f1):
    os.rename(f1, ip1)
else:
    print("No IP1 file")
    sys.exit()

if os.path.exists(f2):
    os.rename(f2, op)
else:
    print("No OP file")
    sys.exit()

if os.path.exists(f3):
    os.rename(f3, ip2)
else:
    print("No IP2 file")
    sys.exit()

do("fslmaths %s -mul %s -sqrt %s" % (ip1, ip2, ipc))
do("fslmaths %s -add %s -div 2 %s" % (ipc, op, water))
do("fslmaths %s -sub %s -abs -div 2 %s" % (ipc, op, fat))
do("fslmaths %s -sub %s -abs -div 2 -div %s -mul 100 %s" % (ipc, op, ipc, fat_fraction))
do("fslmaths %s -sub %s -abs -div 2 -div %s -mul 100 -thr 0 -uthr 50 %s" % (ipc, op, ipc, fat_fraction_thr))


