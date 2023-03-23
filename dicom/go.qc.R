#!/usr/bin/env Rscript

system('dcmdir2csv.py')
x = data.table::fread("info.csv")
y = unique(x[!is.na(StudyDate),.(PatientID,StudyDate,StudyTime,InstitutionName,ManufacturerModelName,Manufacturer,SeriesDescription,SliceThickness)], by = c("PatientID", "StudyDate"))[order(PatientID, StudyDate)]
#y[,n_Exam := seq_len(.N), by=.(PatientID)][,N_Exam:= .N, by=.(PatientID)]
y[,n_Exam := data.table::rowid(PatientID)][,N_Exam:= .N, by=.(PatientID)]
z = y[,.(PatientID,StudyDate,StudyTime,n_Exam,N_Exam,InstitutionName,ManufacturerModelName,Manufacturer,SeriesDescription,SliceThickness)]

data.table::fwrite(z, "GO_CT_list.csv")

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
