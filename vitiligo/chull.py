#!/usr/bin/env python2
# -*- coding: utf-8 -*-

"""
Generate convex hull mask from original mask

Usage:  python chull.py mask_file mask_convex_hull_file

Example: python chull.py mask.nii.gz mask_chull.nii.gz

"""

import os
import sys

if len(sys.argv) < 2:
    print(__doc__)
    sys.exit()

def do(cmd):
    print(">>>> %s" % (cmd))
    os.system(cmd)

f0 = sys.argv[1]

if len(sys.argv) > 2:
    f1 = sys.argv[2]

else:
    base = os.path.basename(f0).lower().replace(".jpg","").replace(".nii.gz","").replace(".png", "")
    f1 = base + "_chull.nii.gz"

from skimage import data, img_as_float, io
from skimage.morphology import convex_hull_image
from skimage.color import rgb2gray

i0 = io.imread(f0, plugin = "simpleitk")
#i0 = rgb2gray(i0)
#img_inv = invert(img)

i1 = convex_hull_image(i0)

io.imsave(f1, img_as_float(i1), plugin = 'simpleitk')

