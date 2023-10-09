#!/bin/bash
##PROCESS GLOBAL FOREST CHANGE (GAIN AND LOSSYEAR) AND GLOBAL SURFACE WATER

TIL=$1
TILESIZE=$2
TILES_LIST=$3
base_indir=$4 
base_outdir=$5

for FIL in $(cat ${TILES_LIST}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
	til_inp=${base_indir}/${FIL}
	til_out=${base_outdir}/${FIL}
    echo "
gdalwarp -t_srs \"+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs\" -ot Byte -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -tr 30 30 ${til_inp} ${til_out}
echo "${FIL} reprojected"
"> ./dyn/proj_gsw_${FIL:24:12}.sh
    chmod u+x ./dyn/proj_gsw_${FIL:24:12}.sh
    ./dyn/proj_gsw_${FIL:24:12}.sh
done
exit
