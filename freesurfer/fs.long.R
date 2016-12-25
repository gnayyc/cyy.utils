#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)

## Collect arguments
args <- commandArgs(TRUE)
 
## Default setting when no arguments passed
if(length(args) == 0) {
    SD = Sys.getenv("SUBJECTS_DIR", unset = NA)
    if (is.na(SD))
    {
	SD = "."
    }
} else {
    SD = args[1]
    if(!dir.exists(SD))
    {
	SD = "."
    }
}

cat("Subject directory == ", SD, "\n")

ex = c("average", "base", "long", "fs.stats", "qdec", "QA")

tps =
    SD %>%
    list.dirs(recursive = F) %>%
    basename() %>%
    grep(paste(ex,collapse="|"), ., value = T, invert = T)

sid = 
    tps %>%
	str_replace("_.*", "") %>%
	unique()

for (s in sid)
{
    tp = tps[str_detect(tps, s)]
    arg = paste("-tp", paste(tp, collapse=" "), collpase=" ")
    cmd = paste("recon-all -all -sd", SD, "-base", paste0(s, ".base"), arg)
    cat(cmd, "\n")
    for (.tp in tp)
    {
	cmd = paste("recon-all -all -sd", SD, "-long", .tp, paste0(s, ".base"))
	cat(cmd, "\n")
    }
}


#recon-all -base <templateid> -tp <tp1id> -tp <tp2id> ... -all

