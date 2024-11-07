##!/bin/bash
##COMPUTE STATISTICS ON CEP AND A USER DEFINED CATEGORICAL RASTER

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## OVERRIDE NCORES DEFINED IN CONF FILE
NCORES=64

# # CREATES LIST OF EXISTINGS PABU TILES
# ls -1 ${DATABASE}/${LOCATION_LL}/${PABU_MAPSET}"/cell_misc"| sed 's/ceptile_//' >pabu_tiles.txt

########################################################################################################
# DEFINE CATEGORICAL RASTER (NAME OF GRASS LAYER) AND MAPSET TO BE ANALYZED WITH R.UNIVAR
IN_RASTER="nightlight_2022"
IN_RASTER_MAPSET="PERMANENT"
########################################################################################################

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="pabu_"${IN_RASTER}
FINALCSV="r_univar_"${OUTCSV_ROOT}"_${wdpadate}"

## PART I: COMPUTATION OF STATISTICS

echo "Input raster: "${IN_RASTER}
echo "now running r.univar in parallel on 648 CEP tiles and "${IN_RASTER}" using ${NCORES} threads"

for eid in $(cat pabu_tiles.txt)
do	
	TMP_MAPSET=nle_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${eid}
	grass ${PERMANENT_LL_MAPSET} -f --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cep_conraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV} ${PABU_MAPSET}"
done | parallel -j ${NCORES}

wait

## PART II: AGGREGATE CSV TILES
echo " "
echo "r.univar completed, now aggregating results..."
echo " "

rm -f ${RESULTSPATH}/${FINALCSV}.csv
cat ${RESULTSPATH}/${OUTCSV_ROOT}_*.csv >> ${RESULTSPATH}/${FINALCSV}.csv
wait

## PART IV : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
echo " "
echo "Now importing csv table in Postgis..."
echo " "

psql ${dbpar2} -t -v vNAME=${FINALCSV} -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_runivar.sql
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.${FINALCSV} FROM '${RESULTSPATH}/${FINALCSV}.csv' delimiter '|' csv"
psql ${dbpar2} -t -c "DELETE FROM ${RESULTSCH}.${FINALCSV} WHERE cid =0"


## COMPUTE AREA OF CIDs at NLE RESOLUTION

IN_RASTER="nightlight_2022"
IN_RASTER_MAPSET="PERMANENT"

for eid in $(cat pabu_tiles.txt)
do
	TMP_MAPSET=nle_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV_AREA="cid_area_pabu_nightlight_"${eid}".csv"
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cid_area.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV_AREA} ${PABU_MAPSET}"
done | parallel -j 32

rm -f ${RESULTSPATH}"/cid_area_pabu_nightlight_"${wdpadate}".csv"
cat ${RESULTSPATH}/cid_area_pabu_nightlight_*.csv >> ${RESULTSPATH}"/cid_area_pabu_nightlight_"${wdpadate}".csv"

psql ${dbpar2} -t -c "DROP TABLE IF EXISTS ${RESULTSCH}.cid_area_pabu_nightlight_${wdpadate};
CREATE TABLE ${RESULTSCH}.cid_area_pabu_nightlight_${wdpadate} (qid integer,cid integer,area_m2 double precision);"
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.cid_area_pabu_nightlight_${wdpadate} FROM '${RESULTSPATH}/cid_area_pabu_nightlight_${wdpadate}.csv' delimiter '|' csv"

wait



# PART VI : CLEAN UP (delete mapsets and intermediate results)
rm -rf ${LOCATION_LL_PATH}/nle_*
rm -f ${RESULTSPATH}/${OUTCSV_ROOT}_*.csv

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
