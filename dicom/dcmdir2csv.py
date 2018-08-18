#!/usr/bin/env python
#!/usr/bin/env /usr/local/bin/python2
# -*- coding: utf-8 -*-


"""
Read a DICOM directory and print protocol to a CSV directory

Usage:  python dcmdir2csv.py [dcm_diretory] [csv_directory]

Example: python dcmdir2csv.py raw bids

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
if len(sys.argv) > 3:
    print(__doc__)
    sys.exit()

if len(sys.argv) > 1:
    if os.path.isdir(sys.argv[1]):
        dcm_dir = sys.argv[1]
    else:
        dcm_dir = "."
else:
    dcm_dir = "."

if len(sys.argv) == 3:
    csv_dir = sys.argv[2]
    if os.path.isdir(csv_dir):
        print("csv_dir = %s" % csv_dir)
    else:
        try:
            print("Making directory: %s" % csv_dir)
            os.mkdir(csv_dir)
        except:
            csv_dir = "."
else:
    csv_dir = "."

def dcm2csv(filename, csvdir):
    with pydicom.dcmread(filename, force=True) as dcm:
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

        desc = "_".join(dcm.get("SeriesDescription", "").split()).replace("/","_")
        desc = desc.replace('\*',"_")
        desc = ''.join([i if ord(i) < 128 else '_' for i in desc])

        #csvfile = os.path.join(sys.argv[2] ,
        #    "_".join(str(x) for x in [
        #    dcm.get("PatientID", ""), 
        #    dcm.get("StudyDate", "") + "%06d" % float(dcm.get("StudyTime", "")),
        #    dcm.get("SeriesNumber", ""),
        #    desc,
        #    "zzz.csv"
        #        ])) 


        ifile = os.path.join(csvdir, "info.csv")
        if not os.path.isfile(ifile): 
            ifd=open(ifile, 'w+')
            ifd.write(header + "\n")
        else:
            ifd=open(ifile, 'a')
        ifd.write(data + "\n")
        ifd.close()


for root, dirs, files in os.walk(dcm_dir):
    print("")
    print("[Scanning dicom directory: %s]" % (root))
    for file in files:
        path = os.path.join(root, file)
        try:
            print("")
            print(path)
            dcm2csv(path, csv_dir)
            break
        except InvalidDicomError:
            # not a dicom, try next
            pass
