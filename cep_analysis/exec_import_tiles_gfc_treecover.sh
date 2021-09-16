#!/bin/bash
# IMPORT GFC TREECOVER TILES IN GRASS

date

# LOCAL VARIABLES
# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf


## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
GFC_MAPSET="GFC"
GFC_MAPSET_PATH="/globes/USERS/GIACOMO/GRASSDATA/WGS84LL/"${GFC_MAPSET}
tiles_path="/spatial_data/Derived_Datasets/RASTER/GFC/treecover_over30_ll/"


grass ${PERMANENT_LL_MAPSET} --exec g.mapset -c ${GFC_MAPSET}

# Import individual till tiles with r.external
for ff in $(ls ${tiles_path}treecover_tile_*.tif)
do
	tmp=${ff#${tiles_path}}
	outff=${tmp%.tif}
	grass ${GFC_MAPSET_PATH} --exec r.external input=${ff} output=${outff}
done

echo "GFC treecover tiles imported"
date
exit

