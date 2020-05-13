#!/usr/bin/env julia

if length(ARGS) < 5
    println(PROGRAM_FILE, " csv_with_ACCNO ln|cp|mv png|dcm source_dir output_dir [iid_column] [key_column] [key2_column]")
#			    1		    2	    3		    4		5	    6		7	    8
    exit()
end

csv = ARGS[1]
action = ARGS[2]
ext = ARGS[3]
dir1 = ARGS[4]
dir2 = ARGS[5]

println("csv file: ", csv)
using CSV
x = CSV.read(csv)

if length(ARGS) >= 6
    id = ARGS[6]
    if length(ARGS) >= 7
	key = ARGS[7]
	if length(ARGS) == 7
	    csv2 = splitext(csv)[1] * "-" * key * ".csv"
	    x[:, "to"] = dir2 .* "/" .* key .* "-" .* x[:, id] .* ext
	else
	    key2 = ARGS[8]
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
    if cmd == "mv"
	cmd = Sys.iswindows() ? `move $from $to` : `mv $from $to`
    elseif cmd == "ln"
	cmd = Sys.iswindows() ? `copy $from $to` : `ln $from $to`
    else # cp
	cmd = Sys.iswindows() ? `copy $from $to` : `cp $from $to`

    
    try
	run(cmd)
    catch e
	continue
    end
end

