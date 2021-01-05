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
	template = file.path(Sys.getenv("script_dir"), "template0.itksnap")
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

s.dirs = list.dirs(".", full.names = T, recursive = F)
for (s.dir in s.dirs) {
    .ii = dir(s.dir, "*.nii.gz")
    for (.i in .ii) {
	.id = str_remove(.i, ".nii.gz")
	create_snap_workspace(.id, directory = s.dir)
    }
}


