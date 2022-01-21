#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(lubridate)

files = dir(".", recursive=T)
result.files =  files[str_detect(files,"_results.csv$")]
y <- rbindlist(lapply(result.files,fread, colClasses=list("character"=c("timestamp"))))

y[, var := str_extract(label, "^\\w*")]
y[, sid := str_extract(id, "^[:alnum:]*")]
y[, xdate := str_extract(id, "(?<=^[:alnum:]{1,12}_)\\d*")]
fwrite(y, "results_y.csv")

var.density = c("aw", "psoas", "liver", "pancreas", "spleen")
#.x = dcast(y, sid + xdate ~ variable, value.var="value")
.x = dcast(y[var %in% var.density], sid + xdate + timestamp + label + var ~ type, value.var='value')[, .(density = sum(area*mean)/sum(area)), by = c("sid","xdate","var")][,var := paste0(var, "_density")]
x.density =  dcast(.x, sid+xdate~var, value.var='density')

var.ao = c("aorta")
x.ao = dcast(y[var %in% var.ao & type == 'ca'], sid + xdate + timestamp + label + var ~ type, value.var='value')[order(-timestamp)][, .(calcium_score = sum(ca[1:8])), by = c('sid','xdate')]

var.asis = c("rkfat", "lkfat", "rkthick", "lkthick")
x.asis = dcast(unique(y[var %in% var.asis], by=c("sid","xdate","var"), fromLast=T), sid + xdate ~ var, value.var='value')

x = x.asis[x.density[x.ao]]


fwrite(.x, "x.csv")
fwrite(x, "lifestyle_CT_density.csv")



