#!/bin/bash
##IMPORT IN GRASS OPFish datasets
echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

## SET VARIABLES
DATABASE="/globes/USERS/GIACOMO/GRASSDATA" 						# CAUTION: MUST EXIST BEFORE RUNNING THE SCRIPTS!
LOCATION_LL="WGS84LL"											# CAUTION: MUST EXIST BEFORE RUNNING THE SCRIPTS!
PERMANENT_MAPSET_LL="${DATABASE}/${LOCATION_LL}/PERMANENT/"
op_dir="/spatial_data/Original_Datasets/OPFish/archives"
op_mapset="OPFish"
prefix="OPFish_"
suffix="_Earth_Feeding.tif"

grass ${PERMANENT_MAPSET_LL} --exec g.mapset OPFish -c

#FIRST PART: IMPORT INDIVIDUAL RASTERS
for year in {2003..2020}
	do
	grass ${DATABASE}/${LOCATION_LL}/${op_mapset} --exec r.external --overwrite input=${op_dir}/${prefix}${year}${suffix} output=${prefix}${year}
done
date
wait

#SECOND PART: CREATE AND MANAGE TEMPORAL SERIES
## CREATE TEMPORAL SERIES DB
grass ${DATABASE}/${LOCATION_LL}/${op_mapset} --exec g.list raster mapset=OPFish >${op_mapset}/maps_list.txt
grass ${DATABASE}/${LOCATION_LL}/${op_mapset} --exec t.create --overwrite output=opfish_ts title="Ocean Productivity available to fish" description="OP index for oceans (0-100)"

## REGISTER OP maps
grass ${DATABASE}/${LOCATION_LL}/${op_mapset} --exec t.register input=opfish_ts --overwrite file=${op_mapset}/maps_list.txt start=2003-01-01 increment="1 year"

wait
date

enddate=`date +%s`
runtime=$(((enddate-startdate)))

echo "---------------------------------------------------------------"
echo "OPFish imported in "${runtime}" seconds "
echo "---------------------------------------------------------------"
exit
