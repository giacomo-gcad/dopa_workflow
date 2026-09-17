#!/bin/bash
##IMPORT IN GRASS GLOBAL FOREST CHANGE TILES

echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`
set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
source gfc_parameters.conf

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
GFC_MAPSET=${DATABASE}/${LOCATION_LL}"/GFC2025"

grass ${PERMANENT_LL_MAPSET} --exec g.mapset -c GFC2025

root=${base_outdir}/lossyear_over30_ll/

for fff in $(ls ${root}*.tif)
do
	tile=lossyear_${fff:72:8}
	grass ${GFC_MAPSET} --exec r.external --o --q input=${fff} output=${tile} title="Lossyear 2025v1.13 - tile n. ${fff:77:3}" -o
	echo "Tile ${tile} imported"
done

wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "--------------------------------------------------------------------"
echo "Global Forest Change - Lossyear tiles imported in GRASS in "${runtime}" minutes"
echo "--------------------------------------------------------------------"
exit
