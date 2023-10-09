#!/bin/bash
##IMPORT IN GRASS GLOBAL FOREST CHANGE TILES

echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`
set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## SET VARIABLES
base_outdir="/spatial_data/Derived_Datasets/RASTER/GFC/2022_V1.1"

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
GFC_MAPSET=${DATABASE}/${LOCATION_LL}"/GFC"

for reg in {109..612}
do
	grass ${GFC_MAPSET} --exec r.external --o --q input=${base_outdir}/treecover_over30_ll/tile_${reg}.tif output=treecover_tile_${reg} title="TreeCover2000 2022v1.1 - tile n. ${reg}"
	grass ${GFC_MAPSET} --exec r.external --o --q input=${base_outdir}/lossyear_over30_ll/tile_${reg}.tif output=lossyear_tile_${reg} title="Lossyear 2022v1.1 - tile n. ${reg}"
	grass ${GFC_MAPSET} --exec r.external --o --q input=${base_outdir}/gain_over30_ll/tile_${reg}.tif output=gain_tile_${reg} title="Gain 2022v1.1 - tile n. ${reg}"
	echo "Tile ${reg} imported"
done

wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------"
echo "Global Forest Change tiles imported in GRASS in "${runtime}" minutes"
echo "----------------------------------------------------------------"
exit
