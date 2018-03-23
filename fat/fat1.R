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
	.m.fat = .i %>% thresholdImage(-250, -25) %>% `*`(.rim)
	.m.soft = .i %>% thresholdImage(-24, 2048) %>% `*`(.rim)
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
	    .m.fat = .i %>% thresholdImage(-250, -25) %>% `*`(.rim)
	    .m.soft = .i %>% thresholdImage(-24, 2048) %>% `*`(.rim)
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
  if (class(img) == "antsImage") {
    if (img@pixeltype != "float") {
      img <- antsImageClone(img, "float")
    }
  } else
  {
    return(NA)
  }
  
  #.gross = img %>% getMask(-250, 2048) %>% iMath("GetLargestComponent")
  .gross = get.gross(img)
  if (auto) # use manual method now
  {
      .gross0 = .gross
      .gross.fat = (img * .gross ) %>% thresholdImage(-250, -25)
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
	cat("d [", d, "]; abd [", sum(.abd), "]; gross [", sum(.gross), " ]\n")
	.abd = 
	  (img * .gross) %>% 
	  getMask(-250, -25, cleanup = 0) %>% 
	  iMath("MD", d) %>% 
	  iMath("FillHoles") %>% 
	  iMath("ME", d)
	d = d + 1
      }

      if (sum(.abd)/sum(.gross) < .9)
      {
	.abd = .gross
      #} else if (0) # (d > 10)
      } else if (d > 10)
      {
	.gross2 = .gross - (.gross * .abd)
	.gross2.soft = (img * .gross2) %>% getMask(20, 2048) %>% `*`(.gross2) %>% iMath("GetLargestComponent")
	.abd = .abd | .gross2.soft
      }
      .abd = .abd * .gross 

      .fat = img %>% thresholdImage(-250, -25) %>% `*`(.abd)
      #.soft = .abd - .fat
      .soft= img %>% thresholdImage(-24, 2048) %>% `*`(.abd)
      fs.ratio = sum(.fat)/sum(.soft)

      .iw0 = # inside abdominal wall, trying to fill the hole
	.soft %>%     
	iMath("MD", 4*fs.ratio) %>% 
	iMath("FillHoles") %>% 
	iMath("ME", 4*fs.ratio) %>% 
	`*`(.abd) %>%
	iMath("GetLargestComponent")
      .iw0.fiiled = (.iw0 - .soft) %>% `*`(.iw0)

      .iw = # inside abdominal wall, trying to fill the hole
	.soft %>%     
	iMath("MD", 25) %>% 
	iMath("FillHoles") %>% 
	iMath("ME", 25) %>% 
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

      #.vat.fill = .vat %>% iMath("FillHoles")
      #.vat.fill.large = .vat.fill %>% labelClusters(10000) 
      #.vat.fill.large[.vat.fill.large > 0] = 1

      if (d > 10) # if d is large, means the rim is incomplete -> some fat could be missed
	  .sat = .gross.fat - .vat

      list(abd=.abd, fat=.fat, sat=.sat, vat=.vat, label=.label, iw=.iw, soft=.soft, 
	gross=.gross0, grossfat = .gross.fat, bone=.bone)
  } else
  {
    .fat = img %>% thresholdImage(-250, -25) %>% `*`(.gross)
    .soft= img %>% thresholdImage(-24, 2048) %>% `*`(.gross)
    list(fat=.fat, soft=.soft)
  }
  #.label = .sat + .vat*2 + .soft*3 + .bone*4
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

    i0 %>% antsImageWrite(file.path(sdir,paste0(id,"_0anatomy.nii.gz")))
    for (i in seq_along(r))
    {
	r[[i]] %>% antsImageWrite(file.path(sdir,paste0(id,"_",i,names(r)[i],".nii.gz")))
    }

  if (auto) # use manual method now
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

for (dcm in dcms)
{
    segment_ct(dcm)
}
