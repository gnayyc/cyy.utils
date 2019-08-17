#!/usr/bin/env Rscript

library(tidyverse)
library(OpenImageR)

args <- commandArgs(TRUE)

## Default setting when no arguments passed
if(length(args) == 0) {
    cat("need a png containing directory as argument\n")
    exit()
} else {
    idir = args[1]
    if(!dir.exists(idir)) {
	cat("need a png containing directory as argument\n")
    } else {
	csv = paste0(idir, "_phash.csv")
	cat("\nImage directomy: ", idir, "\n")
	cat("CSV file: ", csv, "\n\n")
    }   
}

png_files = list.files(idir, "*.png$")

tibble(image = png_files) %>%
mutate(phash = map_chr(image, ~phash(readImage(file.path(idir,.x)), hash_size=8, highfreq_factor=4, MODE='hash', resize="bilinear"))) %>%
write_csv(csv)
