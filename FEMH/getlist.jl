#!/usr/bin/env julia

if length(ARGS) < 5
    println(PROGRAM_FILE, " csv_with_ACCNO ln|cp|mv png|dcm source_dir output_dir [iid_column] [key_column] [key2_column]")
#			    1		    2	    3		    4		5	    6		7	    8
    exit()
end

csv = ARGS[1]
action = ARGS[2]
ext = "." * ARGS[3]
dir1 = ARGS[4]
dir2 = ARGS[5]

println("csv file: ", csv)
using CSV
x = CSV.read(csv)

if length(ARGS) >= 6
    id = ARGS[6]
    fid1 = x[:, id]
    if length(ARGS) >= 7
	key1 = ARGS[7]
	println("Key1: ", key1)
	label1 = x[:, key1]
	if length(ARGS) == 7
	    csv2 = splitext(csv)[1] * "-" * key1 * ".csv"
	    fid2 = string.(label1) .* "-" .* string.(fid1)
	    #x[:, "to"] = dir2 .* "/" .* key .* "-" .* x[:, id] .* ext
	else
	    key2 = ARGS[8]
	    println("Key2: ", key2)
	    label2 = x[:, key2]
	    csv2 = splitext(csv)[1] * "-" * key1 * "-" * key2 * ".csv"
	    fid2 = string.(label1) .* "-" .* string.(label2) .* "-" .* string.(fid1)
	    #x[:, "to"] = dir2 .* "/" .* key .* "-" .* key2 .* "-" .* x[:, id] .* ext
	end
    else
	#x[:, "to"] = dir2 .* "/" .* x[:, id] .* ext
	fid2 = fid1
    end
else 
    id = "ACCNO"
    fid1 = x[:, id]
    #x[:, "to"] = dir2 .* "/" .* x[:, id] .* ext
    fid2 = fid1
end

#x[:, "from"] = dir1 .* "/" .* x[:, id] .* ext
f1 = dir1 .* "/" .* fid1 .* ext
f2 = dir2 .* "/" .* fid2 .* ext

println("File ID: ", id)


if !isdir(dir1)
  error("Source directory: ", dir1, " not exists")
end

if !isdir(dir2)
    Base.Filesystem.mkdir(dir2)
end

println("First from: ", f1[1])
println("First to: ", f2[1])

println(action * " from ", dir1, " to ", dir2)

for i = 1:size(x, 1)
#for i = 1
    file1 = f1[i]
    file2 = f2[i]
    try
	if action == "mv"
	    mv(file1, file2)
	elseif action == "ln"
	    if Sys.iswindows()
		cp(file1, file2)
	    else
		run(`ln $file1 $file2`)
	    end
	else # cp
	    cp(file1, file2)
	end
    catch e
	continue
    end
end

