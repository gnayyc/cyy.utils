#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

if (length(args) < 2) {
  stop("rename_to_sha1_dir.R dir_cid_iid_aid dir_iid_sha1\n", call.=F)
} 

dir1 = args[1]
dir2 = args[2]

if (!dir.exists(dir1)) {
  stop(paste0(dir1, " not exists\n"))
} 

if (!file.exists(dir2)) {
   dir.create(dir2)
} 

library(stringr)


f1 = dir(dir1, full.names = T)
iid = str_extract(f1, "I[[:alnum:]]{10,}")
iid2 = openssl::sha1(iid)
ext = str_extract(f1, "\\.[[:alpha:]]*$")

f2 = paste0(dir2, "/", iid2, ext)

file.link(f1, f2)

