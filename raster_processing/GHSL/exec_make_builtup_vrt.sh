#!/bin/bash
##BUILD VRT TILES AND IMPORT IN GRASS

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"

## OVERRIDE VALUES FROM CONF FILE
WORKINGDIR="/globes/processing_current/raster_processing/GHSL"
INRASTER_PATH="/spatial_data/Original_Datasets/GHSL/uncompressed/builtup/R2023A"
VRT_PATH="/spatial_data/Derived_Datasets/RASTER/GHSL/R2023A/builtup"
LIST="filelist.txt"
BUILTUP_MAPSET=${LOCATION_LL_PATH}"/BUILTUP2023"
NCORES=48


# ## PART II: PREPARING EID BOUNDING BOX TABLE (NO MORE NEEDED UNLESS EID GRID CHANGES)
# echo "now preparing table with bounding coordinates of each eid"

# psql ${dbpar2} -t -c "DROP TABLE IF EXISTS delli.eid_index; CREATE TABLE delli.eid_index AS WITH eid_grid AS (SELECT DISTINCT eid,ST_UNION(geom) geom FROM cep.grid_vector GROUP BY eid)
# SELECT 'eid_'||eid eid,ST_XMin(geom) x_min, ST_XMax(geom) x_max, ST_YMin(geom) y_min, ST_YMax(geom) y_max
# FROM eid_grid ORDER BY eid;"
# psql ${dbpar2} -t -c "\copy delli.eid_index TO '${SERVICEDIR}/eid_index.csv' delimiter '|' csv"


## PART II: PREPARING VRT
cd ${VRT_PATH}

echo "now running gdalbuildvrt on 648 tiles"

for eid in {1..648}
do
	obj=$(cat ${SERVICEDIR}/eid_index.csv |grep "eid_${eid}|")
	wcoor=$(echo ${obj} | while IFS="|" read a b c d e; do echo ${b}; done)	
	ecoor=$(echo ${obj} | while IFS="|" read a b c d e; do echo ${c}; done)
	scoor=$(echo ${obj} | while IFS="|" read a b c d e; do echo ${d}; done)
	ncoor=$(echo ${obj} | while IFS="|" read a b c d e; do echo ${e}; done)
	echo "gdalbuildvrt -overwrite -te ${wcoor} ${scoor} ${ecoor} ${ncoor} -separate -input_file_list ${VRT_PATH}/${LIST} builtup2020_${eid}".vrt""
	echo "grass ${BUILTUP_MAPSET} --exec r.external input=builtup2020_${eid}.vrt band=1 output=builtup2020_${eid} --q --o"
done | parallel -j 1
wait

cd ${WORKINGDIR}

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "--------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "--------------------------------------------------------------------------------------"
echo "Builtup vrt files prepared and imported in grass in "${runtime}" minutes"
echo "--------------------------------------------------------------------------------------"
exit
