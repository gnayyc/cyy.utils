#!/usr/bin/env Rscript

initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
Sys.setenv(script_dir = dirname(script.name))

create_snap_workspace = function(id = NA, template = "template.itksnap", directory = ".", file = paste0(id, ".itksnap")) {
    library(magrittr)
    library(xml2)
    library(stringr)
    if (is.na(id)) return
    if (!file.exists(template)) {
	template = file.path(Sys.getenv("script_dir"), "template.itksnap")
	if (!file.exists(template)) stop(paste0(template, " not exists!\n"))
    }
    
    .x = read_xml(template)
    
    .entries = .x %>% xml_find_all("//registry//folder/folder/entry")
    for (.e in .entries) {
	if(xml_attr(.e, "key") == "AbsolutePath") xml_set_attr(.e, "value", str_replace(xml_attr(.e, "value"), "id", id))
    }
    write_xml(.x, file.path(directory, file))
    
}

library(stringr)

fat.dirs = dir(".", "*.fat")
for (fat.dir in fat.dirs) {
    id = str_remove(fat.dir, ".fat")
    create_snap_workspace(id, directory = fat.dir)
}


