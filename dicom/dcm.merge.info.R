#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)

## Collect arguments
args <- commandArgs(TRUE)
 
## Default setting when no arguments passed
if(length(args) == 0) {
    BIDS = "."
} else {
    BIDS = args[1]
}

cat("BIDS directory == ", BIDS, "\n")

csv_files =
    BIDS %>%
    dir(pattern = "*.csv")

demo = tibble()
for (f in csv_files)
{
    demo = 
	read_csv(f, col_types = cols(PatientSex = "c"), trim_ws = T) %>% 
	mutate_all(funs(as.character)) %>% 
	bind_rows(demo)
}

save(demo, file = "demo.rdata")
write_csv(demo, "demo.csv")

