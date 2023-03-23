#!/usr/bin/env julia

if length(ARGS) < 5
    println(PROGRAM_FILE, " csv_with_ACCNO ln|cp|mv png|dcm source_dir output_dir [iid_column] [key_column] [key2_column]")
#			    1		    2	    3		    4		5	    6		7	    8
    exit()
end


using CSV, DataFrames
using Images, ImageDraw

csv_file = ARGS[1]
dir1 = ARGS[4]
dir2 = ARGS[5]


df.bbox = CSV.read(csv_file, DataFrame)
#y = eachmatch(r"(?<=\()[\w ]*(?=\))", x[1,3]) |> collect
for row in eachrow(df.bbox)
    i1 = dir1 * row[1] * ".jpg"
    i2 = dir2 * row[1] * ".jpg"
    img = load(i1)
    for y in eachmatch(r"(?<=\()[\w ]*(?=\))", row["bbox"])
	x1, y1, x2, y2 = split(y)[1:4]
	draw!(img, Polygon(RectanglePoints(x1, y1, x2, y2)), Gray{N0f8}(1))
    end
    save(i2, img)
end





