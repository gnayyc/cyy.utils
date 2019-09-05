#!/usr/bin/env Rscript

# bbox_xml2csv.R [ref.csv] [label.csv]
# read pascal voc xmls in current directory, and join the bboxes with [ref.csv], write them into [label.csv]

library(dplyr)
library(xml2)

f = dir(".", "*.xml")
ACCNO = character(0)
bbox = character(0)
label = character(0)

for (i in seq_along(f)) {
    .accno = character(0)
    .label = character(0)
    .bbox = character(0)

    x = f[i] %>% read_xml()
    .accno = x %>% xml_find_all(".//filename") %>% xml_text #%>% stringr::str_extract("RA[0-9A-Z]*")
    .label = x %>% xml_find_all(".//class") %>% xml_text

    node_box = x %>% xml_find_all(".//bndbox")
    for (b in node_box) {
	xmin = b %>% xml_find_all(".//xmin") %>% xml_text
	ymin = b %>% xml_find_all(".//ymin") %>% xml_text
	xmax = b %>% xml_find_all(".//xmax") %>% xml_text
	ymax = b %>% xml_find_all(".//ymax") %>% xml_text
	.bbox = paste(paste0("(", paste0(c(xmin,ymin,xmax,ymax),collapse=". ") ,")"), .bbox)
    }

    if (!length(.accno)) .accno = ""
    if (!length(.label)) .label = ""
    if (!length(.bbox)) .bbox = ""
    ACCNO[i] = .accno
    label[i] = .label
    bbox[i] = .bbox
}

if (length(ACCNO) != length(bbox) | length(ACCNO) != length(label)) {
  z = paste0("ACCNO|bbox|label = ", length(ACCNO), "|", length(bbox), "|", length(label), "\n")
  stop(z, call.=F)
} 

box = data.frame(ACCNO, label, bbox) %>% 
    dplyr::filter(nchar(as.character(bbox))>5 | label != "") 

args <- commandArgs(TRUE)
if (length(args) > 0 && file.exists(args[1])) {
    if (length(args) > 1) {
	target_csv = args[2]
    } else {
	target_csv = "label.csv"
    } 
    
    data.table::fread(args[1]) %>%
	select(ACCNO) %>%
	mutate(ACCNO = as.character(ACCNO)) %>%
	left_join(box, by = "ACCNO") %>%
	mutate(bbox = ifelse(is.na(bbox), "", as.character(bbox))) %>%
	write_csv(target_csv)
} else {
    box %>%
	data.table::fwrite("label.csv")
}


