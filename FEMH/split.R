#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)<1) {
  stop("split.R dir [batch_size]\n", call.=F)
} 

dir = args[1]
if (!dir.exists(dir)) {
  stop(paste0(dir, " not exists\n"))
} 

if (length(args) > 1) {
    batch = as.integer(args[2])
} else {
    batch = 500
}

files = list.files(dir)
for (i in seq_along(files)) {
    if (i %% batch == 1) {
	dir.create(file.path(dir, sprintf("%03d",1+ as.integer(i/batch))))
    }
    cat("file.rename(", file.path(dir,files[i]), ",", file.path(dir, sprintf("%03d",1+ as.integer(i/batch)), files[i]), ")\n")
    file.rename(file.path(dir,files[i]), file.path(dir, sprintf("%03d",1+ as.integer((i-1)/batch)), files[i]))
}

