#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)

## Collect arguments
args <- commandArgs(TRUE)

## Default setting when no arguments passed
if(length(args) == 0) {
    info_csv = file.path(".","info.csv")
} else {
    info_csv = args[1]
    if (dir.exists(info_csv))
	info_csv = file.path(info_csv, "info.csv")
    if (!file.exists(info_csv))
	stop(paste(info_csv, "does not exits!"))
}

info_dir = dirname(info_csv)

cat("Info csv == ", info_csv, "\n")
cat("Info dir == ", info_dir, "\n")
#cat("Info directory == ", info_dir, "\n")

#csv_files =
#    BIDS %>%
#    dir(pattern = "*.csv")
#
#if (length(csv_files) == 0)
#{
#    cat("No csv files!\nQuitting!\n")
#    quit()
#}

info = 
    info_csv %>%
    read_csv()

cat("Analyzing demo...\n")
demo = 
    info %>%
    distinct(PatientID, PatientsBirthDate, PatientSex, StudyDate, StudyTime)
write_csv(demo, file.path(info_dir, "demo.csv"))

cat("Analyzing protocol...\n")
protocol = 
    info %>%
    distinct(
	Modality,
	ManufacturerModelName,
	Manufacturer,
	MagneticFieldStrength,
	MRAcquisitionType,
	SeriesDescription,
	RepetitionTime,
	EchoTime,
	InversionTime,
	FlipAngle)#,
	#Rows,
	#Columns,
	#SliceThickness,
	#SpacingBetweenSlices,
	#NumberOfAverages,
	#PixelSpacingRows,
	#PixelSpacingColumns)

write_csv(protocol, file.path(info_dir, "protocol.csv"))

save(info, demo, protocol, file = file.path(info_dir, "info.rdata"))

