#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)<1) {
  stop("done.R dir\n", call.=F)
} 

dir = args[1]
if (!dir.exists(dir)) {
  stop(paste0(dir, " not exists\n"))
} 

dir.done = file.path(dir, "0done")
dir.und = file.path(dir, "0undetermined")
dir.create(dir.done)
dir.create(dir.und)

png = list.files(dir, "*.png")
xml = list.files(dir, "*.xml")
file.done = tools::file_path_sans_ext(xml)
file.all = tools::file_path_sans_ext(png)
done.i = which(file.all %in% file.done)

for (i in 1:max(done.i)) {
    if (i %in% done.i) {
	file.rename(file.path(dir, paste0(file.all[i],".png")), 
	            file.path(dir.done, paste0(file.all[i],".png")))
	file.rename(file.path(dir, paste0(file.all[i],".xml")), 
	            file.path(dir.done, paste0(file.all[i],".xml")))
    } else {
	file.rename(file.path(dir, paste0(file.all[i],".png")), 
	            file.path(dir.und, paste0(file.all[i],".png")))
    }
}

