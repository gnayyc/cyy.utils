#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(lubridate)


# organ density, aorta ca score
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
setnames(x, c("sid", "xdate", "left_renal_sinus_fat_area", "left_perirenal_fat_thickness_posterior", "right_renal_sinus_fat_area", "right_perirenal_fat_thickness_posterior", "liver_density_mean", 
"pancreas_density_mean", "spleen_density_mean", "caorta_iliac_bifurcation_4cm_ca_score"))
x.d = x

fwrite(.x, "x.csv")
fwrite(x, "lifestyle_CT_density.csv")



# Fat
files = dir(".", recursive=T)
result.files =  files[str_detect(files,"_fat.csv$")]
y <- rbindlist(lapply(result.files,fread, colClasses=list("character"=c("timestamp"))))

y[, sid := str_extract(id, "^[:alnum:]*")]
y[, xdate := str_extract(id, "(?<=^[:alnum:]{1,12}_)\\d*")]
fwrite(y, "fat2_U_y.csv")

.x = dcast(y, sid + xdate ~ variable, value.var="value")
setnames(.x, c("sid","xdate","umbilical_body_area","umbilical_body_perimeter","umbilical_body_thickness","umbilical_body_width","umbilical_sat_area","umbilical_sat_mean","umbilical_vat_area","umbilical_vat_mean"))
x.f = .x

fwrite(.x, "lifestyle_fat2_U.csv")




# Muscle
files = dir(".", recursive=T)
result.files =  files[str_detect(files,"_muscle.csv$")]
y <- rbindlist(lapply(result.files,fread, colClasses=list("character"=c("timestamp"))))

#y[, var := str_extract(label, "^\\w*")]
y[, sid := str_extract(id, "^[:alnum:]*")]
y[, xdate := str_extract(id, "(?<=^[:alnum:]{1,12}_)\\d*")]
fwrite(y, "muscle_L3_y.csv")

.x = dcast(y, sid + xdate ~ variable, value.var="value")
setnames(.x, c("sid", "xdate", "aw_area", "aw_mean", "back_area", "back_mean", "body_area", "body_perimeter", "body_thickness", "body_width", "psoas_area", "psoas_area_adj", "psoas_mean", "psoas_mean_adj", "qlum_area", "qlum_mean"))
#.x = dcast(y[var %in% var.density], sid + xdate + timestamp + label + var ~ type, value.var='value')[, .(density = sum(area*mean)/sum(area)), by = c("sid","xdate","var")][,var := paste0(var, "_density")]
#x.density =  dcast(.x, sid+xdate~var, value.var='density')

#x.ao = dcast(y[var %in% var.ao & type == 'ca'], sid + xdate + timestamp + label + var ~ type, value.var='value')[order(-timestamp)][order(-timestamp)][, .(calcium_score = sum(ca[1:8])), by = c('sid','xdate')]

#x.asis = dcast(unique(y[var %in% var.asis], by=c("sid","xdate","var"), fromLast=T), sid + xdate ~ var, value.var='value')

#x = x.asis[x.density[x.ao]]


.x[,psoas_L3_area := psoas_area_adj]
.x[,muscle_L3_area := psoas_area_adj + aw_area + back_area + qlum_area]
x = .x[,.(sid, xdate, L3_psoas_area = psoas_L3_area, L3_muscle_area = muscle_L3_area, L3_body_perimeter = body_perimeter, L3_body_thickness = body_thickness, L3_body_width = body_width)]

x.m = x


fwrite(.x, "muscle_L3_x.csv")
fwrite(x, "lifestyle_muscle_L3.csv")

x = x.m[x.f[x.d]]


fwrite(x, "lifestyle_CT.csv")
