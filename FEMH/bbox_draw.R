#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)!= 3) {
  stop("bbox_draw.R csv_ACCNO_bbox source_dir output_dir\n", call.=F)
} 

csv = args[1]
dir1 = args[2]
dir2 = args[3]

if (!dir.exists(dir1)) {
  stop(paste0(dir1, " not exists\n"))
} 

if (!file.exists(dir2)) {
   dir.create(dir2)
} 

library(tidyverse)
library(qrabbit)

bbox_draw = function(im = NA, bbox = NA, color = "red", lwd = 4, use_plot = 0) {
    library(imager)
    
    if(is.character(im)) {
	if (!file.exists(im)) return(NA)
	im = load.image(im)
    }
    if (!is.cimg(im)) return(NA)

    if (!is.list(bbox) & is.vector(bbox) & length(bbox) == 4) {
	b = bbox
	bbox = list()
	bbox[[1]] = map_int(b, as.integer)
	names(bbox[[1]]) = c("xmin","ymin","xmax","ymax")
    }
    if (is.list(bbox)) {
        for(bb in bbox) {
	    if (dim(im)[4] == 1) im = add.colour(im)
            if(all(!is.na(bb)) & all(names(bb) == c("xmin","ymin","xmax","ymax"))) {
		bb = map_int(bb, as.integer)
		if (use_plot == 1) {
		    im = implot(im, {rect(bb["xmin"],bb["ymin"],bb["xmax"],bb["ymax"], border=color, lwd=2)})
		} else {
		    msk1 = (Xc(im) %inr% c(bb["xmin"], bb["xmax"]) & 
			    Yc(im) %inr% c(bb["ymin"], bb["ymax"]))
		    msk2 = (Xc(im) %inr% c(bb["xmin"]-lwd, bb["xmax"]+lwd) & 
			    Yc(im) %inr% c(bb["ymin"]-lwd, bb["ymax"]+lwd))
		    mask = msk2 - msk1
		    bg.red = imfill(dim=dim(im), val = c(1,0,0))
		    im =  mask * bg.red + (1 - mask) * im
		}
            }
        }
    }
    return(im)
}

bb = read_csv(csv) 
ACCNO = bb$ACCNO
bbox = bb$bbox

for (i in seq_along(ACCNO)) {
    bb = bbox_vector(bbox[i])
    a = ACCNO[i]
    f1 = file.path(dir1, paste0(a, ".png"))
    f2 = file.path(dir2, paste0(a, ".png"))
    cat(f1, " -> ", f2, "\n")
    f1 %>% bbox_draw(bb, color = "red") %>% save.image(f2)
}

