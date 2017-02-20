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
    unique() %>%
    sort()

base.cmd = c()
long.cmd = c()

for (s in sid)
{
    tp = tps[str_detect(tps, s)]
    arg = paste(paste("-tp", tp, collpase=" "), collapse=" ")
    if(!dir.exists(file.path(SD, paste0(s, ".base"))))
    {
	base.cmd = c(base.cmd, paste("recon-all -all -sd", SD, "-base", paste0(s, ".base"), arg))
    }
    for (.tp in tp)
    {
	if(!dir.exists(file.path(SD, paste0(.tp, ".long.", s, ".base"))))
	{
	    long.cmd = c(long.cmd, paste("recon-all -all -sd", SD, "-long", .tp, paste0(s, ".base")))
	}
    }
}

parallel::mclapply(base.cmd, system, mc.cores=10, mc.preschedule=F)
parallel::mclapply(long.cmd, system, mc.cores=10, mc.preschedule=F)

#recon-all -base <templateid> -tp <tp1id> -tp <tp2id> ... -all
#recon-all -long <tpNid> <templateid> -all

