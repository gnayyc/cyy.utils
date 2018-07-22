#!/usr/bin/env Rscript

# move labeled files into 0label
# move unlabeled files into 0undtermined
# move xml files into 0xml or xmldir

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)<1) {
  stop("done.R imgdir [xmldir]\n", call.=F)
} 

imgdir = args[1]
if (!dir.exists(imgdir)) {
  stop(paste0(imgdir, " not exists\n"))
} 
if (length(args) >= 2)
{
    xmldir = args[2]
    if (!dir.exists(xmldir)) {
      stop(paste0(xmldir, " not exists\n"))
    } 
}


labeldir = paste0(imgdir, "_label")
unddir = paste0(imgdir, "_undetermined")
if (length(args) < 2)
{
    xmldir = paste0(imgdir, "_xml")
}

dir.create(labeldir)
dir.create(unddir)
dir.create(xmldir)

png = list.files(imgdir, "*.png")
xml = c(list.files(imgdir, "*.xml"), list.files(xmldir, "*.xml"))

if (length(xml)<1) {
  stop("found no xml files\n", call.=F)
} 



file.label = tools::file_path_sans_ext(xml)
file.img = tools::file_path_sans_ext(png)
label.i = which(file.img %in% file.label)

if (length(label.i)<1) {
  stop("found no un-archived files\n", call.=F)
} 

for (i in 1:max(label.i)) {
    if (i %in% label.i) {
	file.rename(file.path(imgdir, paste0(file.img[i],".png")), 
	            file.path(labeldir, paste0(file.img[i],".png")))
	if(file.exists(file.path(imgdir, paste0(file.img[i],".xml")))) {
	    file.rename(file.path(imgdir, paste0(file.img[i],".xml")), 
			file.path(xmldir, paste0(file.img[i],".xml")))
	}
    } else {
	file.rename(file.path(imgdir, paste0(file.img[i],".png")), 
	            file.path(unddir, paste0(file.img[i],".png")))
    }
}

