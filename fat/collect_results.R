#!/usr/bin/env Rscript

library(tidyverse)

.fs = list.files(path=".", pattern=".*_results.csv$", full.names=T, recursive=T)
.f = vector("list", length(.fs))
.m = vector("list", length(.fs))

for (i in seq_along(.fs)) {
    cat(.fs[i],"\n")
    if (str_detect(.fs[i], "measurement_results.csv")) {
	.m[[i]] = data.table::fread(.fs[i], colClasses = 'character')
    } else {
	.f[[i]] = data.table::fread(.fs[i], colClasses = 'character')
    }
}

x = bind_rows(.f)

write_csv(x, "results.csv")
saveRDS(x, "results.rds")

x = bind_rows(.m) %>%
    mutate(sid = str_extract(id, "^[:alnum:]+")) %>%
    mutate(date = str_extract(id, "(?<=_)(\\d{8})")) %>%
    relocate(sid, date)

write_csv(x, "measurements.csv")
saveRDS(x, "measurements.rds")
