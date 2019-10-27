#!/usr/bin/env Rscript

library(tidyverse)

#dirs = list.dirs(".",recursive=F)
#fdirs = dirs[which(str_detect(dirs, "fat$"))]
csvs = dir(".", "*_9stats.csv", recursive=T)

fat = list()

for (i in seq_along(csvs)) {
    cat(csvs[i], "\n")
    fat[[i]] = read_csv(csvs[i]) 
}

fat %>%
    bind_rows() %>%
    select(id, StudyDate, key, `Volume (cm^3)`, `Area (cm^2)`, `Density (HU)` = Mean, Variance) %>%
    #filter(str_detect(key, "AT")) %>%
    write_csv("fat_stats.csv")


