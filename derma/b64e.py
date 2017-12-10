#!/usr/bin/env python2
# -*- coding: utf-8 -*-

"""
Encode filename in a directory and copy them to another directory

Usage:  python b64.py dir1 dir2

"""

import os
import base64
import sys
import errno
import piexif
from shutil import copyfile


if not len(sys.argv) == 3:
    print(__doc__)
    sys.exit()

d1 = sys.argv[1]
d2 = sys.argv[2]

if os.path.isdir(d1):
    if not os.path.isdir(d2):
        try:
            os.makedirs(d2)
        except OSError as e:
            if e.errno != errno.EEXIST:
                raise
    print("%s,%s" % ("file1","file2"))

    for root, dirs, files in os.walk(d1, topdown=False):
        for f in files:
            if os.path.splitext(f)[1].lower() in ('.jpg','.jpeg'):
                f1 = os.path.join(root, f)
                f2 = os.path.join(d2, 
                    "".join((base64.urlsafe_b64encode(os.path.splitext(f)[0]),
                    os.path.splitext(f)[1])))
                copyfile(f1, f2)
                print("%s,%s" % (f1,f2))

                ex = piexif.load(f1)
                ex['0th'][piexif.ImageIFD.Artist] = ""
                piexif.insert(piexif.dump(ex), f2)

else:
    print("%s not exists!" % d1)
    sys.exit()
