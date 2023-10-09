#!/bin/bash
# IMPORT 648 BUILTUP-S TILES IN GRASS

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

# LOCAL VARIABLES
indir_root="/spatial_data/Derived_Datasets/RASTER/GHSL/R2023A/builtup/tiles_"
infile_root="builtup_tile_"
MAPSET=${DATABASE}/${LOCATION_LL}"/BUILTUP2023"

# Import individual tiff tiles with r.external
for t in {1..648}
do
	./slave_import_tiles_builtup.sh ${t} ${indir_root} ${infile_root} ${MAPSET}
done

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "BUILTUP tiles imported in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"

exit

