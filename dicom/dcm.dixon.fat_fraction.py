#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
Read a DICOM directory and print protocol to a CSV directory

Usage:  python dicom.dixon.fat_fraction.py dixon_fat dixon_water

Example: python dicom.dixon.fat_fraction.py dixon_fat.nii.gz dixon_water.nii.gz

"""
# Copyright (c) 2008-2012 Darcy Mason
# This file is part of pydicom, released under an MIT license.
#    See the file license.txt included with this distribution, also
#    available at http://pydicom.googlecode.com

from __future__ import print_function

import os
import sys
import dicom
import magic

# check command line arguments make sense
if len(sys.argv) != 3:
    print(__doc__)
    sys.exit()

def do(cmd):
    print(">>>> %s" % (cmd))
    os.system(cmd)

fat = sys.argv[1]
water = sys.argv[2]

#dicom.read_file(fat_path, force = True)
print("")
print("Dixon fat image path: %s" % (fat))
print("Dixon water image path: %s" % (water))
#base = os.path.basename(fat_path).replace(".nii.gz","")
#do("fslsplit \"%s\" \"%s\"" % (path, base))

total = fat.replace(".nii.gz", "_total.nii.gz")
ffx = fat.replace(".nii.gz", "_fat_fraction.nii.gz")

if not os.path.exists(fat):
    print("No fat image file")
    sys.exit()

if not os.path.exists(water):
    print("No water image file")
    sys.exit()

do("fslmaths %s -add %s %s" % (fat, water, total))
do("fslmaths %s -div %s -mul 100 -thr 0 -uthr 100 %s" % (fat, total, ffx))


