#!/bin/bash
##COMPUTE STATISTICS ON CEP AND A USER DEFINED CONTINUOUS RASTER

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## OVERRIDE NCORES DEFINED IN CONF FILE
NCORES=64
CEP_MAPSET="GAUL_EEZ"
######################################
# YEAR TO BE CHECKED BEFORE RUNNING
year="2016"

######################################
########################################################################################################
# DEFINE CONTINUOUS RASTER (NAME OF GRASS LAYER) AND MAPSET TO BE ANALYZED WITH R.UNIVAR
IN_RASTER="fad5_23_${year}_masked"
IN_RASTER_MAPSET="CATRASTERS"
########################################################################################################

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="cep_"${IN_RASTER}
FINALCSV="r_univar_"${OUTCSV_ROOT}"_${wdpadate}"

startdate_w=`date +%s`

## PART I: COMPUTATION OF STATISTICS

echo "Input raster: "${IN_RASTER}@${IN_RASTER_MAPSET}
echo "now running r.univar in parallel on 648 CEP tiles and "${IN_RASTER}" using "${NCORES}" threads"

for eid in {1..648}
do	
	TMP_MAPSET=qwe_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${eid}
	grass ${PERMANENT_LL_MAPSET} -f --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cep_fad5_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV} ${CEP_MAPSET} ${year}"
done | parallel -j ${NCORES}

wait

## PART II: AGGREGATE CSV TILES

rm -f ${RESULTSPATH}/${FINALCSV}.csv
cat ${RESULTSPATH}/${OUTCSV_ROOT}_*.csv >> ${RESULTSPATH}/${FINALCSV}.csv

wait

## PART III : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
echo " "
echo "Now importing csv table in Postgis..."
echo " "

psql ${dbpar2} -t -v vNAME=${FINALCSV} -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_runivar.sql
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.${FINALCSV} FROM '${RESULTSPATH}/${FINALCSV}.csv' delimiter '|' csv"

wait

## PART IV : CLEAN UP (delete mapsets and intermediate files)
rm -rf ${LOCATION_LL_PATH}/qwe_*
rm -f ${RESULTSPATH}/${OUTCSV_ROOT}_*.csv

enddate_w=`date +%s`
runtime_w=$(((enddate_w-startdate_w) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime_w}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"

wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))
echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"

exit
