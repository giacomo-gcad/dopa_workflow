#!/bin/bash
# IMPORT PAs-Buffers tiles IN GRASS

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf
PABU_MAPSET="PABU_FLAT_202302"
PABU_MAPSET_PATH=${DATABASE}/${LOCATION_LL}"/${PABU_MAPSET}"
## CEP_RASTER_TILES_PATH="/globes/processing_current/dopa_202202/flat_buffers_202202/raster_output/tiles"
PABU_RASTER_PATH="/spatial_data/Derived_Datasets/CEP/cep202302_buffers"
PABU_RASTER_TILES_PATH=${PABU_RASTER_PATH}"/tiles"


# LOCAL VARIABLES
grass ${PERMANENT_MAPSET_LL} --exec g.mapset -c ${PABU_MAPSET}

# Import individual tiff tiles with r.external
for t in $(cat ${PABU_RASTER_PATH}/list.txt)
do
	til=${t#"./tiles/"}
	til=${til%".tiff"}
	./slave_import_tiles_pabu_flat.sh ${til} ${PABU_MAPSET_PATH} ${PABU_RASTER_TILES_PATH}
done


rm -f dyn/import_pabu_*.sh
enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "PABU tiles import computed in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"

exit
