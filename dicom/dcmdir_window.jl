#!/usr/bin/env julia

using DICOM

dcmDir = "."
dcmDir2 = joinpath(dcmDir, "work")
mkpath(dcmDir2)

for (i, dcmFile) in enumerate(DICOM.find_dicom_files(dcmDir))
    #println(dcmFile)
    img = DICOM.dcm_parse(joinpath(dcmDir, dcmFile))
    img.PixelData[img.PixelData .< -300] .= -2048
    DICOM.dcm_write(joinpath(dcmDir2, dcmFile), img)
end
