#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)!= 3) {
  stop("cp_list.R csv_file_containing_ACCNO_column source_dir output_dir\n", call.=F)
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

read_csv(csv) %>% 
  mutate(file = file.path(dir1, paste0(ACCNO, ".png"))) %>%
  .$file %>%
  file.copy(dir2, overwrite = F)


