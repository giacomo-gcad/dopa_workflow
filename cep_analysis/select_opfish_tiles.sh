#!/bin/bash
##SELECT NON NULL CEP TILES FOR OPFISH

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
IN_RASTER_MAPSET=${LOCATION_LL_PATH}"/OPFish"

for eid in {1..648}
do	
	strmax="maximum: "
	grass ${IN_RASTER_MAPSET} --exec g.region raster=ceptile_${eid}@CEP_OECM_202302 align=OPFish_2020
	xxx=`grass ${IN_RASTER_MAPSET} --exec r.univar map=OPFish_2020 |grep "maximum"`
	maxval=${xxx#"$strmax"}
	if [ ${maxval} != "-nan" ]; then 
		echo ${eid} >>opfish_tiles_selected.txt
	fi
done
