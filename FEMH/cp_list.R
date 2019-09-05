#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args) < 3) {
  stop("cp_list.R csv_with_ACCNO source_dir output_dir [image_key_col(ACCNO)] [key_column] [key2_column]\n", call.=F)
} 

csv = args[1]
dir1 = args[2]
dir2 = args[3]
if (length(args) >= 4) {
    aid = args[4]
} else {aid = "ACCNO"}
if (length(args) >= 5) {
    key = args[5]
}
if (length(args) >= 6) {
    key2 = args[6]
}

if (!dir.exists(dir1)) {
  stop(paste0(dir1, " not exists\n"))
} 

if (!file.exists(dir2)) {
   dir.create(dir2)
} 

library(data.table)
if (length(args) >= 5)
    csv2 = paste0(tools::file_path_sans_ext(csv), "-", key, ".csv")
if (length(args) >= 6)
    csv2 = paste0(tools::file_path_sans_ext(csv), "-", key, "-", key2, ".csv")

x = fread(csv)
x[, from:=file.path(dir1, paste0(x[[aid]],".png"))]

if (length(args) < 5) {
    cat("Copy from ", dir1, " to ", dir2, "\n")
    x[,file.copy(from, dir2, overwrite = F)]
} else {
    cat("Copy from file1 to file2\n")
    if (length(args) == 5) 
	x[, to:=file.path(dir2, paste0(x[[key]], "-", x[[aid]],".png"))]
    if (length(args) == 6) 
	x[, to:=file.path(dir2, paste0(x[[key]], "-", x[[key2]], "-", x[[aid]],".png"))]
    x[,file.copy(from, to, overwrite = F)]

}

