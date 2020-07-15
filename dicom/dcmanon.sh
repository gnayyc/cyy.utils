#!/bin/sh 

cmd="gdcmanon -V -W -D -E --recursive --continue --dumb \
--empty 0010,0010 \
--empty 0010,0020 \
--empty 0010,0021 \
--empty 0010,0030 \
--empty 0010,0032 \
--empty 0010,0040 \
--empty 0010,1000 \
--empty 0010,1001 \
--empty 0010,1005 \
--empty 0010,1010 \
--empty 0010,1040 \
--empty 0010,1060 \
--empty 0010,2150 \
--empty 0010,2152 \
--empty 0010,2154 \
--empty 0020,0010 \
--empty 0038,0300 \
--empty 0038,0400 \
--empty 0040,A120 \
--empty 0040,A121 \
--empty 0040,A122 \
--empty 0040,A123 \
--empty 0008,0020 \
--empty 0008,0021 \
--empty 0008,0022 \
--empty 0008,0023 \
--empty 0008,0024 \
--empty 0008,0025 \
--empty 0008,002A \
--empty 0008,0030 \
--empty 0008,0031 \
--empty 0008,0032 \
--empty 0008,0033 \
--empty 0008,0034 \
--empty 0008,0035 \
--empty 0008,0050 \
--empty 0008,0080 \
--empty 0008,0081 \
--empty 0008,0090 \
--empty 0008,0092 \
--empty 0008,0094 \
--empty 0008,0096 \
--empty 0008,1040 \
--empty 0008,1048 \
--empty 0008,1049 \
--empty 0008,1050 \
--empty 0008,1052 \
--empty 0008,1060 \
--empty 0008,1062 \
--empty 0008,1070 \
$*"
echo $cmd
eval $cmd
