#!/usr/bin/env Rscript

get.gross = function(img, peel = F, lower=-250, higher=2048)
{
  library(ANTsR)
  if (class(img) == "antsImage") {
    if (img@pixeltype != "float") {
      img <- antsImageClone(img, "float")
    }
  } else
  {
    return(NA)
  }
  
  .m = img %>% getMask(lower, higher) %>% iMath("GetLargestComponent")
  if (peel)
  {
    .m1 = .m %>% iMath("ME", 2) 
    .rim = .m - .m1
    .m = .m1
    .i = img * .rim
    .m.fat = .i %>% thresholdImage(-250, -25) %>% maskImage(.rim)
    .m.soft = .i %>% thresholdImage(-24, 2048) %>% maskImage(.rim)
    cat("fat/soft = ", sum(.m.fat), "/", sum(.m.soft), "\n")
    
    r = 2
    while(sum(.m.soft) > sum(.m.fat))
    {
      r = r + 1
      cat("r = ", r, "\n")
      .m1 = .m %>% iMath("ME", 1) 
      .rim = .m - .m1
      .m = .m1
      .i = img * .rim
      .m.fat = .i %>% thresholdImage(-250, -25) %>% maskImage(.rim)
      .m.soft = .i %>% thresholdImage(-24, 2048) %>% maskImage(.rim)
      cat("fat/soft = ", sum(.m.fat), "/", sum(.m.soft), "\n")
      sum(.m.soft) < sum(.m.fat)
      break
    }
    .m = .m %>% iMath("MD", 1)
  }
  .m
}

get.fat = function(img, d = 2, auto = F) # get inside/outside abdominal wall
{
  library(ANTsR)
  library(tidyverse)
  devel = T
  
  if (class(img) == "antsImage") {
    if (img@pixeltype != "float") {
      img <- antsImageClone(img, "float")
    }
  } else
  {
    return(NA)
  }
  
  
  #.gross = img %>% getMask(-250, 2048) %>% iMath("GetLargestComponent")
  # dcms = file.path("fat", list.files("./fat", "*.dcm"))
  # img = dcms[1] %>% antsImageRead(2)
  .gross = get.gross(img)
  .fat   = img %>% thresholdImage(-250, -25) %>% maskImage(.gross)
  .soft  = img %>% thresholdImage(-24, 2048) %>% maskImage(.gross)
  .soft2 = img %>% thresholdImage(-75, 2048) %>% maskImage(.gross)
  
  .abd = 
    img %>% # Close inside subcutaneous fat
    thresholdImage(-250, -25) %>% # fat 
    maskImage(.gross) %>% # in gross
    iMath("MO", 2) %>% # remove edge
    iMath("FillHoles") %>% # fill
    labelClusters(100) %>% # remove small
    thresholdImage(1, 100) %>% # binary
    iMath("MC", 75) %>% # close
    iMath("FillHoles") # fill
  .iw = 
    img %>% # Strictly close inside abdominal muscle
    thresholdImage(-24, 2048) %>% # soft
    maskImage(.abd) %>% # in abd
    iMath("MO", 1) %>% # remove edge
    iMath("FillHoles") %>% # fill
    labelClusters(100) %>% # remove small
    thresholdImage(1, 100) %>% # binary
    iMath("MC", 50) %>% # close
    iMath("FillHoles") # fill
  .fat.hi = 
    img %>% # Loosely close inside abdominal muscle 
    thresholdImage(-75, -25) %>% # high density fat
    maskImage(.abd) 
  .fat.lo = 
    img %>% # Loosely close inside abdominal muscle 
    thresholdImage(-250, -76) %>% # high density fat
    maskImage(.abd) 
  .iw1 = 
    (.fat.hi + .soft) %>% 
    iMath("FillHoles") %>%
    iMath("MO") %>%
    iMath("GetLargestComponent") 
  .iw = 
    (.iw1 - .fat.hi) %>%
    maskImage(.iw1) %>% 
    iMath("MC") %>% 
    iMath("FillHoles") 
  
  
  .soft= img %>% thresholdImage(-24, 2048) %>% maskImage(.iw)
  .sat = .fat - (.fat * .iw)
  .vat = .fat - .sat
  .bone = img %>% maskImage(.iw) %>% 
    thresholdImage(100, 2048) %>% 
    iMath("FillHoles") %>% 
    labelClusters() %>% 
    thresholdImage(1, 100)
  .soft = .soft - (.soft * .bone)
  .vat = .vat - (.vat * .bone)
  .label = .sat + .vat*2 + .soft*3 + .bone*4
  # if (interactive())
  # {
  #   plot(img*.gross, .label, alpha = .4)
  # }
  list(gross=.gross, abd = .abd, iw = .iw, fat=.fat, sat=.sat, vat=.vat, label=.label, soft=.soft, bone=.bone)
}

segment_ct = function(f, auto=F)
{
  if (!file.exists(f))
  {
    cat(f, "does not exits!\n")
    return
  }
  suppressMessages(library(tidyverse))
  suppressMessages(library(ANTsR))
  
  d = dirname(f)
  id = str_replace(basename(f), "\\..*", "")
  sdir = file.path(dirname(f), paste0(id, ".fat"))
  
  dir.create(sdir, showWarnings = FALSE)
  #prefix = file.path(sdir, id, "_"fat.nii.gz")
  
  cat("----==== Processing Abdominal CT ====----", "\n")
  cat("    --           CT file:", f, "\n")
  cat("    --                ID:", id, "\n")
  cat("    -- Working directory:", sdir, "\n")
  
  
  i0 = f %>% antsImageRead(2)
  
  r = get.fat(i0) 
  if (interactive())
  {
    plot(i0*r[["gross"]], r[["label"]], alpha = .4)
  }
  
  
  i0 %>% antsImageWrite(file.path(sdir,paste0(id,"_0anatomy.nii.gz")))
  for (i in seq_along(r))
  {
    r[[i]] %>% antsImageWrite(file.path(sdir,paste0(id,"_",i,names(r)[i],".nii.gz")))
  }
  
  if (T) # use manual method now
  {
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
  }
}

## Collect arguments
args <- commandArgs(TRUE)


## Default setting when no arguments passed
if(length(args) == 0) {
  dcms = list.files(".", "*.dcm")
} else {
  dcms = args
}

# dcms = file.path("fat", list.files("./fat", "*.dcm"))

for (dcm in dcms)
{
  segment_ct(dcm)
}
