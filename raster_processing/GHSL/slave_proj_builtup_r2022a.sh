#!/bin/bash
##PROCESS GHS BUILTP UP: REPROJECT EACH TILE IN MOLLEWEIDE

TILES_LIST=$1
base_indir=$2 
base_outdir=$3

for TIL in $(cat ${TILES_LIST})
    do
	til_inp=${base_indir}/${TIL:0:45}.tif
	til_out=${base_outdir}/${TIL:0:45}.tif
	zzz=`echo "${FIL:2:40}" | tr / _`
    echo "
gdalwarp -t_srs \"+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs\" -te -180 -90 180 90 -tr 0.0008888888888 0.0008888888888 -ot UInt16 -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=128 -co BLOCKYSIZE=128 ${til_inp} ${til_out}
"> ./dyn/proj_builtup_${TIL:13:4}.sh
    chmod u+x ./dyn/proj_builtup_${TIL:13:4}.sh
    ./dyn/proj_builtup_${TIL:13:4}.sh &
done

exit

