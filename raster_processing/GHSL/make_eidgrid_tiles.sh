#!/bin/bash
date

## Derived variables for GRASS
DATABASE="/globes/USERS/GIACOMO/GRASSDATA"
LOCATION="WGS84LL"
LOCATION_PATH="$DATABASE/$LOCATION"
BGB_MAPSET="${DATABASE}/${LOCATION}/BGB"
PERMANENT_MAPSET="${DATABASE}/${LOCATION}/PERMANENT/"
TMP="tmp"
TEMPORARY_MAPSET="${DATABASE}/${LOCATION}"

# Extent coordinates parameters in latlong
XMIN="-180" # Must be Integer
XMAX="170" # Must be Integer
YMIN="-90" # Must be Integer
YMAX="80" # Must be Integer
TX="10" # Must be Integer
TY="10" # Must be Integer

INDIR="/spatial_data/Original_Datasets/GHSL/uncompressed/builtup/V2-0"
INFILE="GHS_BUILT_LDSMT_GLOBE_R2018A_3857_30_V2_0.vrt"
OUTDIR="/spatial_data/Derived_Datasets/RASTER/GHSL/builtup_ll"
OUTROOT="builtup_tile_"
WORKDIR="/globes/processing_current/raster_processing/GHSL/dyn"

i=0 # variable to generate an individual mapset for each tile

for ((i = 0 ; i <= $(((((( ${XMAX} + ${TX} ) - ${XMIN} ) / ${TX} )) * (((( ${YMAX} + ${TY} ) - ${YMIN} ) / ${TY} )))) ; i++)); # Create a dynamic variable depending of the input values from the extent ($XMIN, $XMAX, $TX, $YMIN, etc...)
	do
		for y in $(seq ${YMIN} ${TY} ${YMAX}) # sequence between min and max longitude
			do
				for x in $(seq ${XMIN} ${TX} ${XMAX}) # sequence between min and max latitude
					do
					i=$(( ${i} + 1 )) # create temporary mapsets
					let "minx=${x}"
					let "miny=${y}"
					let "maxx=${x}+${TX}"
					let "maxy=${y}+${TY}"
					OUTFILE=${OUTDIR}/${OUTROOT}${i}.tif
					echo "gdalwarp -of Gtiff -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 \
-ot Byte -te ${minx} ${miny} ${maxx} ${maxy} -tr 0.000277777777778 0.000277777777778 -t_srs EPSG:4326 \
${INDIR}/${INFILE} ${OUTFILE}
gdalinfo -stats ${OUTFILE}" > ${WORKDIR}/proc_${OUTROOT}${i}.sh
					chmod u+x ${WORKDIR}/proc_${OUTROOT}${i}.sh
				done
		done
done

wait

echo "Analysis done!"
date
exit
