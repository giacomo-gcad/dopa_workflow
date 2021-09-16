#!/bin/bash
##PROCESS GHS BUILTP UP: REPROJECT EACH TILE IN MOLLEWEIDE

TIL=$1
TILESIZE=$2
TILES_LIST=$3
base_indir=$4 
base_outdir=$5

for FIL in $(cat ${TILES_LIST}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
	til_inp=${base_indir}/${FIL:2:45}
	til_out=${base_outdir}/${FIL:2:45}
	zzz=`echo "${FIL:2:40}" | tr / _`
    echo "
gdalwarp -t_srs \"+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs\" -ot Byte -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=128 -co BLOCKYSIZE=128 -tr 30 30 ${til_inp} ${til_out}
"> ./dyn/proj_builtup_${zzz}.sh
    chmod u+x ./dyn/proj_builtup_${zzz}.sh
    ./dyn/proj_builtup_${zzz}.sh
done
exit
