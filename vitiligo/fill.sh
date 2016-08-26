#!/bin/sh

#bg
#102921
#32A28A
#skin
#926C53

#convert IMG_9233.JPG -channel rgba -alpha set -fuzz 10% -fill black -opaque "#32A28A" -fill black -opaque "#102921" test.png
#convert IMG_9233.JPG -channel rgba -alpha off -fuzz 15% -fill black -opaque "#32A28A" test.png

convert $1 -fuzz 10% -fill black -opaque "#32A28A" png:- |\
    convert - -fuzz 10% -fill black -opaque "#102921" png:- |\
    convert - -fuzz 10% -fill black -opaque "#4FDAC3" png:- |\
    convert - -fuzz 10% -fill black -opaque "#71ECD9" png:- |\
    convert - -fuzz 10% -fill black -opaque "#1D6050" png:- |\
    convert - -channel rgba -alpha set -fuzz 0% -fill none -opaque "#000000" png:- |\
    convert - -alpha extract png:- |\
    convert - -define connected-components:verbose=false -define connected-components:area-threshold=10000 -connected-components 8 -auto-level ${1%.*}.mask.png &&
    convert $1 ${1%.*}.mask.png -alpha Off -compose CopyOpacity -composite png:- |\
	convert - -background black -flatten ${1%.*}.masked.png


#convert color.png -channel R -separate R.png
#convert color.png -channel G -separate G.png
#convert color.png -channel B -separate B.png
#convert R.png G.png -evaluate-sequence mean RG.png
#convert G.png B.png -evaluate-sequence mean GB.png
#Convert RG.png GB.png -evaluate-sequence mean grayRGB.png

#convert color.png \
#    \( -clone 0 -channel RG -separate +channel -evaluate-sequence mean \) \
#    \( -clone 0 -channel GB -separate +channel -evaluate-sequence mean \) \
#    -delete 0 -evaluate-sequence mean color2gray1.png
