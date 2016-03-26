#!/bin/zsh

foreach f in *.tiff
    convert -units PixelsPerInch $f -background white -alpha remove -alpha off -flatten -density 600 -compress lzw $f
end

