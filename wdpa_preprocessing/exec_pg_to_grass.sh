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
BU_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${BU_MAPSET}
PA_LIST_FILE=${SERVICEDIR}/${pa_list}.txt
BU_LIST_FILE=${SERVICEDIR}/${bu_list}.txt
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
echo ${SHPDIR_PA}/*.shp |xargs ls -l| awk '{print $9}' FS=" "| cut -d "." -f 1| xargs -n 1 basename>./shps_pa_actually_done.csv
comm -23 <(sort ${PA_LIST_FILE}) <(sort ./shps_pa_actually_done.csv)>./shps_pa_to_be_repeated.csv

MISSING_PA_LIST="shps_pa_to_be_repeated.csv"
for PA in $(cat ${MISSING_PA_LIST})
	do
	ogr2ogr -f "ESRI Shapefile" ${SHPDIR_PA}/${PA} PG:"${dbpar1}" ${pa_schema}.${PA}
done

enddate_p1=`date +%s`
partial_time1=$(((enddate_p1-startdate_p1) / 60))
echo " "
echo "Individual views for PAs exported in shapefile in ${partial_time1} minutes"
echo " "

## PARALLEL PROCESSING BLOCK: EXPORT BUFFERS TO SHAPEFILE
((ALLPAS=$(cat ${BU_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLPAS}+(${NCORES}-1))/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
	TIL=${TIL}
	echo "./slave_pg_to_grass.sh ${SHPDIR_BU} ${bu_schema} ${BU_LIST_FILE} ${TIL} ${TILESIZE} ${host} ${user} ${db} ${pswd}"
done | parallel -j ${NCORES}


## SECOND CYCLE: REPEAT PROCESSING FOR MISSING SHPs OF BUFFERS
echo ${SHPDIR_BU}/*.shp |xargs ls -l| awk '{print $9}' FS=" "| cut -d "." -f 1| xargs -n 1 basename>./shps_bu_actually_done.csv
comm -23 <(sort ${BU_LIST_FILE}) <(sort ./shps_bu_actually_done.csv)>./shps_bu_to_be_repeated.csv

MISSING_BU_LIST="shps_bu_to_be_repeated.csv"
for BU in $(cat ${MISSING_BU_LIST})
	do
	ogr2ogr -f "ESRI Shapefile" ${SHPDIR_BU}/${BU} PG:"${dbpar1}" ${bu_schema}.${BU}
done

rm -f shps_*

enddate_p2=`date +%s`
partial_time2=$(((enddate_p2-enddate_p1) / 60))
echo " "
echo "Individual views for BUs exported in shapefile in ${partial_time1} minutes"
echo " "

# # IMPORT SHPs in GRASS (PAs and BUFFERS). Buffers are erased with wdpa_flat in order to keep only the unprotected portion.
startdate_p2=`date +%s`
echo " "
echo "Now importing shapefiles to GRASS DB..."
echo " "

grass ${PERMANENT_MAPSET_PATH} --exec g.mapset --q -c --overwrite mapset=${PA_MAPSET}
grass ${PERMANENT_MAPSET_PATH} --exec g.mapset --q -c --overwrite mapset=${BU_MAPSET}

#IMPORT PAs
for PA in $(cat ${PA_LIST_FILE})
	do
	grass ${PA_MAPSET_PATH} --exec v.in.ogr --quiet --overwrite -o -t input=${SHPDIR_PA}/${PA}.shp output=${PA%} key=wdpaid
	wait
done &

#IMPORT AND PROCESS BUs
for BU in $(cat ${BU_LIST_FILE})
	do
	echo "./slave_unprot_buffer.sh ${BU} ${SHPDIR_BU} ${BU_MAPSET_PATH} ${FLAT}"
done |parallel -j 1

wait

enddate_p2=`date +%s`
partial_time3=$(((enddate_p2-startdate_p2) / 60))
echo " "
echo "Shapefiles imported to GRASS DB in ${partial_time3} minutes"
echo " "

#DELETE BUFFERS WITH EMPTY GEOMETRIES
echo " "
echo "Now removing buffers with empty geometries (fully protected buffers)..."
echo " "

for BU in $(cat ${BU_LIST_FILE})
	do
	## the following is aimed to write a list of buffers resulting in empty geometry (i.e. buffers fully protected by other PAs)
	mm=`grass ${BU_MAPSET_PATH} --exec v.report map=${BU} option=coor| tail -n +1|wc -l`
	if (( ${mm} == 1 ))
	then echo ${BU}>>${WORKINGDIR}/bus_to_be_deleted.csv
	grass ${BU_MAPSET_PATH} --exec g.remove type=vector name=${BU} -f
	fi
done |parallel -j 1

wait

#UPDATE LIST files  OF BUs
for BU in $(cat ${WORKINGDIR}/bus_to_be_deleted.csv)
do
	# UPDATE FULL LIST
	grep -w -v ${BU} ${SERVICEDIR}/${bu_list}.txt >${SERVICEDIR}/temp_bu.txt
	mv ${SERVICEDIR}/temp_bu.txt ${SERVICEDIR}/${bu_list}.txt
	# UPDATE LIST OF TERRESTRIAL AND COASTAL PAs
	grep -w -v ${BU} ${SERVICEDIR}/${bu_tc_list}.txt >${SERVICEDIR}/temp_bu_tc.txt
	mv ${SERVICEDIR}/temp_bu_tc.txt ${SERVICEDIR}/${bu_tc_list}.txt
	# UPDATE LIST OF MARINE PAs
	grep -w -v ${BU} ${SERVICEDIR}/${bu_ma_list}.txt >${SERVICEDIR}/temp_bu_ma.txt
	mv ${SERVICEDIR}/temp_bu_ma.txt ${SERVICEDIR}/${bu_ma_list}.txt
done

enddate_p3=`date +%s`
partial_time4=$(((enddate_p3-enddate_p2) / 60))
echo " "
echo "Buffers with empty geometries removed in ${partial_time4} minutes"
echo " "

rm -f ${WORKINGDIR}/bus_to_be_deleted.csv
rm -f >${SERVICEDIR}/temp*
# rm -f ./dyn/unprot_buffer.sh

enddate_final=`date +%s`
runtime=$(((enddate_final-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Pas and buffers imported in GRASS in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"
exit
