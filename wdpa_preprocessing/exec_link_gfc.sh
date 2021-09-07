#!/bin/bash
# IMPORT GFC TREECOVER TILES IN GRASS

date

# LOCAL VARIABLES
# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf


## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
GFC_MAPSET="GFC"
GFC_MAPSET_PATH="/globes/USERS/GIACOMO/GRASSDATA/WGS84LL/"${GFC_MAPSET}
treecover_tiles_path=${DERIVDATA}"/RASTER/GFC/treecover_over30_ll/"
lossyear_tiles_path=${DERIVDATA}"/RASTER/GFC/lossyear_over30_ll/"
gain_tiles_path=${DERIVDATA}"/RASTER/GFC/gain_over30_ll/"

grass ${PERMANENT_LL_MAPSET} --exec g.mapset -c ${GFC_MAPSET}

# # Import individual treecover tif tiles with r.external
# for ft in $(ls ${treecover_tiles_path}treecover_tile_*.tif)
# do
	# tmp=${ft#${treecover_tiles_path}}
	# outft=${tmp%.tif}
	# grass ${GFC_MAPSET_PATH} --exec r.external input=${ft} output=${outft}
# done
# wait

# Import individual lossyear tif tiles with r.external
for fl in $(ls ${lossyear_tiles_path}lossyear_tile_*.tif)
do
	tmp=${fl#${lossyear_tiles_path}}
	outfl=${tmp%.tif}
	grass ${GFC_MAPSET_PATH} --exec r.external input=${fl} output=${outfl}
done
wait

# Import individual gain tif tiles with r.external
for fg in $(ls ${gain_tiles_path}gain_tile_*.tif)
do
	tmp=${fg#${gain_tiles_path}}
	outfg=${tmp%.tif}
	grass ${GFC_MAPSET_PATH} --exec r.external input=${fg} output=${outfg}
done


echo "GFC treecover tiles imported"
date
exit

