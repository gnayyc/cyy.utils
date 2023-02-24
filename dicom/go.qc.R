#!/usr/bin/env Rscript

system('dcmdir2csv.py')
x = data.table::fread("info.csv")

cat("==== min(SliceThickness) ====\n")
x[!is.na(SliceThickness)][,.(SliceThickness = min(SliceThickness)), by = .(PatientID, StudyDate)][order(PatientID, StudyDate)]
cat("====\n")


cat("==== min(SliceThickness) ====\n")
x[!is.na(SliceThickness)][,.(SliceThickness = min(SliceThickness)), by = .(PatientID, StudyDate)][order(StudyDate)]
cat("====\n")

data.table::fwrite(x[!is.na(SliceThickness)][,.(SliceThickness = min(SliceThickness)), by = .(PatientID, StudyDate)][order(StudyDate)], "min.csv")

cat("==== min(SliceThickness) > 1 ====\n")
x[!is.na(SliceThickness)][,.(SliceThickness = min(SliceThickness)), by = .(PatientID, StudyDate)][order(PatientID, StudyDate)][SliceThickness > 1]
cat("====\n")
