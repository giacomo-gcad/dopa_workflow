#!/bin/bash
##COMPUTE STATISTICS ON CEP AND BUILTUP 2020 (R2023A)

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

########################################################################################################
# DEFINE CATEGORICAL RASTER (NAME OF GRASS LAYER) AND MAPSET TO BE ANALYZED WITH R.STATS
IN_RASTER="builtup2020"
IN_RASTER_MAPSET="BUILTUP2023"
########################################################################################################

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="cep_"${IN_RASTER}
FINALCSV="r_univar_"${OUTCSV_ROOT}"_${wdpadate}"

NCORES=40

## PART I: COMPUTATION OF STATISTICS
echo "Input raster: "${IN_RASTER}
echo "now running r.stats in parallel on 648 CEP tiles and "${IN_RASTER}" using ${NCORES} threads"

for eid in {1..648}
do	
	TMP_MAPSET=rst_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${eid}
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	echo "./slave_cep_conraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}_${eid}@${IN_RASTER_MAPSET} ${OUTCSV} ${CEP_MAPSET}"
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

## PART IV: COMPUTE AREA OF CIDs at BUILT UP RESOLUTION (NEEDED FOR POSTPROCESSING)
	
for eid in {1..648}
do
	TMP_MAPSET=qqq_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV_AREA="cid_area_built_"${eid}".csv"
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cid_area.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}_${eid}@${IN_RASTER_MAPSET} ${OUTCSV_AREA} ${CEP_MAPSET}"
done | parallel -j 64

rm -f ${RESULTSPATH}"/cid_area_cep_built2020_"${wdpadate}".csv"
cat ${RESULTSPATH}/cid_area_built_*.csv >> ${RESULTSPATH}"/cid_area_cep_built2020_"${wdpadate}".csv"

psql ${dbpar2} -t -c "DROP TABLE IF EXISTS ${RESULTSCH}.cid_area_cep_built2020_${wdpadate};
CREATE TABLE ${RESULTSCH}.cid_area_cep_built2020_${wdpadate} (qid integer,cid integer,area_m2 double precision);"
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.cid_area_cep_built2020_${wdpadate} FROM '${RESULTSPATH}/cid_area_cep_built2020_${wdpadate}.csv' delimiter '|' csv"

wait

## PART V : CLEAN UP (delete mapsets and intermediate files)
rm -rf ${LOCATION_LL_PATH}/rst_*
rm -rf ${LOCATION_LL_PATH}/qqq_*
rm -f ${RESULTSPATH}/${OUTCSV_AREA}*.csv
echo dyn/*.sh |xargs rm -f

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
