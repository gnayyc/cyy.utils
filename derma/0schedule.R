#!/usr/bin/env Rscript

local({r <- getOption("repos"); 
    r["CRAN"] <- "https://cloud.r-project.org/";
    options(repos = r)})
list.of.packages <- c("tidyverse", "lubridate", "readxl", "writexl", "knitr", "devtools", "stringr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
if(!require(rmarkdown)) 
{
    devtools::install_github(c('rstudio/rmarkdown'))
}

library(lubridate)

dir.create("schedule")
ofile = paste0("schedule/schedule-", today(),".html")


rmarkdown::render('0schedule.Rmd', 
    output_format = "html_document",
    output_file = ofile)

if (.Platform$OS.type == "unix")
{
    system(paste0("open ", ofile))
} else
{
    shell(str_replace(ofile, "/", "\\\\"))
}

