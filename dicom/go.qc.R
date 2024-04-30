#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(googlesheets4)

# 
gs4_auth(email = T)
.x1 = range_speedread('https://docs.google.com/spreadsheets/d/18WMkBRJE0t3cLcfxSQhDCv0LaSTefzJUBJuAetWIlk4/edit#gid=417997842', sheet=3, range="A:C")
.x2 = range_speedread('https://docs.google.com/spreadsheets/d/18WMkBRJE0t3cLcfxSQhDCv0LaSTefzJUBJuAetWIlk4/edit#gid=417997842', sheet=4, range="A:C")
.x1 |> setnames(c("redcap", "StudyID", "cid"))
.x2 |> setnames(c("redcap", "StudyID", "cid"))
.x = rbindlist(list(.x1, .x2))[!is.na(redcap)][
    , stringr::str_extract_all(cid , "([A-Za-z0-9]+)"), by = .(StudyID)][
    , hospital := ifelse(str_detect(V1, "^\\d"), "總院", "生醫")] |> 
    setnames("V1", "PatientID")

#system('dcmdir2csv.py')
#id = fread("id.csv")
id = .x
x = fread("info.csv")
x[, PatientID := stringr::str_extract(PatientID, "^\\w*")]
y = unique(x[!is.na(StudyDate),.(PatientID,StudyDate,StudyTime,InstitutionName,ManufacturerModelName,Manufacturer,SeriesDescription,SliceThickness)], by = c("PatientID", "StudyDate"))[order(PatientID, StudyDate)]
y = id[y, on="PatientID"][order(StudyID, StudyDate)]

#y[,i_Exam := data.table::rowid(PatientID)][,N_Exam:= .N, by=.(PatientID)]
y[!is.na(StudyID), i_Exam := rowid(StudyID)][!is.na(StudyID), N_Exam := .N, by=.(StudyID)][, hospital := ifelse(str_detect(PatientID, "^\\d"), "總院", "生醫")]
#z = y[,.(StudyID,hospital,PatientID,StudyDate,StudyTime,i_Exam,N_Exam,InstitutionName,ManufacturerModelName,Manufacturer,SeriesDescription,SliceThickness)]
z = y[,.(StudyID,i_Exam,N_Exam,hospital,PatientID,StudyDate,StudyTime,InstitutionName,ManufacturerModelName,Manufacturer,SeriesDescription,SliceThickness)]

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
