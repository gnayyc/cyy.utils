#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(lubridate)

files = dir(".", recursive=T)
result.files =  files[str_detect(files,"_muscle.csv$")]
y <- rbindlist(lapply(result.files,fread, colClasses=list("character"=c("timestamp"))))

#y[, var := str_extract(label, "^\\w*")]
y[, sid := str_extract(id, "^[:alnum:]*")]
y[, xdate := str_extract(id, "(?<=^[:alnum:]{1,12}_)\\d*")]
fwrite(y, "muscle_L3_y.csv")

.x = dcast(y, sid + xdate ~ variable, value.var="value")
#.x = dcast(y[var %in% var.density], sid + xdate + timestamp + label + var ~ type, value.var='value')[, .(density = sum(area*mean)/sum(area)), by = c("sid","xdate","var")][,var := paste0(var, "_density")]
#x.density =  dcast(.x, sid+xdate~var, value.var='density')

#x.ao = dcast(y[var %in% var.ao & type == 'ca'], sid + xdate + timestamp + label + var ~ type, value.var='value')[order(-timestamp)][order(-timestamp)][, .(calcium_score = sum(ca[1:8])), by = c('sid','xdate')]

#x.asis = dcast(unique(y[var %in% var.asis], by=c("sid","xdate","var"), fromLast=T), sid + xdate ~ var, value.var='value')

#x = x.asis[x.density[x.ao]]


.x[,psoas_L3_area := psoas_area_adj]
.x[,muscle_L3_area := psoas_area_adj + aw_area + back_area + qlum_area]
x = .x[,.(sid, xdate, psoas_L3_area, muscle_L3_area, body_perimeter_L3 = body_perimeter, body_thickness_L3 = body_thickness, body_width_L3 = body_width)]


fwrite(.x, "muscle_L3_x.csv")
fwrite(x, "lifestyle_muscle_L3.csv")



