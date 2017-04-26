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
import dicom
import magic

# check command line arguments make sense
if len(sys.argv) != 2:
    print(__doc__)
    sys.exit()

path = sys.argv[1]

def dcm2csv(filename, csvdir):
    dcm = dicom.read_file(filename, force=True)

    header = ",".join([
        "PatientID",
        "PatientAge",
        "PatientSex",
        "PatientsBirthDate",
        "PatientName",
        "InstitutionName",
        "StudyDate",
        "StudyTime",
        "SeriesNumber",
        "Modality",
        "ManufacturerModelName",
        "Manufacturer",
        "MagneticFieldStrength",
        "MRAcquisitionType",
        "SeriesDescription",
        #"SequenceName",
        "RepetitionTime",
        "EchoTime",
        "InversionTime",
        "FlipAngle",
        "Rows",
        "Columns",
        "SliceThickness",
        "SpacingBetweenSlices",
        "NumberOfAverages",
        "PixelSpacingRows",
        "PixelSpacingColumns",
        "Filename"
        ])

    data = ",".join(str(x) for x in 
        [
        dcm.get("PatientID", "").strip(), 
        dcm.get("PatientAge", "").strip(), 
        dcm.get("PatientSex", "").strip(), 
        dcm.get("PatientsBirthDate", "").strip(),
        dcm.get("PatientName", "").strip(),
        dcm.get("InstitutionName", "").strip(),
        dcm.get("StudyDate", "").strip(),
        dcm.get("StudyTime", "").strip(),
        dcm.get("SeriesNumber", ""),
        dcm.get("Modality", "").strip().strip(),
        dcm.get("ManufacturerModelName", "").strip(),
        dcm.get("Manufacturer", "").strip(),
        dcm.get("MagneticFieldStrength", ""),
        dcm.get("MRAcquisitionType", "").strip(),
        dcm.get("SeriesDescription", "").strip(),
        #dcm.get("SequenceName", "").strip(),
        dcm.get("RepetitionTime", ""),
        dcm.get("EchoTime", ""),
        dcm.get("InversionTime", ""),
        dcm.get("FlipAngle", ""),
        dcm.get("Rows", ""),
        dcm.get("Columns", ""),
        dcm.get("SliceThickness", ""),
        dcm.get("SpacingBetweenSlices", ""),
        dcm.get("NumberOfAverages", ""),
        dcm.get("PixelSpacing", [0,0])[0],
        dcm.get("PixelSpacing", [0,0])[1],
        filename
        #dcm.PixelSpacing[0],
        #dcm.PixelSpacing[1]
        ])

    desc = "_".join(dcm.get("SeriesDescription", "").split()).replace("/","_")
    desc = desc.replace('\*',"_")
    desc = ''.join([i if ord(i) < 128 else '_' for i in desc])

    csvfile = os.path.join(sys.argv[2] ,
        "_".join(str(x) for x in [
        dcm.get("PatientID", ""), 
        dcm.get("StudyDate", "") + "%06d" % float(dcm.get("StudyTime", "")),
        dcm.get("SeriesNumber", ""),
        desc,
        "zzz.csv"
            ])) 


    ifile = os.path.join(csvdir, "info.csv")
    if not os.path.isfile(ifile): 
        ifd=open(ifile, 'w+')
        ifd.write(header + "\n")
    else:
        ifd=open(ifile, 'a')
    ifd.write(data + "\n")
    ifd.close()

    try:
        fd=open(csvfile, 'w+')
        fd.write(header + "\n")
        fd.write(data + "\n")
        fd.close()
    except:
        print("Error creating file (%s)..." % csvfile)
        #sys.exit()

dicom.read_file(path, force = True)
print("")
print(path)
base = os.path.basename(path).replace(".nii.gz","")
print("fslsplit \"%s\" \"%s\"" % (path, base))
os.system("fslsplit \"%s\" \"%s\"" % (path, base))
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

cmd = "fslmaths %s -mul %s -sqrt %s" % (ip1, ip2, ipc)
print(cmd)
os.system(cmd)

cmd = "fslmaths %s -sub %s %s" % (ipc, op, fat)
print(cmd)
os.system(cmd)

cmd = "fslmaths %s -sub %s -div 2 -div %s -mul 100 %s" % (ipc, op, ipc, fat_fraction)
print(cmd)
os.system(cmd)


