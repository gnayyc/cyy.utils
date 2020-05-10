#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args) < 3) {
  stop("ln_list.R csv_with_ACCNO source_dir output_dir [iid_column] [key_column] [key2_column]\n", call.=F)
} 

csv = args[1]
dir1 = args[2]
dir2 = args[3]
if (length(args) >= 4) {
    id = args[4]
} else {id = "ACCNO"}
cat("File ID:", id, "\n")

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

cat("csv file:", csv, "\n")
x = fread(csv)
cat("Dir1:", dir1, "\n")
x[, from:=file.path(dir1, paste0(x[[id]],".png"))]
cat("First from:", x[1,from], "\n")
cat("Dir2:", dir2, "\n")

if (length(args) < 5) {
    cat("Move ", dir1, " to ", dir2, "\n")
    x[,file.rename(from, dir2, overwrite = F)]
} else {
    cat("Move from file1 to file2\n")
    if (length(args) == 5) 
	x[, to:=file.path(dir2, paste0(x[[key]], "-", x[[id]],".png"))]
    if (length(args) == 6) 
	x[, to:=file.path(dir2, paste0(x[[key]], "-", x[[key2]], "-", x[[id]],".png"))]
    x[,file.rename(from, to, overwrite = F)]

}

