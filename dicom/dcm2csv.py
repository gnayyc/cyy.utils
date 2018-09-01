#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
Read a DICOM file and print protocol to a csv file

Usage:  python dcm2csv.py imagefile directory

Example: python dcm2csv.py 1.dcm .

"""
# Copyright (c) 2008-2012 Darcy Mason
# This file is part of pydicom, released under an MIT license.
#    See the file license.txt included with this distribution, also
#    available at http://pydicom.googlecode.com

from __future__ import print_function

import os
import sys
import pydicom

# check command line arguments make sense
if len(sys.argv) != 3:
    print(__doc__)
    sys.exit()

# read the file
filename = sys.argv[1]
dcm = pydicom.dcmread(filename)

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
    dcm.get("PatientBirthDate", "").strip(),
    str(dcm.get("PatientName", "")).strip(),
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

csvdir = sys.argv[2]
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

with open(csvfile, 'w+') as fd:
    fd.write(header + "\n")
    fd.write(data + "\n")


