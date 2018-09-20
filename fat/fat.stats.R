#!/usr/bin/env Rscript

library(tidyverse)

dirs = list.dirs(".",recursive=F)
fdirs = dirs[which(str_detect(dirs, "fat$"))]

fat = list()

for (i in seq_along(fdirs)) {
    csv = list.files(fdirs[i], pattern = "*_[0-9][0-9]*_stats.csv", full.names=T)[1]
    cat(csv, "\n")
    fat[[i]] = read_csv(csv) 
}

fat %>%
    bind_rows() %>%
    select(id, StudyDate, key, `Volume (cm^3)`, `Area (cm^2)`, `Density (HU)` = Mean) %>%
    filter(str_detect(key, "AT")) %>%
    write_csv("fat_stats.csv")


