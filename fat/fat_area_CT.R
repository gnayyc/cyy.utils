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

get.abd = function(img = NA, d = 0) {
  library(ANTsR)
  if (class(img) == "antsImage") {
    if (img@pixeltype != "float") {
      img <- antsImageClone(img, "float")
    }
  }
  
  .gross =img %>% getMask(-250, 2048)
  .gross1 = .gross %>% iMath("ME", 20)
  .gross2 = .gross - .gross1
  .gross2.soft = (img * .gross2) %>% thresholdImage(-24,2048)
  .gross2.fat = (img * .gross2) %>% thresholdImage(-250,-25)
  .gross3.fat = .gross2.fat %>% iMath("ME",2) %>% iMath("MD", 2)
  .abd = 
    (img * .gross) %>% 
    getMask(-250, -25, cleanup = 2) %>% 
    iMath("MD", d) %>% 
    iMath("FillHoles") %>% 
    iMath("ME", d)
  
  while(sum(.abd)/sum(.gross) < .9 & d < 50)
  {
    cat("d = ", d, "\n")
    .abd = 
      (img * .gross3.fat) %>% 
      getMask(-250, -25, cleanup = 0) %>% 
      iMath("MD", d) %>% 
      iMath("FillHoles") %>% 
      iMath("ME", d)
    d = d + 1
  }
  if (sum(.abd)/sum(.gross) < .9)
    .abd = .gross
  .abd
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
    `*`(.abd) %>%
    iMath("GetLargestComponent")

  .sat = (.abd - .iw) * .fat
  .vat = .fat - .sat
  
  # get back some of the SAT due to dilation procedure of VAT
  .iw1 = .iw %>% iMath("ME", 25) # central
  .iw2 = .iw - .iw1 # peripheral
  .vat1 = .vat %>% labelClusters(500) # Large cluster
  .vat1[.vat1 > 0] = 1
  .vat2 = (.vat - .vat1) * .iw2 # small and peripheral cluster
  .sat1 = (.sat + .vat2) %>% labelClusters(10000) # %>% iMath("ME", 1) %>% iMath("MD", 1) %>% `|`(.sat) %>% `*`(.fat) # try connect
  .sat1[.sat1 > 0] = 1
  .sat = .sat1
  .vat = .fat - .sat

  .iw.soft = .iw * .soft
  .bone = (img * .iw) %>% thresholdImage(100, 2048) %>% iMath("FillHoles") %>% labelClusters(100)
  .bone[.bone > 0] = 1
  .soft = .soft - (.soft * .bone)
  .vat = .vat - (.vat * .bone)

  .vat.fill = .vat %>% iMath("FillHoles")
  .vat.fill.large = .vat.fill %>% labelClusters(10000) 
  .vat.fill.large[.vat.fill.large > 0] = 1


  .label = .sat + .vat*2 + .soft*3 + .bone*4
  list(abd=.abd, fat=.fat, sat=.sat, vat=.vat, label=.label, soft=.soft, iw=.iw, soft=.soft, bone=.bone)
}

i0 = f %>% antsImageRead(2)

r = get.fat(i0) 

i0 %>% antsImageWrite(file.path(sdir,paste0(id,"_0anatomy.nii.gz")))
r[["abd"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_1abd.nii.gz")))
r[["iw"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_2iw.nii.gz")))
r[["fat"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_3fat.nii.gz")))
r[["soft"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_4soft.nii.gz")))
r[["bone"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_5bone.nii.gz")))
r[["sat"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_6sat.nii.gz")))
r[["vat"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_7vat.nii.gz")))
r[["label"]] %>% antsImageWrite(file.path(sdir,paste0(id,"_0label.nii.gz")))

vol = 
  r[["label"]] %>% 
  labelStats(i0, .) %>%
  filter(LabelValue > 0) %>%
  mutate(key = case_when(LabelValue == 1 ~ "SAT", # Subcutaneous Adipose Tissue
                         LabelValue == 2 ~ "VAT", # Visceral Adipose Tissue
                         LabelValue == 3 ~ "Soft", # Soft tissue
                         LabelValue == 4 ~ "Bone", # Bone
                         TRUE ~ "Others"))

write_csv(vol, file.path(sdir,paste0(id,"_stats.csv")))
