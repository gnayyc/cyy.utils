#!/usr/bin/env Rscript

library(tidyverse)

.fs = list.files(path=".", pattern=".*muscle.csv$", full.names=T, recursive=T)
.f = vector("list", length(.fs))

for (i in seq_along(.fs)) {
    cat(.fs[i],"\n")
    .f[[i]] = data.table::fread(.fs[i], colClasses = 'character')
}

x = bind_rows(.f)

write_csv(x, "muscle.csv")
saveRDS(x, "muscle.rds")
