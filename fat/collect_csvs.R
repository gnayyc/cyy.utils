#!/usr/bin/env Rscript

.fs = list.files(path=".", pattern=".csv", full.names=T, recursive=T)

.f <- lapply(.fs, data.table::fread)

dt <- rbindlist(.f)

# safer way
# dt <- dplyr::bind_rows(.f)


write(dt, "x_all_csv.csv")
