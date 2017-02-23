#!/usr/bin/env Rscript

library(dplyr)
library(tidyr)
library(readr)
library(stringr)


###                       aparc region labels
frontal = c("superiorfrontal","rostralmiddlefrontal","parsopercularis","parstriangularis","parsorbitalis","lateralorbitofrontal","medialorbitofrontal","precentral","paracentral","frontalpole","caudalmiddlefrontal")
parietal = c("superiorparietal","inferiorparietal","supramarginal","postcentral","precuneus")
temporal = c("superiortemporal","middletemporal","inferiortemporal","bankssts","fusiform","transversetemporal","entorhinal","temporalpole","parahippocampal")
occipital = c("lateraloccipital","lingual","cuneus","pericalcarine")
cingulate = c("rostralanteriorcingulate","caudalanteriorcingulate","isthmuscingulate","posteriorcingulate")
insula = c("insula")
regions = c(frontal, parietal, temporal, occipital, cingulate, insula)

label.frontal = c("Superior Frontal","Rostral Middle Frontal","Caudal Middle Frontal","Pars Opercularis","Pars Triangularis","Pars Orbitalis","Lateral Orbitofrontal","Medial Orbitofrontal","Precentral","Paracentral","Frontal Pole")
label.parietal = c("Superior Parietal","Inferior Parietal","Supramarginal","Postcentral","Precuneus")
label.temporal = c("Superior Temporal","Middle Temporal","Inferior Temporal","Banks of the Superior Temporal Sulcus","Fusiform","Transverse Temporal","Entorhinal","Temporal Pole","Parahippocampal")
label.occipital = c("Lateral Occipital","Lingual","Cuneus","Pericalcarine")
label.cingulate = c("Rostral Anterior Cingulate","Caudal Anterior Cingulate","Isthmus Cingulate","Posterior Cingulate")
label.insula = c("Insula")
labels = c(label.frontal, label.parietal, label.temporal, label.occipital, label.cingulate, label.insula)

###                         read aparc stats
fs.dir = "."
f.a2009s = dir(fs.dir, ".*a2009s.*.csv")
f.aparc = dir(fs.dir, ".*aparc.*.csv")
f.aseg = dir(fs.dir, "aseg.*.csv")
f.wm = dir(fs.dir, ".wm.*.csv")
f.lobes = dir(fs.dir, ".*h.lobes.csv")
f.asegs = dir(fs.dir, ".*aseg.csv")

aparc.files = c(f.a2009s, f.aparc)
  #'lh.a2009s.area.csv', 
  #'lh.a2009s.meancurv.csv',
  #'lh.a2009s.thickness.csv',
  #'lh.a2009s.thicknessstd.csv',
  #'lh.a2009s.vol.csv', 
  #'rh.a2009s.area.csv', 
  #'rh.a2009s.meancurv.csv',
  #'rh.a2009s.thickness.csv', 
  #'rh.a2009s.thicknessstd.csv', 
  #'rh.a2009s.vol.csv',
  #'lh.aparc.area.csv', 
  #'lh.aparc.meancurv.csv',
  #'lh.aparc.thickness.csv', 
  #'lh.aparc.thicknessstd.csv',
  #'lh.aparc.vol.csv', 
  #'rh.aparc.area.csv',
  #'rh.aparc.meancurv.csv', 
  #'rh.aparc.thickness.csv',
  #'rh.aparc.thicknessstd.csv',
  #'rh.aparc.vol.csv')

aseg.files = c(f.aseg, f.wm)
  #'aseg.mean.csv', 'aseg.std.csv', 'aseg.vol.csv',
  #'wm.mean.csv', 'wm.std.csv', 'wm.vol.csv')


aparc = tibble()
for (.a in aparc.files)
{
  cat(file.path(fs.dir, .a))
  .data = read_csv(file.path(fs.dir, .a))
  # lh_bankssts_thickness -> ctx-lh-bankssts
  # rh_G_and_S_subcentral_volume
  # names(.data) = str_replace(names(.data), "(.h)_(.*)_(.*)", "\\2")
  .var = names(.data)[1]
  .vars = str_split(.var, "\\.")[[1]]
  .hemi = .vars[1]
  .meas = rev(.vars)[1]
  .parc = rev(.vars)[2]
  names(.data) = str_replace(names(.data), "(.h)_(.*)_(.*)", "\\.\\3\\.\\1\\.\\2")
  names(.data) = paste0(.parc, names(.data))
  names(.data)[1] = "sid"
  aparc = .data %>% # mutate(sid = str_replace(sid, "\\.long\\..*", "")) %>%
    gather("key", "value", -sid) %>% 
    mutate(key = as.character(key)) %>%
    bind_rows(aparc)
    #rbind_list(aparc)
}

aseg.files = c(
  'aseg.mean.csv', 'aseg.std.csv', 'aseg.vol.csv',
  'wm.mean.csv', 'wm.std.csv', 'wm.vol.csv')
aseg.labels = c(
  'aseg.mean', 'aseg.std', 'aseg.volume',
  'wm.mean', 'wm.std', 'wm.volume')


aseg = tibble()
for (.a in aseg.files)
{
  .data = read_csv(file.path(fs.dir, .a))
  .s = str_replace(.a, ".csv", "")
  .names = names(.data)
  .hemi = ifelse(str_detect(.names, "Right|rh"), "rh",
                 ifelse(str_detect(.names, "Left|lh"), "lh", "mid"))
  names(.data) = paste0(.s,".", .hemi, ".", .names) %>%
    str_replace("^X", "")
  names(.data)[1] = "sid"
  aseg = .data %>% # mutate(sid = str_replace(sid, "\\.long\\..*", "")) %>%
    gather("key", "value", -sid) %>%
    mutate(key = as.character(key)) %>%
    bind_rows(aseg)
    #rbind_list(aseg)
}

cols = c("Lobe", "NumVert", "SurfArea", "GrayVol", "ThickAvg", "ThickStd", "MeanCurv", "GausCurv", "FoldInd", "CurvInd")
lobe = tibble()
for (.l in f.lobes)
{
  .hemi = ifelse(str_detect(.l, "rh"), "rh", "lh")
  .sid = 
      .l %>% 
      str_replace("..h.lobes.csv", "") # %>% str_replace("\\.long\\..*", "")

  lobe = 
      read.table(file.path(fs.dir, .l), col.names=cols, skip=52) %>%
	  mutate(sid = .sid, hemi = .hemi) %>%
	  bind_rows(lobe)
}

lobe = 
    lobe %>% 
    mutate(aparc = "lobe") %>%
    gather(key, value, NumVert:CurvInd) %>% 
    unite(key, aparc, key, hemi, Lobe, sep = ".")

asegs = tibble()
for (.a in f.asegs)
{
    aseg = 
	read_csv(.a) %>%
	bind_rows(asegs)
}

#fs = rbind_list(aparc, aseg) %>% 
fs = bind_rows(aparc, aseg, lobe, asegs) %>% 
  mutate(key = as.character(key)) %>%
  unique 


lobes = 
  data.frame(lobe = c(rep("Cingulate", 4),
                      rep("Frontal", 11),
                      "Insula",
                      rep("Occipital", 4),
                      rep("Parietal", 5),
                      rep("Temporal", 9)
                      ),
             label = c(cingulate, frontal, insula, occipital,
                       parietal, temporal),
             annot = c(label.cingulate, label.frontal, 
                       label.insula, label.occipital,
                       label.parietal, label.temporal)
             )

save(fs, frontal, parietal, temporal, 
     occipital, cingulate, insula, regions, 
     label.frontal, label.parietal, label.temporal, 
     label.occipital, label.cingulate, label.insula,
     labels, lobes, file= "fs.long.rdata")


