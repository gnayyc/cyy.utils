#!/usr/bin/env Rscript

# cp from image dir by csv and add PATID to filename

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)!= 3) {
  stop("sort_list.R csv_with_ACCNO_PATID source_dir output_dir\n", call.=F)
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

x = read_csv(csv) %>% 
  mutate(from = file.path(dir1, paste0(ACCNO, ".png"))) %>%
  mutate(to= file.path(dir2, paste0(PATID, "-", ACCNO, ".png"))) 

for (i in 1:nrow(x))
{
    file.copy(x[i,]$from, x[i,]$to, overwrite = F)
}


