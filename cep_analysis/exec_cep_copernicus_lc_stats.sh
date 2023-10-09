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
NCORES=32

########################################################################################################
# DEFINE CATEGORICAL RASTER (NAME OF GRASS LAYER) AND MAPSET TO BE ANALYZED WITH R.STATS
IN_RASTER="copernicus_lc_2019"
IN_RASTER_MAPSET="CATRASTERS"
########################################################################################################

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="cep_"${IN_RASTER}
FINALCSV="r_stats_"${OUTCSV_ROOT}"_${wdpadate}"

## PART I: COMPUTATION OF STATISTICS

echo "Input raster: "${IN_RASTER}@${IN_RASTER_MAPSET}
echo "now running r.stats in parallel on 648 CEP tiles and "${IN_RASTER}" using "${NCORES}" threads"

# for eid in {1..648}
for eid in {109..612}
do	
	TMP_MAPSET=rst_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${eid}.csv
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	echo "./slave_cep_catraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV} ${CEP_MAPSET}"
done | parallel -j ${NCORES}

wait

## PART II: AGGREGATE CSV TILES
echo " "
echo "r.stats completed, now aggregating results..."
echo " "

rm -f ${RESULTSPATH}/${FINALCSV}.csv
cat ${RESULTSPATH}/${OUTCSV_ROOT}*.csv >> ${RESULTSPATH}/${FINALCSV}.csv
wait

## PART IV : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
echo " "
echo "Now importing csv table in Postgis..."
echo " "

psql ${dbpar2} -t -v vNAME=${FINALCSV} -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_rstats_qid.sql
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.${FINALCSV} FROM '${RESULTSPATH}/${FINALCSV}.csv' delimiter '|' csv"
psql ${dbpar2} -t -c "DELETE FROM ${RESULTSCH}.${FINALCSV} WHERE cid =0"

## PART V : CLEAN UP (delete mapsets and intermediate results)
rm -rf ${LOCATION_LL_PATH}/rst_*
rm -f ./dyn/rstats_*.sh

# for eid in {1..648}
for eid in {109..612}

do	
	rm -f  ${RESULTSPATH}/${OUTCSV_ROOT}_${eid}.csv
done

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
