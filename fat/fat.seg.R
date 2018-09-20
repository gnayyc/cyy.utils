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

get.fat = function(img, d = 2, auto = F, plot=F) # get inside/outside abdominal wall
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
    iMath("FillHoles") %>% # fill
    maskImage(.gross)
  .abd.erode = 
    .abd %>% 
    iMath("ME", 2)
  .abd.rim =
    img %>% 
    thresholdImage(-75, 2048) %>% 
    maskImage(.abd -.abd.erode) 
  .abd.rim.neg = 
    (.abd.rim - 1) * -1
  
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
    maskImage(.abd.rim.neg) %>% 
    iMath("FillHoles") %>%
    iMath("MO") %>%
    iMath("GetLargestComponent") 
  .iw = 
    (.iw1 - .fat.hi) %>%
    maskImage(.iw1) %>% 
    iMath("MC") %>% 
    iMath("FillHoles") 
  .iw.tmp = .iw 
  .iw.soft = .iw * .soft
  
  ### to determine area in between abd and iw
  .x1 = .x2 = rep(0, dim(img)[1])
  .y1 = .y2 = rep(0, dim(img)[2])
  for (x in seq_along(.x1)) {
    .y = which(.iw.soft[x,]>0)
    if (length(.y) > 0) {
      .y1[x] = min(.y)
      .y2[x] = max(.y)
    }
  }
  for (y in seq_along(.y1)) {
    .x = which(.iw.soft[,y]>0)
    if (length(.x) > 0) {
      .x1[y] = min(.x)
      .x2[y] = max(.x)
    }
  }
  i1 = img %>% antsImageClone()
  i2 = img %>% antsImageClone()
  i3 = img %>% antsImageClone()
  i4 = img %>% antsImageClone()
  for (.x in 1:(dim(img)[1])) {
    for (.y in 1:(dim(img)[2])) {
      i1[.x, .y] = ifelse(.x1[.y] != 0 && .x >= .x1[.y], 1, 0)
      i2[.x, .y] = ifelse(.x2[.y] != 0 && .x <= .x2[.y], 1, 0)
      i3[.x, .y] = ifelse(.y1[.x] != 0 && .y >= .y1[.x], 1, 0)
      i4[.x, .y] = ifelse(.y1[.x] != 0 && .y <= .y2[.x], 1, 0)
    }
  }
  
  .iw = (i1+i2+i3+i4) %>% thresholdImage(3, 4)

  .soft = img %>% thresholdImage(-24, 2048) %>% maskImage(.iw)
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
  if (plot)
  {
    plot(img*.gross, .label, alpha = .4)
  }
  list(gross=.gross, abd = .abd, iw = .iw, fat=.fat, sat=.sat, vat=.vat, label=.label, soft=.soft, bone=.bone)
}

segment_ct = function(f, auto=F, plot=F)
{
  if (!file.exists(f))
  {
    cat(f, "does not exits!\n")
    return()
  }
  suppressMessages(library(tidyverse))
  suppressMessages(library(ANTsR))
  suppressMessages(library(oro.dicom))
  
  d = dirname(f)
  d0 = f %>% readDICOMFile()
  id = d0$hdr %>% extractHeader("PatientID", F)
  idate = d0$hdr %>% extractHeader("StudyDate", F)
  sid = paste(id, idate, sep = "_")

  #id = str_replace(basename(f), "\\..*", "")
  sdir = file.path(dirname(f), paste0(sid, ".fat"))
  
  dir.create(sdir, showWarnings = FALSE)
  
  cat("----==== Processing Abdominal CT ====----", "\n")
  cat("    --           CT file:", f, "\n")
  cat("    --                ID:", id, "\n")
  cat("    -- Working directory:", sdir, "\n")
  
  
  i0 = f %>% antsImageRead(2)
  
  r = get.fat(i0, plot=T) 
  if (interactive())
  {
    plot(i0*r[["gross"]], r[["label"]], alpha = .4)
  }
  
  
  i0 %>% antsImageWrite(file.path(sdir,paste0(sid,"_0anatomy.nii.gz")))
  for (i in seq_along(r))
  {
    if (stringr::str_detect(names(r)[i], "label")
	r[[i]] %>% antsImageWrite(file.path(sdir,paste0(sid,"_",i,names(r)[i],".nii.gz")))
    
  }
  
  if (T) # use manual method now
  {
    vol = 
      i0 %>% 
      labelStats(r[["label"]]) %>%
      filter(LabelValue > 0) %>%
      mutate(key = case_when(LabelValue == 1 ~ "SAT", # Subcutaneous Adipose Tissue
                             LabelValue == 2 ~ "VAT", # Visceral Adipose Tissue
                             LabelValue == 3 ~ "Soft", # Soft tissue
                             LabelValue == 4 ~ "Bone", # Bone
                             TRUE ~ "Others")) %>%
      mutate(id = id, StudyDate = idate) %>%
      mutate(`Area (cm^2)` = Volume) %>%
      mutate(`Volume (cm^3)` = Volume/2) %>%
      select(id, StudyDate, everything())
    
    write_csv(vol, file.path(sdir,paste0(sid,"_stats.csv")))
  }
}

## Collect arguments
args <- commandArgs(TRUE)


## Default setting when no arguments passed
if(length(args) == 0) {
  if (!interactive())
    dcms = list.files(".", "*.dcm")
  else
    dcms = NULL
} else {
  dcms = args
}

# dcms = file.path("fat", list.files("./fat", "*.dcm"))
if (length(dcms))
{
  for (dcm in dcms)
  {
    segment_ct(dcm)
  }
}
