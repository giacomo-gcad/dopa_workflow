#!/bin/bash
##PROCESS HABITAT DIVERSITY PROFILE (SEGMENTATION)
date
set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

starttime=`date +%s`

# Hardcoded variables (OVERRIDE VARIABLES FROM .conf file. SPECIFIC FOR HDI - SEGMENTATION)
DATABASE="/globes/USERS/GIACOMO/eHabitat/hdi_db"
LOCATION="global_MW"
RESULTSPATH=${RESULTSPATH}/"hdi"	
LOCATION_PATH=${DATABASE}/${LOCATION}
PERMANENT_MAPSET=${DATABASE}/${LOCATION}"/PERMANENT"
#	PA_LIST_FILE=${SERVICEDIR}/${pa_tc_list}.txt
PA_LIST_FILE=${SERVICEDIR}/${pa_tc_list}_20.txt
merged_shp=${RESULTSPATH}/"segments_pa.shp"
out_csv="segments_attr_pa.csv"

NCORES=2

echo starttime  >>${LOGPATH}/thdi.log
echo "Starting segmentation of terrestrial and coastal PAs..." >>${LOGPATH}/thdi.log

# PERFORM SEGMENTATION

mkdir -p ${RESULTSPATH}
mkdir -p ${RESULTSPATH}/shp
mkdir -p ${RESULTSPATH}/csv

## GRASS parallel processing block - PERFORM SEGMENTATION
start=0
((NTILES=${NCORES}-1))
((ALLPAS=$(cat ${PA_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLPAS}+(${NCORES}-1))/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
	cp -R ${LOCATION_PATH}/ehabitat ${LOCATION_PATH}/map${TIL}
	end=$(( ${start} + ${TILESIZE} ))
	echo "**********************************************************'"
	echo "Start at: "${start}
	echo "End at:   "${end}
	echo "**********************************************************'"
	export grassdb=${DATABASE}
	export grassloc=${LOCATION}
	export first_pa=${start}
	export last_pa=${end}
	export msn=${TIL}
	export respath=${RESULTSPATH}
	export terr_pas=${PA_LIST_FILE}
	start=${end}
	#python3 segmentation_pca_par.py ${first_pa} ${last_pa} ${msn} ${respath} ${terr_pas} ${grassdb} ${grassloc} &
done

wait

# ## AGGREGATE RESULTS
# echo "Now appending shapefiles..."  >>${LOGPATH}/thdi.log

# for i in $(find ${RESULTSPATH} -name '*.shp')
	# do
	# if [ ! -f ${merged_shp} ]; then
		# # first file - create the consolidated output file
		# ogr2ogr -f "ESRI Shapefile" ${merged_shp} ${i}
	# else
		# # update the output file with new file content
		# ogr2ogr -f "ESRI Shapefile" -update -append ${merged_shp} ${i}
	# fi
# done


# ## CREATES CSV WITH ATTRIBUTES ONLY FROM SHAPEFILE
# ogr2ogr -f CSV ${RESULTSPATH}/${out_csv} ${merged_shp}

# ## Removing intermediate results
# # remove mapsets
# for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	# do
	# rm -rf ${LOCATION_PATH}/map${TIL}
# done

# #remove tiled shapefiles
# rm -f ${RESULTSPATH}/parks_segmented*

endtime=`date +%s`
runtime=$(((endtime-starttime) / 60))
echo "Script $(basename "$0") executed in ${runtime} minutes"  >>${LOGPATH}/thdi.log

exit
