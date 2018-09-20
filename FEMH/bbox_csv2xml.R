#!/usr/bin/env Rscript

library(tidyverse)
library(xml2)

f = list.files(".", "*.csv")
ACCNO = character(0)
bbox = character(0)
for (i in seq_along(f)) 
{
    x = f[i] %>% read_csv() %>% drop_na()
    for (j in 1:nrow(x))
    {
	filename = as.character(x[j, 1]) %>% paste0(".png")
	cat(j, filename, "\n")
	ann = xml_new_document() %>% xml_add_child("annotation")
	ann %>% xml_add_child("folder") %>% xml_set_text("class")
	ann %>% xml_add_child("filename") %>% xml_set_text(filename)
	ann %>% xml_add_child("path") %>% xml_set_text(filename)
	ann %>% xml_add_child("source") %>% xml_add_child("database") %>% xml_set_text("Unknown")
	ann %>% xml_add_child("size") %>% 
	    xml_add_child("width") %>% xml_set_text("1024") %>%
	    xml_add_sibling("height") %>% xml_set_text("1024") %>%
	    xml_add_sibling("depth") %>% xml_set_text("1") 

	bboxs = x[j, 3] %>% str_extract_all("\\(.*?\\)") %>% .[[1]]
	for (bbox in bboxs) 
	{
	    xy = bbox %>% str_extract_all("\\d+") %>% .[[1]]
	    ann %>% xml_add_child("object") %>% 
		xml_add_child("name") %>% xml_set_text("class") %>%
		xml_add_sibling("pose") %>% xml_set_text("Unspecified") %>%
		xml_add_sibling("truncated") %>% xml_set_text("0") %>%
		xml_add_sibling("difficult") %>% xml_set_text("0") %>%
		xml_add_sibling("bndbox") %>% 
		    xml_add_child("xmin") %>% xml_set_text(xy[1]) %>%
		    xml_add_child("ymin") %>% xml_set_text(xy[2]) %>%
		    xml_add_child("xmax") %>% xml_set_text(xy[3]) %>%
		    xml_add_child("ymax") %>% xml_set_text(xy[4]) 
	}

	write_xml(ann, paste0(paste0(x[j, 1], ".xml")))
    }
}
