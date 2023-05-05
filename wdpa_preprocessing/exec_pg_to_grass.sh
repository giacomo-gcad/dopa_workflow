#!/bin/bash

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf


startdate_p1=`date +%s`

## Derived variables
##((NCORES=${1:-DEFAULTVALUE}))
((NTILES=${NCORES}-1))
LOCATION_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_MAPSET_PATH=${DATABASE}/${LOCATION_LL}"/PERMANENT"
PA_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${PA_MAPSET}
PA_LIST_FILE=${SERVICEDIR}/${pa_list}.txt
dbpars="-h ${host} -u ${user} -P ${pw}"
WDPA_MAPSET=${DATABASE}/${LOCATION_LL}"/WDPA_"${wdpadate}
FLAT="wdpa_flat@WDPA_"${wdpadate}


## PARALLEL PROCESSING BLOCK: EXPORT PAs TO SHAPEFILE
# Override NCORES parameter as defined in .conf file (pgsql2shp gives errors with higher values, 
# too many connections to database)
NCORES=40

((ALLPAS=$(cat ${PA_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLPAS}+(${NCORES}-1))/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
	TIL=${TIL}
	echo "./slave_pg_to_grass.sh ${SHPDIR_PA} ${pa_schema} ${PA_LIST_FILE} ${TIL} ${TILESIZE} ${host} ${user} ${db} ${pswd}"
done | parallel -j ${NCORES}

## SECOND CYCLE: REPEAT PROCESSING FOR MISSING SHPs OF PAs
# ls -l ${SHPDIR_PA}/*.shp| awk '{print $9}' FS=" "| cut -d "." -f 1| xargs -n 1 basename>./shps_pa_actually_done.csv
# echo ${SHPDIR_PA}/*.shp |xargs ls -l| awk '{print $9}' FS=" "| cut -d "." -f 1| xargs -n 1 basename>./shps_pa_actually_done.csv
# comm -23 <(sort ${PA_LIST_FILE}) <(sort ./shps_pa_actually_done.csv)>./shps_pa_to_be_repeated.csv

# MISSING_PA_LIST="shps_pa_to_be_repeated.csv"
# for PA in $(cat ${MISSING_PA_LIST})
	# do
	# ogr2ogr -f "ESRI Shapefile" ${SHPDIR_PA}/${PA} PG:"${dbpar1}" ${pa_schema}.${PA}
# done

enddate_p1=`date +%s`
partial_time1=$(((enddate_p1-startdate_p1) / 60))
echo " "
echo "Individual views for PAs exported in shapefile in ${partial_time1} minutes"
echo " "

# # IMPORT SHPs in GRASS (PAs).
startdate_p2=`date +%s`
echo " "
echo "Now importing shapefiles to GRASS DB..."
echo " "

grass ${PERMANENT_MAPSET_PATH} --exec g.mapset --q -c --overwrite mapset=${PA_MAPSET}


#IMPORT PAs
for PA in $(cat ${PA_LIST_FILE})
	do
	grass ${PA_MAPSET_PATH} --exec v.in.ogr --quiet --overwrite -o -t input=${SHPDIR_PA}/${PA}.shp output=${PA%} key=wdpaid
	wait
done

wait

enddate_p2=`date +%s`
partial_time3=$(((enddate_p2-startdate_p2) / 60))
echo " "
echo "Shapefiles imported to GRASS DB in ${partial_time3} minutes"
echo " "

wait

rm -f >${SERVICEDIR}/temp*

enddate_final=`date +%s`
runtime=$(((enddate_final-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Pas imported in GRASS in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"
exit
