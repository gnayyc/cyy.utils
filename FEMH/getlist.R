#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args) < 3) {
  stop("getlist.R csv_with_ACCNO ln|cp|mv png|dcm source_dir output_dir [imageID_col(ACCNO)] [key_column] [key2_column]\n", call.=F)
} 

csv = args[1]
action = args[2]
ext = args[3]
dir1 = args[4]
dir2 = args[5]
if (length(args) >= 6) {
    aid = args[6]
} else {aid = "ACCNO"}
if (length(args) >= 7) {
    key = args[7]
}
if (length(args) >= 8) {
    key2 = args[8]
}

if (!dir.exists(dir1)) {
  stop(paste0(dir1, " not exists\n"))
} 

if (!file.exists(dir2)) {
   dir.create(dir2)
} 

library(data.table)
if (length(args) >= 7)
    csv2 = paste0(tools::file_path_sans_ext(csv), "-", key, ".csv")
if (length(args) >= 8)
    csv2 = paste0(tools::file_path_sans_ext(csv), "-", key, "-", key2, ".csv")

x = fread(csv)
x[, ano := stringr::str_remove(x[[aid]], ".(dcm|png)")]
x[, from:=file.path(dir1, paste0(ano,".",ext))]

# XXXXXXXXXXXXXXXX
if (length(args) < 7) {
    cat("Copy from ", dir1, " to ", dir2, "\n")
    x[,file.copy(from, dir2, overwrite = F)]
    x[1,cat(from, " --> ", dir2, "\n")]
} else {
    cat("Copy from file1 to file2\n")
    if (length(args) == 7) 
	x[, to:=file.path(dir2, paste0(x[[key]], "-", x[[aid]],".png"))]
    if (length(args) == 8) 
	x[, to:=file.path(dir2, paste0(x[[key]], "-", x[[key2]], "-", x[[aid]],".png"))]
    x[,file.copy(from, to, overwrite = F)]
    x[1,cat(from, " --> ", to, "\n")]

}

