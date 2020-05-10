#!/usr/bin/env julia

if length(ARGS) < 3
    error(PROGRAM_FILE, " csv_with_ACCNO source_dir output_dir [iid_column] [key_column] [key2_column]")
    exit()
end

ext = ".dcm"
csv = ARGS[1]
dir1 = ARGS[2]
dir2 = ARGS[3]

println("csv file: ", csv)
using CSV
x = CSV.read(csv)

if length(ARGS) >= 4
    id = ARGS[4]
    if length(ARGS) >= 5
	key = ARGS[5]
	if length(ARGS) == 5
	    csv2 = splitext(csv)[1] * "-" * key * ".csv"
	    x[:, "to"] = dir2 .* "/" .* key .* "-" .* x[:, id] .* ext
	else
	    key2 = ARGS[6]
	    csv2 = splitext(csv)[1] * "-" * key * "-" * key2 * ".csv"
	    x[:, "to"] = dir2 .* "/" .* key .* "-" .* key2 .* "-" .* x[:, id] .* ext
	end
    end
else 
    id = "ACCNO"
    x[:, "to"] = dir2 .* "/" .* x[:, id] .* ext
end

println("File ID: ", id)


if !isdir(dir1)
  error("Source directory: ", dir1, " not exists")
end

if !isdir(dir2)
    Base.Filesystem.mkdir(dir2)
end

println("Dir1: ", dir1)
x[:, "from"] = dir1 .* "/" .* x[:, id] .* ext

println("First from: ", x[1,"from"])
println("Dir2: ", dir2)

println("Copy from ", dir1, " to ", dir2)

for i = 1:size(x, 1)
    from = x[i, "from"]
    to = x[i, "to"]
    cmd = `ln $from $to`
    try
	run(cmd)
    catch e
	continue
    end
end

