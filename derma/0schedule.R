#!/usr/bin/env Rscript

local({r <- getOption("repos"); 
    r["CRAN"] <- "https://cloud.r-project.org/";
    options(repos = r)})
list.of.packages <- c("tidyverse", "lubridate", "knitr", "devtools", "stringr", "googlesheets", "kableExtra", "DT")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
if(!require(rmarkdown)) 
{
    devtools::install_github(c('rstudio/rmarkdown'))
}

library(tidyverse)
library(lubridate)
library(googlesheets)

dir.create("schedule")
derm = 
    gs_key("18NQX3J2LxYY7K_FJgmk_Sf88G0-a64SxCj_c8OxQgd8") %>%
    gs_read() %>%
    set_names(c("time","CID","name","lesion","photo_date","registry_date","interval")) %>%
    mutate(photo_date = ymd(photo_date), # register date 
           registry_date = ymd(registry_date), # register date 
	   lesion = as.character(lesion)) %>%
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
    last_registry_date = max(registry_date, na.rm=T),
    last_lesion = lesion[which(registry_date == max(registry_date, na.rm=T))]) %>% 
  right_join(derm) %>%
  mutate(
    i        = interval(ymd(registry_date),      ymd(today()-1            )) %/% months(1),
    i7       = interval(ymd(registry_date),      ymd(today()-1 + weeks(1) )) %/% months(1),
    i30      = interval(ymd(registry_date),      ymd(today()-1 + months(1))) %/% months(1),
    i_last   = interval(ymd(last_registry_date), ymd(today()-1            )) %/% months(1),
    i7_last  = interval(ymd(last_registry_date), ymd(today()-1 +  weeks(1))) %/% months(1),
    i30_last = interval(ymd(last_registry_date), ymd(today()-1 + months(1))) %/% months(1)
  ) %>% 
  mutate(
         next_photo_date = photo_date + months(interval),
         next_registry_date = case_when(
	    is.na(registry_date) ~ last_registry_date + months(1),
	    registry_date + months(6) > last_registry_date + months(1) ~ registry_date + months(6),
	    T ~ last_registry_date + months(1)
        )
  ) %>%
  mutate(
    #l0 = ifelse(show0, paste0(lesion, " (",registry_date,")"), NA),
    #l7 = ifelse(show7, paste0(lesion, " (",registry_date,")"), NA),
    #l30 = ifelse(show30, paste0(lesion, " (",registry_date,")"), NA),
    l0 = ifelse(ymd(today()) > next_registry_date, paste0(lesion, " (",registry_date,")"), NA),
    l7 = ifelse(ymd(today()+weeks(1)) > next_registry_date, paste0(lesion, " (",registry_date,")"), NA),
    l30 = ifelse(ymd(today()+months(1)) > next_registry_date, paste0(lesion, " (",registry_date,")"), NA)
  ) 

dfile = "schedule/schedule.Rdata"
save(d, derm, file = dfile)

ofile = paste0("schedule/schedule-", format(Sys.time(), "%Y-%m-%d"),".html")
afile = paste0("schedule/schedule_all-", format(Sys.time(), "%Y-%m-%d"),".html")


rmarkdown::render('0schedule.Rmd', 
    output_format = "html_document",
    output_file = ofile)

rmarkdown::render('0schedule_all.Rmd', 
    output_format = "html_document",
    output_file = afile)

if (.Platform$OS.type == "unix")
{
    system(paste0("open ", ofile))
    system(paste0("open ", afile))
} else
{
    shell(str_replace(ofile, "/", "\\\\"))
    shell(str_replace(afile, "/", "\\\\"))
}

