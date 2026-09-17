#!/bin/bash
## ECOREGIONS 2024 TILING

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

## SET GRASS VARIABLES
DATABASE="/globes/USERS/GIACOMO/GRASSDATA"
LOCATION="WGS84LL"
LOCATION_PATH="$DATABASE/$LOCATION"
PERMANENT_MAPSET="${DATABASE}/${LOCATION}/PERMANENT/"
ECOMAPSET="ECOREGIONS"
ECOMAPSETPATH="${DATABASE}/${LOCATION}/${ECOMAPSET}"

##grass ${PERMANENT_MAPSET} --exec g.mapset ${ECOMAPSET} -c

##grass ${ECOMAPSETPATH} --exec g.mapsets mapset=CATRASTERS operation=add

for eid in {1..648}
do
	g.region raster=ceptile_${eid}@CEP_202601 --q --o
	r.mapcalc expression=" ecoreg_${eid} = ecoregions2026_rcl " --q --o
	echo "Ecoregion tile "${eid}" done"
done

wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Tiling done in "${runtime}" minutes"
echo "---------------------------------------------------------------------------------------"
exit
