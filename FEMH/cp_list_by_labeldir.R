#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)!= 3) {
  stop("cp_list.R csv_with_ACCNO source_dir output_dir\n", call.=F)
} 

csv = args[1]
dir1 = args[2]
dir2 = args[3]

if (!dir.exists(dir1)) {
  stop(paste0(dir1, " not exists\n"))
} 

if (!file.exists(dir2)) {
   dir.create(dir2)
} 

library(tidyverse)

### XXXXXXXX: find some map method later

dirs.create = function (path) {
    for (i in path) {
	cat("Creating ", i, "\n")
	dir.create(i, recursive = T)
    }
}
files.copy = function (from, to) {
    for (i in 1:length(from)) {
	cat("Copying ", from[i], " to ", to[i], "\n")
	file.copy(from[i], to[i], overwrite = F)
    }
}

read_csv(csv) %>% 
    distinct(label) %>%
    mutate(label= file.path(dir2, label)) %>%
    pull(label) %>%
    dirs.create()

read_csv(csv) %>% 
    mutate(file1 = file.path(dir1, paste0(.[["ACCNO"]], ".png")),
	   file2 = file.path(dir2, label, paste0(paste0(.[["ACCNO"]], ".png")))) %>%
    do(a = files.copy(.$file1, .$file2))



