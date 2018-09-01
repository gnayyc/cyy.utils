#!/usr/bin/env Rscript

library(oro.dicom)
library(tidyverse)

filenames = list.files(".", "*.dcm", ignore.case = T)

nfiles <- length(filenames)
nch <- nchar(as.character(nfiles))
headers <- images <- vector("list", nfiles)
names(images) <- names(headers) <- filenames
cat(" ", nfiles, "files to be processed by readDICOM()", fill = TRUE)
tpb <- txtProgressBar(min = 0, max = nfiles, style = 3)

for (i in 1:nfiles) {
	setTxtProgressBar(tpb, i)
    dcm <- readDICOMFile(filenames[i])
    #images[[i]] <- dcm$img
    headers[[i]] <- dcm$hdr
}
close(tpb)

picked = c(
    "PatientID", "PatientsAge", "PatientsSex", "PatientsBirthDate", "PatientsName",
    "InstitutionName",
    "StudyDate",
    "StudyTime",
    "SeriesNumber",
    "Modality",
    "ManufacturersModelName",
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
    "PixelSpacing", #"PixelSpacingRows", "PixelSpacingColumns",
    "Filename"
    )
h = dicomTable(headers) %>% 
    gather("key", "value", -`0010-0020-PatientID`, -`0008-0020-StudyDate`) %>% 
    mutate(key = str_replace(key, "^\\w*-\\w*-", "")) %>% 
    set_names(c("StudyDate", "PatientID", "key", "value")) %>%
    filter(key%in% picked) %>% 
    spread(key = key, value = value) %>%
    separate(PixelSpacing, c("PixelSpacingRows","PixelSpacingColumns"), sep=" ") %>%
    rename(PatientAge = PatientsAge,
	PatientSex = PatientsSex,
	#PatientBirthDate = PatientsBirthDate,
	PatientName = PatientsName
    )

write_csv(h, "info.csv")
