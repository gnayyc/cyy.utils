#!/usr/bin/env Rscript

library(dplyr)
library(readr)
library(xml2)

f = list.files(".", "*.xml")
ACCNO = character(0)
bbox = character(0)
for (i in seq_along(f)) {
    x = f[i] %>% read_xml()
    accno = x %>% 
	xml_find_all(".//filename") %>% 
	xml_text %>% 
	stringr::str_extract("RA[0-9]*")
    node_box = x %>% xml_find_all(".//bndbox")
    bndbox = ""
    for (b in node_box) {
	xmin = b %>% xml_find_all(".//xmin") %>% xml_text
	ymin = b %>% xml_find_all(".//ymin") %>% xml_text
	xmax = b %>% xml_find_all(".//xmax") %>% xml_text
	ymax = b %>% xml_find_all(".//ymax") %>% xml_text
	bndbox = paste(paste0("(", paste0(c(xmin,ymin,xmax,ymax),collapse=". ") ,")"), bndbox)
    }
    ACCNO[i] = accno
    bbox[i] = bndbox
    
}

box = data.frame(ACCNO, bbox) %>% 
    dplyr::filter(nchar(as.character(bbox))>5) 

args <- commandArgs(TRUE)
if (length(args) > 0 && file.exists(args[1])) {
    if (length(args) > 1) {
	target_csv = args[2]
    } else {
	target_csv = "bbox.csv"
    } 
    
    read_csv(args[1]) %>%
	select(ACCNO) %>%
	mutate(ACCNO = as.character(ACCNO)) %>%
	left_join(box, by = "ACCNO") %>%
	mutate(bbox = ifelse(is.na(bbox), "", as.character(bbox))) %>%
	write_csv(target_csv)
} else {
    box %>%
	write_csv("bbox.csv")
}


