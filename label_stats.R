#!/usr/bin/env Rscript
args<-commandArgs(TRUE)
wdir <- args[1]
subj <- args[2]
time <- args[3]

if ( length(args) != 3 ) {
    stop("label_stats.R working_dir subject_id time_point")
}

test.location = file.path(wdir, subj, time)

if ( exists("test.location") ) {
    print(paste("Testing directory:", test.location))
}  else {
    stop(paste0("Testing directory (", test.location, ") does not exist!"))
}

suppressMessages(library(ANTsR))

mask.test = file.path(test.location, paste(subj, time,"BrainExtractionMask.nii.gz", sep="_"))
if (exists("mask.test")) {
  mask.test = antsImageRead(mask.test, 3)
  bvol = length(which(as.array(mask.test)>0))*prod(antsGetSpacing(mask.test))
  mask.test = as.array(mask.test)
  bvol.sum = length(which(mask.test>0))

  print(paste("Brain volume:", bvol))
}

seg.names = c("CSF", "Cortex", "White matter", "Deep Gray", "BrainStem", "Cerebellum")
  #seg.glob = glob2rx("*BrainSegmentation.nii.gz")
  #seg.test = list.files(path=test.location, recursive=T, full.names=T, pattern=seg.glob)[1]
seg.test = file.path(test.location, paste(subj, time, "BrainSegmentation.nii.gz", sep="_"))
seg.test = antsImageRead(seg.test, 3)
test.values = rep(0,6)

for ( i in c(1:6) ) {
    vol.test = length(which(as.array(seg.test)==i))*prod(antsGetSpacing(seg.test))

    mask.test = as.array(seg.test)
    mask.test[ mask.test != i ] = 0
    mask.test[ mask.test == i] = 1

    mask.sum = length(which(mask.test>0))

    print(paste(i, seg.names[i], "volume:", vol.test))

    test.values[i] = vol.test

}

CSF.Volume=test.values[1]
Cortex.Volume=test.values[2]
WhiteMatter.Volume=test.values[3]
DeepGray.Volume=test.values[4]
BrainStem.Volume=test.values[5]
Cerebellum.Volume=test.values[6]

# Cortical thickness

  #thick.glob = glob2rx("*CorticalThickness.nii.gz")
  #thick.test = list.files(path=test.location, recursive=T, full.names=T, pattern=thick.glob)[1]
  thick.test = file.path(test.location, paste(subj, time, "CorticalThickness.nii.gz", sep="_"))

  thick.test = as.array(antsImageRead(thick.test, 3))

  mask.test = as.array(seg.test)
  mask.test[ mask.test != 2 ] = 0
  mask.test[ mask.test == 2] = 1

  mean.ct = mean( thick.test[mask.test>0] )

  print(paste("Mean cortical thickness:", mean.ct))


# FA
  #fa.glob = glob2rx("*fa_anatomical.nii.gz")
  #fa.test = list.files(path=test.location, recursive=T, full.names=T, pattern=fa.glob)[1]
  fa.test = file.path(test.location, paste(subj, time, "fa_anatomical.nii.gz", sep="_"))
  if ( exists(fa.test) ) {

      fa.test = as.array(antsImageRead(fa.test, 3))

      mask.test = as.array(seg.test)
      mask.test[ mask.test != 3 ] = 0
      mask.test[ mask.test == 3] = 1

      mean.test = mean( fa.test[mask.test>0] )

      print(paste("Mean fractional anisotropy:", mean.test))
  }


# CBF

  #cbf.glob = glob2rx("*meancbf_anatomical.nii.gz")
  #cbf.test = list.files(path=test.location, recursive=T, full.names=T, pattern=cbf.glob)[1]
  cbf.test = file.path(test.location, paste(subj, time, "meancbf_anatomical.nii.gz", sep="_"))
  if ( exists(cbf.test) ) {
      cbf.test = as.array(antsImageRead(cbf.test, 3))

      mask.test = as.array(seg.test)
      mask.test[ mask.test != 2 ] = 0
      mask.test[ mask.test == 2] = 1

      mean.test = mean( cbf.test[mask.test>0] )

      print(paste("Mean cortical CBF:", mean.test))

      mask.test = as.array(seg.test)
      mask.test[ mask.test != 4 ] = 0
      mask.test[ mask.test == 4] = 1

      mean.test = mean( cbf.test[mask.test>0] )

      print(paste("Mean deep CBF:", mean.test))

      logdata = data.frame(logdata, DeepGrey.MeanCBF=mean.test )

      #motion.glob = glob2rx( "*PCASL_MOCOStatsFramewise.csv")
      #motion.test = list.files(path=test.location, recursive=T, full.names=T, pattern=motion.glob)[1]
      motion.test = file.path(test.location, paste(subj, time, "PCASL_MOCOStatsFramewise.csv", sep="_"))

      motion.test = read.csv(motion.test)

      n = dim(motion.test)[1]-1
      mean.test = motion.test$Mean[1:n]

      print(paste("Displacement:", mean.test))
  }

# BOLD

  #bold.glob = glob2rx("*BOLD_anatomical.nii.gz")
  #bold.test = list.files(path=test.location, recursive=T, full.names=T, pattern=bold.glob)[1]
  bold.test = file.path(test.location, paste(subj, time, "BOLD_anatomical.nii.gz", sep="_"))
  if ( exists(bold.test) ) {

      bold.test = as.array(antsImageRead(bold.test, 3))

      mask.test = as.array(seg.test)
      mask.test[ mask.test != 2 ] = 0
      mask.test[ mask.test == 2] = 1

      mean.test = mean( bold.test[mask.test>0] )

      print(paste("Mean cortical BOLD:", mean.test))

      mask.test = as.array(seg.test)
      mask.test[ mask.test != 4 ] = 0
      mask.test[ mask.test == 4] = 1

      mean.test = mean( bold.test[mask.test>0] )

      print(paste("Mean deep BOLD:", mean.test))

      #motion.glob = glob2rx( "*BOLD_MOCOStatsFramewise.csv")
      #motion.test = list.files(path=test.location, recursive=T, full.names=T, pattern=motion.glob)[1]
      motion.test = file.path(test.location, paste(subj, time, "BOLD_MOCOStatsFramewise.csv", sep="_"))

      motion.test = read.csv(motion.test)

      n = dim(motion.test)[1]-1
      mean.test = motion.test$Mean[1:n]


      print(paste("Displacement:", mean.test))

    }
# CSF.Volume=test.values[1]
# Cortex.Volume=test.values[2]
# WhiteMatter.Volume=test.values[3]
# DeepGray.Volume=test.values[4]
# BrainStem.Volume=test.values[5]
# Cerebellum.Volume=test.values[6]

# bvol
# mean.ct print(paste("Mean cortical thickness:", mean.ct))
