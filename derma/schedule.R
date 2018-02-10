
local({r <- getOption("repos"); 
    r["CRAN"] <- "https://cloud.r-project.org/";
    options(repos = r)})
list.of.packages <- c("tidyverse", "lubridate", "readxl", "writexl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(tidyverse)
library(lubridate)
library(readxl)
library(writexl)

derm = read_xlsx("0schedule.xlsx") %>% 
  mutate(date = ymd(date), # register date 
	lesion = as.character(lesion)) %>%
  arrange(CID, lesion)

d = 
  derm %>% 
  group_by(CID) %>% 
  summarise(
    date_last = max(date, na.rm=T),
    lesion_last = lesion[which(date == max(date, na.rm=T))]) %>% 
  right_join(derm) %>%
  mutate(
    i        = interval(ymd(date),      ymd(today()-1            )) %/% months(1),
    i7       = interval(ymd(date),      ymd(today()-1 + weeks(1) )) %/% months(1),
    i30      = interval(ymd(date),      ymd(today()-1 + months(1))) %/% months(1),
    i_last   = interval(ymd(date_last), ymd(today()-1            )) %/% months(1),
    i7_last  = interval(ymd(date_last), ymd(today()-1 +  weeks(1))) %/% months(1),
    i30_last = interval(ymd(date_last), ymd(today()-1 + months(1))) %/% months(1)
  ) %>% 
  mutate(
    show0 = case_when(
      i_last < 1 ~ as.character(NA), 
      is.na(date) ~ lesion,
      i >= 6 ~ lesion,
      T ~ as.character(NA)),
    show7 = case_when(
      i7_last < 1 ~ as.character(NA), 
      is.na(date) ~ lesion,
      i7 >= 6 ~ lesion,
      T ~ as.character(NA)),
    show30 = case_when(
      i30_last < 1 ~ as.character(NA), 
      is.na(date) ~ lesion,
      i30 >= 6 ~ lesion,
      T ~ as.character(NA))
  ) %>%
  group_by(CID, date_last, lesion_last) %>% 
  summarise(lesions0 = paste(show0[!is.na(show0)], collapse=", "),
            lesions7 = paste(show7[!is.na(show7)], collapse=", "),
            lesions30 = paste(show30[!is.na(show30)], collapse=", ")
  ) %>%
  set_names(c("Chart Number", "Last Date", "Last Lesion", "Today", "Next Week", "Next Month"))

d %>% write_xlsx(paste0(today(),".xlsx"))
#d_w %>% write_xlsx("week.xlsx")

