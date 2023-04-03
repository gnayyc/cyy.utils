#!/usr/bin/env Rscript

.fs = list.files(path=".", pattern=".csv", full.names=T, recursive=T)
.fs = .fs[.fs != "./x_all_csv.csv"]
.fs = .fs[.fs != "./meta_fat_muscle.csv"]

.f <- lapply(.fs, data.table::fread)

dt <- data.table::rbindlist(.f)

# safer way
# dt <- dplyr::bind_rows(.f)


data.table::fwrite(dt, "x_all_csv.csv")
