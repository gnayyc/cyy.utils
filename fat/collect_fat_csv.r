#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(lubridate)

files = dir(".", recursive=T)
result.files =  files[str_detect(files,"_results.csv$")]
y <- rbindlist(lapply(result.files,fread, colClasses=list("character"=c("timestamp"))))
names(y) = c("id","variable","value")

#y[, var := str_extract(label, "^\\w*")]
y[, sid := str_extract(id, "^[:alnum:]*")]
y[, xdate := str_extract(id, "(?<=^[:alnum:]{1,12}_)\\d*")]
fwrite(y, "fat_y.csv")

x = dcast(y, sid + xdate ~ variable, value.var="value")
names(x) = c("sid", "xdate", "body_area_U", "body_thickness_U", "body_perimeter_U", 
"body_width_U", "sat_area_U", "sat_mean_U", "vat_area_U", "vat_mean_U")

fwrite(x, "lifestyle_fat_U.csv")


