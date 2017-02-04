#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)

## Collect arguments
args <- commandArgs(TRUE)
 
## Default setting when no arguments passed
if(length(args) == 0) {
    SD = Sys.getenv("SUBJECTS_DIR", unset = NA)
    if (is.na(SD)) SD = "."
    STATS = "fs.stats"
} else {
    SD = args[1]
    if(!dir.exists(SD)) SD = "."
    if(length(args) == 2)
    {
	STATS = args[2]
    } else
	STATS = "fs.stats"

}

dir.create(file.path(SD, STATS), showWarnings = FALSE)
STATS_DIR = file.path(SD, STATS)

cat("Subject directory == ", SD, "\n")
cat("Stats directory == ", STATS_DIR, "\n")

tps =
    SD %>%
    list.dirs(recursive = F)

for (s in tps)
{
    aseg.file = file.path(SD, s, "stats/aseg.stats")
    if (file.exists(aseg.file))
    {
	cat("\nFound aseg.stats:", aseg.file, "\n")
	sid = 
	    aseg.file %>%
	    read_delim(skip = 12, n_max = 1, delim = " ", col_names = F) %>% 
	    .[["X3"]]

	asegs = 
	    aseg.file %>%
	    read_csv(skip = 13, n_max = 18, col_names = c("desc", "key", "note", "value", "unit")) %>%
	    mutate(sid = sid) %>%
	    mutate(key = ifelse(str_detect(key, "lh"), paste0("aseg.vol.lh.", key),
			 ifelse(str_detect(key, "rh"), paste0("aseg.vol.rh.", key),
				   paste0("aseg.vol.mid.", key)))) %>%
	    select(sid, key, value) %>%
	    write_csv(file.path(STATS_DIR,paste0(s,".aseg.csv")))
    }
}

