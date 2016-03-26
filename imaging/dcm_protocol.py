#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
Read a DICOM file and print protocol for publication.

Usage:  python dcm_protocol.py imagefile [-v]

-v (optional): Verbose mode, prints all DICOM data elements

Without the -v option, a few of the most common dicom file
data elements are printed: some info about the patient and about
the image.

"""
# Copyright (c) 2008-2012 Darcy Mason
# This file is part of pydicom, released under an MIT license.
#    See the file license.txt included with this distribution, also
#    available at http://pydicom.googlecode.com

from __future__ import print_function

import sys
import dicom

# check command line arguments make sense
if not 1 < len(sys.argv) < 4:
    print(__doc__)
    sys.exit()

# read the file
filename = sys.argv[1]
dcm = dicom.read_file(filename)

# Verbose mode:
if len(sys.argv) == 3:
    if sys.argv[2] == "-v":  # user asked for all info
        print(dcm)
    else:  # unknown command argument
        print(__doc__)
    sys.exit()

# Normal mode:
print("Filename..........:", filename)
pat_name = dcm.PatientName
display_name = pat_name.family_name + ", " + pat_name.given_name
print("Patient name......:", display_name, "@"+ dcm.InstitutionName)
#print("Institution Name.:", dcm.InstitutionName)
try:
    print("Patient id,age,sex:", 
            ",".join([dcm.PatientID, dcm.PatientAge, dcm.PatientSex]))
except:
    try:
        print("Patient id,age,sex:", 
                ",".join([dcm.PatientID, "N/A", dcm.PatientSex]))
    except:
        pass
print("Modality..........:", dcm.PatientID + "_" + dcm.StudyDate + "," +
        dcm.Modality.strip()+ 
    "," + dcm.ManufacturerModelName + "," + dcm.Manufacturer)
print("Study Date (Time).:", dcm.StudyDate, "("+dcm.StudyTime+")")
#print("Model Name.......:", dcm.ManufacturerModelName)
#print(display_name, dcm.PatientID, dcm.Modality, dcm.StudyDate, dcm.ManufacturerModelName)

if dcm.Modality == "MR":
    output = (
            "%sT %s (%s): %s %s%s, TR = %s ms, TE = %s ms, %sflip angle = %s°, "
            "FOV = %s x %s mm, slice thickness = %s mm, contiguous %s mm "
            "sections, %s x %s matrix, NEX = %s, voxel size = %s x %s x %s mm"
            #"\n\n(contiguous mm sections could be reconstructed, should be "
            #"determined by the differences between Image Position 0020,0032)\n"
            )
    print("Protocol..........:", output % (dcm.MagneticFieldStrength,
                dcm.ManufacturerModelName,
                dcm.Manufacturer,
                dcm.MRAcquisitionType,
                dcm.SeriesDescription,
                " ("+ dcm.SequenceName + ")" if hasattr(dcm, "SequenceName") 
                    else "", 
                dcm.RepetitionTime, 
                dcm.EchoTime, 
                "TI = "+ dcm.InversionTime + " ms, " if hasattr(dcm,
                "InversionTIme") else "", 
                dcm.FlipAngle,
                round(dcm.Columns * float(dcm.PixelSpacing[1]), 0), #FOV
                round(dcm.Rows * float(dcm.PixelSpacing[0]), 0), #FOV
                round(dcm.SliceThickness, 1),
                round(dcm.SliceThickness, 1),
                #dcm.SpacingBetweenSlices, 
                dcm.Rows,
                dcm.Columns, 
                dcm.NumberOfAverages,
                round(float(dcm.PixelSpacing[0]), 2),
                round(float(dcm.PixelSpacing[1]), 2),
                round(dcm.SliceThickness, 1)))
if dcm.Modality == "CT":
    output = (
            "\n%sT %s: %s%s, TR = %s ms, TE = %s ms, flip angle = %s°, "
            "FOV = %s x %s mm, slice thickness = %s mm, contiguous %s mm "
            "sections, %s x %s matrix, NEX = %s, voxel size = %s x %s x %s mm"
            "\n\n(contiguous mm sections might have been reconstructed, should"
            "be determined by the differences btwn Image Position (0020,0032)"
            "\n"
            )
    print("Protocol..........:", output % (dcm.MagneticFieldStrength,
                dcm.ManufacturerModelName,
                dcm.SeriesDescription,
                " ("+ dcm.SequenceName + ")" if hasattr(dcm, "SequenceName") 
                    else "", 
                dcm.RepetitionTime, 
                dcm.EchoTime, 
                dcm.FlipAngle,
                round(dcm.Columns * float(dcm.PixelSpacing[1]), 0), #FOV
                round(dcm.Rows * float(dcm.PixelSpacing[0]), 0), #FOV
                round(dcm.SliceThickness, 1),
                round(dcm.SliceThickness, 1),
                #dcm.SpacingBetweenSlices, 
                dcm.Rows,
                dcm.Columns, 
                dcm.NumberOfAverages,
                round(float(dcm.PixelSpacing[0]), 2),
                round(float(dcm.PixelSpacing[1]), 2),
                round(dcm.SliceThickness, 1)))

print()
