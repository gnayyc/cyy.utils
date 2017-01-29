#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)

## Collect arguments
args <- commandArgs(TRUE)

## Default setting when no arguments passed
if(length(args) == 0) {
        BIDS = "."
} else {
        BIDS = args[1]
}

cat("BIDS directory == ", BIDS, "\n")

csv_files =
    BIDS %>%
    dir(pattern = "*.csv")


info = tibble()
for (f in csv_files)
{
    info = 
	read_csv(f, col_types = cols(PatientSex = "c"), trim_ws = T) %>% 
	mutate_all(funs(as.character)) %>% 
	bind_rows(info)
}

demo = 
    info %>%
    expand(PatientID, PatientsBirthDate, PatientSex, StudyDate, StudyTime)

protocol = 
    info %>%
    expand(
    Modality,
    ManufacturerModelName,
    Manufacturer,
    MagneticFieldStrength,
    MRAcquisitionType,
    SeriesDescription,
    RepetitionTime,
    EchoTime,
    InversionTime,
    FlipAngle,
    Rows,
    Columns,
    SliceThickness,
    SpacingBetweenSlices,
    NumberOfAverages,
    PixelSpacingRows,
    PixelSpacingColumns)


save(info, demo, protocol, file = "info.rdata")
write_csv(info, "info.csv")
write_csv(demo, "demo.csv")
write_csv(protocol, "protocol.csv")

