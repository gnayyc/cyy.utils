#!/usr/bin/env Rscript

suppressMessages(library(tidyverse))
suppressMessages(library(ANTsR))

## Collect arguments
args <- commandArgs(TRUE)

## Default setting when no arguments passed
if(length(args) == 0) {
    stop("Need one arguments")
} else {
    f = args[1]
    if (!file.exists(f))
	stop(paste(f, "does not exits!"))
}

d = dirname(f)
id = str_replace(basename(f), "\\..*", "")
sdir = file.path(dirname(f), paste0(id, ".fat"))

dir.create(sdir, showWarnings = FALSE)
#prefix = file.path(sdir, id, "_"fat.nii.gz")

cat("----==== Processing Abdominal CT ====----", "\n")
cat("    --           CT file:", f, "\n")
cat("    --                ID:", id, "\n")
cat("    -- Working directory:", sdir, "\n")

get.abd = function(img = NA, d = 2) {
  library(ANTsR)
  if (class(img) == "antsImage") {
    if (img@pixeltype != "float") {
      img <- antsImageClone(img, "float")
    }
  }
  
  .m.gross =img %>% getMask(-250, 2048)
  .m.abd = 
    img %>% 
    getMask(-250, -25, cleanup = 2) %>% 
    iMath("MD", d) %>% 
    iMath("FillHoles") %>% 
    iMath("ME", d)
  
  while(sum(.m.abd)/sum(.m.gross) < .9 & d < 25)
  {
    d = d + 1
    .m.abd = 
      img %>% 
      getMask(-250, -25, cleanup = 2) %>% 
      iMath("MD", d) %>% 
      iMath("FillHoles") %>% 
      iMath("ME", d)
  }
  .m.abd
}


get.fat = function(img, r = 2) # get inside/outside abdominal wall
{
  if (class(img) == "antsImage") {
    if (img@pixeltype != "float") {
      img <- antsImageClone(img, "float")
    }
  } else
  {
    return(NA)
  }
  
  .abd = get.abd(img)
  .fat = (img * .abd) %>% thresholdImage(-250, -25) 
  .soft = .abd - .fat

  .iw = # inside abdominal wall, trying to fill the hole
    .soft %>%     
    iMath("MD", 3) %>% 
    iMath("FillHoles") %>% 
    iMath("ME", 3) %>% 
    iMath("MD", 5) %>% 
    iMath("FillHoles") %>% 
    iMath("ME", 5) %>% 
    iMath("MD", 7) %>% 
    iMath("FillHoles") %>% 
    iMath("ME", 7) %>% 
    `*`(.abd) 

  .sat = (.abd - .iw) * .fat
  .vat = .fat - .sat
  
  # get back some of the SAT due to dilation procedure of VAT
  if (0)
  {
    .iw1 = .iw %>% iMath("MD", 5) # central
    .iw2 = .iw - .iw1 # peripheral
    .vat1 = .vat %>% iMath("ME", 5) %>% iMath("MD", 5) %>% `*`(.vat) # Large cluster
    .vat2 = (.vat - .vat1) * .iw2 # small and peripheral cluster
    .sat = (.sat + .vat2) %>%  iMath("GetLargestComponent") %>% `|`(.sat) # try connect
    .vat = .fat - .sat  
  }
  .label = .fat + .vat
  list(abd=.abd, fat=.fat, sat=.sat, vat=.vat, label=.label, soft=.soft)
}

i0 = f %>% antsImageRead(2)

r = get.fat(i0) 

i0 %>% antsImageWrite(file.path(sdir,paste0(id,"_0.nii.gz")))
r[["soft"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_soft.nii.gz")))
r[["fat"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_fat.nii.gz")))
r[["sat"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_sfat.nii.gz")))
r[["vat"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_vfat.nii.gz")))
r[["label"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_label.nii.gz")))

vol = 
  r[["label"]] %>% 
  labelStats(i0, .) %>%
  filter(LabelValue > 0) %>%
  mutate(key = case_when(LabelValue == 1 ~ "SAT", 
                         LabelValue == 2 ~ "VAT",
                         TRUE ~ "Others"))

write_csv(vol, file.path(sdir,paste0(id,"_stats.csv")))
