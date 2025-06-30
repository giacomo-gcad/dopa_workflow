#!/bin/bash
## SET VARIABLES
DATABASE="/globes/USERS/GIACOMO/GRASSDATA" 						# CAUTION: MUST EXIST BEFORE RUNNING THE SCRIPTS!
LOCATION_LL="WGS84LL"											# CAUTION: MUST EXIST BEFORE RUNNING THE SCRIPTS!
PERMANENT_MAPSET_LL="${DATABASE}/${LOCATION_LL}/PERMANENT/"

base_indir="/spatial_data/Original_Datasets/HILDA+/uncompressed/hildap_vGLOB-1.0_geotiff_wgs84/hildap_GLOB-v1.0_lulc-states"
TILES_LIST=${base_indir}"/list.txt"

find ${base_indir}/*.tif > ${TILES_LIST}

for FIL in $(cat ${TILES_LIST})

do
	year=${FIL:123:4}
	grass ${DATABASE}/${LOCATION_LL}/HILDA --exec r.external -o --q --overwrite input=${FIL} output=hilda_${year}
	echo "HILDA ${year} imported."
done

exit

