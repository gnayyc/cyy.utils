#!/usr/bin/env Rscript

library(tidyverse)
library(ANTsR)

dirs = list.dirs(".",recursive=F)
fat.dirs = dirs[which(str_detect(dirs, "fat$"))]

for (fdir in fat.dirs) {
    f0 = list.files(fdir, pattern = "*anatomy.nii.gz") 
    id = f0 %>% str_extract("^[:alnum:]*")
    idate = f0 %>% str_extract("_[:alnum:]*_") %>% str_replace_all("_", "")
    sid = paste(id, idate, sep = "_")
    i0 = list.files(fdir, pattern = "*anatomy.nii.gz", full.names = T) %>% antsImageRead(2)
    i1 = list.files(fdir, pattern = "*label.nii.gz", full.names = T) %>% antsImageRead(2)
    vol = 
	i0 %>%
	labelStats(i1) %>%
	filter(LabelValue > 0) %>%
	mutate(key = case_when(LabelValue == 1 ~ "SAT", # Subcutaneous Adipose Tissue
	    LabelValue == 2 ~ "VAT", # Visceral Adipose Tissue
	    LabelValue == 3 ~ "Soft", # Soft tissue
	    LabelValue == 4 ~ "Bone", # Bone
	    TRUE ~ "Others")) %>%
	mutate(id = id, StudyDate = idate) %>%
        mutate(`Area (cm^2)`= Volume, `Volume (cm^3)` = Volume/2) %>%
	select(id, StudyDate, everything(), -Volume)
    
    
    write_csv(vol, file.path(fdir,paste0(sid,"_stats.csv")))

}

