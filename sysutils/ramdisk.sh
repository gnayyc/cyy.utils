#!/bin/sh

RAM=`sysctl hw.memsize|awk '{print $2}'`
R=`expr $RAM / 1073741824 / 8`

if /sbin/mount|grep RamDisk > /dev/null
then
    echo "Ramdisk already mounted!"
else
    sudo rm -rf /Volumes/Ramdisk
    sudo diskutil erasevolume HFS+ RamDisk `hdiutil attach -nomount ram://$((${R}*1024*1024*2))`
fi

