#!/usr/bin/env Rscript

local({r <- getOption("repos"); 
    r["CRAN"] <- "https://cloud.r-project.org/";
    options(repos = r)})
list.of.packages <- c("tidyverse", "lubridate", "knitr", "devtools", "stringr", "googlesheets", "googledrive", "kableExtra", "DT", "readxl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
if(!require(rmarkdown)) 
{
    devtools::install_github(c('rstudio/rmarkdown'))
}

library(tidyverse)
library(lubridate)

dir.create("schedule")

use_gs = T
if (use_gs)
{
    library(googlesheets)
    gs_auth()
    derm = 
	gs_url("https://docs.google.com/spreadsheets/d/18NQX3J2LxYY7K_FJgmk_Sf88G0-a64SxCj_c8OxQgd8") %>%
	gs_read()
} else
{
    library(googledrive)
    drive_auth()
    "https://docs.google.com/spreadsheets/d/18NQX3J2LxYY7K_FJgmk_Sf88G0-a64SxCj_c8OxQgd8" %>%
	as_id() %>%
	drive_download(overwrite=T, type = "csv")
    derm = read_csv("0schedule.csv")
}


derm = derm %>%
    group_by(CID) %>%
    mutate(photo_date = ymd(photo_date), # register date 
           registry_date = ymd(registry_date), # register date 
	   lesion = as.character(lesion),
	   is_last_registry = ifelse(registry_date %in% ymd(max(registry_date, na.rm=T)), T, F),
	   interval = ifelse(is.na(interval), 6, interval),
	   #interval = str_replace(interval, "\u00a0", ""),
	   note = ifelse(is.na(note), "", note)) %>%
    arrange(CID, lesion, registry_date) %>%
    group_by(CID, lesion) %>%
    filter(row_number() == which.max(photo_date)) %>%
    ungroup()

derm.name = 
  derm %>% 
  distinct(CID, name) %>%
  group_by(CID) %>%
  filter(row_number() == 1) %>% # make unique name
  ungroup()

d = 
  derm %>% 
  group_by(CID) %>% 
  summarise(
    last_registry_date = ymd(max(registry_date, na.rm=T))
    #,last_lesion = ifelse(any(is_last_registry), lesion[which(is_last_registry)], NA),
    #last_lesion = lesion[which.max(registry_date)]) %>% 
    #last_lesion = ifelse(any(lesion[which.max(registry_date)]), lesion[which.max(registry_date)], NA)) %>% 
  ) %>%
  right_join(derm) %>%
  mutate(
         next_photo_date = photo_date + months(as.integer(interval)),
         next_registry_date = case_when(
	    is.na(last_registry_date) ~ photo_date,
	    is.na(registry_date) ~ last_registry_date + months(1),
	    registry_date + months(6) > last_registry_date + months(1) ~ registry_date + months(6),
	    T ~ last_registry_date + months(1)
        )
  ) %>%
  mutate(
    l0 = ifelse(ymd(today()) > next_registry_date, paste0(lesion, " (",registry_date,")"), NA)
    ,l7 = ifelse(ymd(today()+weeks(1)) > next_registry_date, paste0(lesion, " (",registry_date,")"), NA)
    ,l30 = ifelse(ymd(today()+months(1)) > next_registry_date, paste0(lesion, " (",registry_date,")"), NA)
    ,l180 = ifelse(ymd(today()+months(1)) <= next_registry_date, paste0(lesion, " (",registry_date,")"), NA)

  ) 

dfile = "schedule/schedule.Rdata"
save(d, derm, file = dfile)

today = format(Sys.time(), "%Y-%m-%d")
rmds <- list.files(path=".", pattern="*.Rmd", full.names=T, recursive=FALSE)

for (rmd in rmds)
{
    base = basename(rmd) %>% str_replace(".Rmd", "")
    ofile = paste0("schedule/", base, "-", today, ".html")

    rmarkdown::render(rmd,
	output_format = "html_document",
	output_file = ofile)
}

for (rmd in rmds)
{
    base = basename(rmd) %>% str_replace(".Rmd", "")
    ofile = paste0("schedule/", base, "-", today, ".html")

    if (.Platform$OS.type == "unix")
    {
	system(paste0("open ", ofile))
    } else
    {
	shell(str_replace(ofile, "/", "\\\\"))
    }
}



