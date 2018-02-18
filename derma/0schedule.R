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

dir.create("schedule")
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

