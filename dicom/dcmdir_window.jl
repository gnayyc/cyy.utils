#!/usr/bin/env julia

using DICOM
using ImageFiltering

dcmDir = "."
dcmDir2 = joinpath(dcmDir, "work")
mkpath(dcmDir2)

for (i, dcmFile) in enumerate(DICOM.find_dicom_files(dcmDir))
    #println(dcmFile)
    img = DICOM.dcm_parse(joinpath(dcmDir, dcmFile))
    p = img.PixelData .* img.RescaleSlope .+ img.RescaleIntercept
    p[p .< -700] .= -1024
    p = Int.(round.(imfilter(p, Kernel.gaussian(3))))
    img.PixelData .= (p .- img.RescaleIntercept) ./ img.RescaleSlope
    DICOM.dcm_write(joinpath(dcmDir2, dcmFile), img)
end
