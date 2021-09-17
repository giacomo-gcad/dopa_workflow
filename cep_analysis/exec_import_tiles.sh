#!/bin/bash
# IMPORT 648 CEP TILES IN GRASS

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

# LOCAL VARIABLES
grass ${PERMANENT_MAPSET_LL} --exec g.mapset -c ${CEP_MAPSET}

# Import individual till tiles with r.external
for t in {1..648}
do
	./slave_import_tiles.sh ${t} ${CEP_MAPSET_PATH} ${CEP_RASTER_TILES_PATH}
done

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"

exit

