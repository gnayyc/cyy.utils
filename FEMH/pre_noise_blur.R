#!/usr/bin/env Rscript

library(imager)

ls = c("train", "test")
dir.target = "preprocessing"
dir.blurred = file.path(dir.target, "blurred")
dir.noisy = file.path(dir.target, "noisy")

dir.create(dir.target)
dir.create(dir.noisy)
dir.create(dir.blurred)

for (l in ls) {
    dir.create(file.path(dir.blurred, l))
    dir.create(file.path(dir.noisy, l))

    fs = list.files(l, full.names=T)
    for (f in fs) {
	i = load.image(f)

	i.noisy = (i + .02*rnorm(prod(dim(i)))) %>%
	    iiply("c",function(v) (v-min(v))/(max(v)-min(v)))
	i.blurred = isoblur(i, 1) %>%
	    iiply("c",function(v) (v-min(v))/(max(v)-min(v)))

	f.noisy = file.path(dir.noisy, f)
	f.blurred= file.path(dir.blurred, f)
	i.noisy %>% save.image(f.noisy)
	i.blurred %>% save.image(f.blurred)
    }
} 
