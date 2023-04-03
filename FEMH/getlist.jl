#!/usr/bin/env julia

if length(ARGS) < 5
    println(PROGRAM_FILE, " csv_with_ACCNO ln|cp|mv|bbox png|dcm source_dir output_dir [iid_column] [key_column] [key2_column]")
    println(PROGRAM_FILE, " csv_with_ACCNO bbox png|dcm source_dir output_dir iid_column bbox_column")
#			    1		    2		    3	    4		5	    6		7	    8
#			    1		    2		    3	    4		5	    6		7	    8
    exit()
end
if ARGS[2] == "bbox" && length(ARGS) < 6
    println(PROGRAM_FILE, " csv_with_ACCNO png|dcm|jpg source_dir output_dir iid_column bbox_column ")
    println(PROGRAM_FILE, " csv_with_ACCNO bbox png|dcm source_dir output_dir iid_column bbox_column")
#			    1		    2	    3	    4		5	    6	    7
    exit()
end

csv = ARGS[1]
action = ARGS[2]
ext = "." * ARGS[3]
dir1 = ARGS[4]
dir2 = ARGS[5]

println("csv file: ", csv)
using CSV, DataFrames

x = CSV.read(csv, DataFrame)

if action != "bbox"
    if length(ARGS) >= 6
	id = ARGS[6]
	fid1 = x[:, id]
	fid1 = [replace(i,r"\..*" => "") for i in fid1]
	if length(ARGS) >= 7
	    key1 = ARGS[7]
	    println("Key1: ", key1)
	    label1 = x[:, key1]
	    if length(ARGS) == 7
		csv2 = splitext(csv)[1] * "-" * key1 * ".csv"
		fid2 = string.(label1) .* "-" .* string.(fid1)
	    else
		key2 = ARGS[8]
		println("Key2: ", key2)
		label2 = x[:, key2]
		csv2 = splitext(csv)[1] * "-" * key1 * "-" * key2 * ".csv"
		fid2 = string.(label1) .* "-" .* string.(label2) .* "-" .* string.(fid1)
	    end
	else
	    fid2 = fid1
	end
    else 
	id = "ACCNO"
	fid1 = x[:, id]
	fid1 = [replace(i,r"\..*" => "") for i in fid1]
	fid2 = fid1
    end

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
	catch
	end
    end
else
    using Images, ImageDraw

    id_col = 1
    bbox_col = 3
    try 
	global id_col = parse(Int, ARGS[6])
    catch
	global id_col = ARGS[6]
    end
    try 
	global bbox_col = parse(Int, ARGS[7])
    catch
	global bbox_col = ARGS[7]
    end

    if !isdir(dir1)
      error("Source directory: ", dir1, " not exists")
    end

    if !isdir(dir2)
	Base.Filesystem.mkdir(dir2)
    end

    for row in eachrow(x)
	fid1 = row[id_col]
	fid1 = replace(fid1, r"\..*" => "")
	fid2 = fid1

	f1 = dir1 * "/" * fid1 * ext
	f2 = dir2 * "/" * fid2 * ext

	img = load(f1)
	#println(row[bbox_col])
	for y in eachmatch(r"(?<=\[)[\w ]*(?=\])", row[bbox_col])
	    x1, y1, x2, y2 = split(y.match)[1:4]
	    x1 = parse(Int, x1)
	    y1 = parse(Int, y1)
	    x2 = parse(Int, x2)
	    y2 = parse(Int, y2)
	    draw!(img, Polygon(RectanglePoints(x1, y1, x2, y2)), Gray{N0f8}(1))
	end
	save(f2, img)
    end
end
