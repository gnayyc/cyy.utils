#!/usr/bin/env Rscript

initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
Sys.setenv(script_dir = dirname(script.name))

create_snap_workspace = function(id = NA, template = "template.itksnap", directory = ".", file = paste0(id, ".itksnap"), dim_x = 512, dim_y = 512, dim_z = 1) {
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
	if(xml_attr(.e, "key") == "Dimensions") xml_set_attr(.e, "value", paste(dim_x, dim_y, dim_z))
	if(xml_attr(.e, "key") == "ResampleDimensions") xml_set_attr(.e, "value", paste(dim_x, dim_y, dim_z))
    }
    write_xml(.x, file.path(directory, file))
    
}

library(stringr)
library(oro.nifti)

s.dirs = list.dirs(".", full.names = T, recursive = F)
for (s.dir in s.dirs) {
    .ii = dir(s.dir, "*.nii.gz")
    if (length(.ii) > 0) {
	.i = .ii[1]
	.nii = oro.nifti::readNIfTI(file.path(s.dir, .i))
	if (oro.nifti::is.nifti(.nii)) {
	    .img = oro.nifti::img_data(.nii)
	    dim(.img)
	    .id = str_remove(.i, ".nii.gz")
	    create_snap_workspace(.id, directory = s.dir, dim_x = dim(.img)[1], dim_y = dim(.img)[2], dim_z = dim(.img)[3])
	}
    }
}


