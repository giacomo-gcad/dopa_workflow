#!/bin/bash
date

startdate=`date +%s`

## Define variables
DATABASE="/globes/USERS/GIACOMO/GRASSDATA"
LOCATION="WGS84LL"
LOCATION_PATH="$DATABASE/$LOCATION"
PERMANENT_MAPSET="${DATABASE}/${LOCATION}/PERMANENT/"
TMP="tmp"
TEMPORARY_MAPSET="${DATABASE}/${LOCATION}"
INDIR="/spatial_data/Original_Datasets/GHSL/uncompressed/builtup/R2023A"
OUTDIR_ROOT="/spatial_data/Derived_Datasets/RASTER/GHSL/R2023A/builtup"
OUTROOT="builtup_tile_"
WORKDIR="/globes/processing_current/raster_processing/GHSL/dyn"

# Extent coordinates parameters in latlong
XMIN="-180" # Must be Integer
XMAX="170" # Must be Integer
YMIN="-90" # Must be Integer
YMAX="80" # Must be Integer
TX="10" # Must be Integer
TY="10" # Must be Integer

# CUTS IN TILES THE REPROJECTED DATASET
# for year in 1975 1980 1990 2000 2010 2020
for year in 2020
do
	INFILE="GHS_BUILT_S_E"${year}"_GLOBE_R2023A_4326_3ss_V1_0.tif"
	for ((i = 0 ; i <= $(((((( ${XMAX} + ${TX} ) - ${XMIN} ) / ${TX} )) * (((( ${YMAX} + ${TY} ) - ${YMIN} ) / ${TY} )))) ; i++)); # Create a dynamic variable depending of the input values from the extent ($XMIN, $XMAX, $TX, $YMIN, etc...)
	do
		for y in $(seq ${YMIN} ${TY} ${YMAX}) # sequence between min and max longitude
		do
			for x in $(seq ${XMIN} ${TX} ${XMAX}) # sequence between min and max latitude
			do
				i=$(( ${i} + 1 ))
				let "minx=${x}"
				let "miny=${y}"
				let "maxx=${x}+${TX}"
				let "maxy=${y}+${TY}"
				OUTTILE=${OUTDIR_ROOT}/tiles_${year}/${OUTROOT}${i}.tif
				echo "gdalwarp -of Gtiff -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 \
-ot UInt16 -te ${minx} ${miny} ${maxx} ${maxy} ${INDIR}/${INFILE} ${OUTTILE}
" > ${WORKDIR}/proc_${OUTROOT}${i}.sh
				chmod u+x ${WORKDIR}/proc_${OUTROOT}${i}.sh
				# ${WORKDIR}/proc_${OUTROOT}${i}.sh
			done
		done
	done
done

wait


## EXECUTE EACH DYN SCRIPT
cd ${WORKDIR}
for ff in $(find -name '*.sh')
do 
	echo ${ff}
	echo "${ff}"
done | parallel -j 32

wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Tiling done in "${runtime}" minutes"
echo "---------------------------------------------------------------------------------------"
exit
