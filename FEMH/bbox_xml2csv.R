#!/usr/bin/env Rscript

library(magrittr)
library(xml2)

f = list.files(".", "*.xml")
ACCNO = character(0)
bbox = character(0)
for (i in seq_along(f)) {
    x = f[i] %>% read_xml()
    accno = x %>% xml_find_all(".//filename") %>% xml_text %>% sub(".png", "", .)
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

data.frame(ACCNO, bbox) %>% 
    dplyr::filter(nchar(as.character(bbox))>5) %>%
    readr::write_csv("bbox.csv")
