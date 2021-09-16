#!/bin/bash
##COMPUTE STATISTICS ON CEP AND A USER DEFINED CATEGORICAL RASTER

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## OVERRIDE NCORES DEFINED IN CONF FILE
NCORES=40

########################################################################################################
# DEFINE CATEGORICAL RASTER (NAME OF GRASS LAYER) AND MAPSET TO BE ANALYZED WITH R.STATS
IN_RASTER="gebco2020"
IN_RASTER_MAPSET="CONRASTERS"
########################################################################################################

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="cep_"${IN_RASTER}
FINALCSV="r_univar_"${OUTCSV_ROOT}"_${wdpadate}"

## PART I: COMPUTATION OF STATISTICS

echo "Input raster: "${IN_RASTER}@${IN_RASTER_MAPSET}
echo "now running r.univar in parallel on 648 CEP tiles and "${NCORES}" threads"

for eid in {1..648}
# for eid in {109..612}
do	
	TMP_MAPSET=qwe_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${eid}
	grass ${PERMANENT_LL_MAPSET} -f --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cep_conraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV} ${CEP_MAPSET}"
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

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
