#!/bin/bash
##COMPUTE STATISTICS ON FLAT WITH PAs AND BUFFERS (PABU) AND A USER DEFINED CATEGORICAL RASTER

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
OUTCSV_ROOT="pabu_"${IN_RASTER}
FINALCSV="r_univar_"${OUTCSV_ROOT}"_"${wdpadate}

NCORES=40

## PART I: FIND COMMON TILES IN BOTH THEMES (PABU AND BUILTUP)
ls -1 ${DATABASE}/${LOCATION_LL}/${IN_RASTER_MAPSET}"/cell_misc"| sed 's/builtup2020_//' >builtup_tiles.txt
ls -1 ${DATABASE}/${LOCATION_LL}/${PABU_MAPSET}"/cell_misc"| sed 's/ceptile_//' >pabu_tiles.txt

comm -12 <(sort pabu_tiles.txt) <(sort builtup_tiles.txt) >pabu_builtup_common_tiles.txt

rm -f builtup_tiles*
rm -f pabu_tiles*

## PART II: COMPUTATION OF STATISTICS
echo "Input raster: "${IN_RASTER}
echo "now running r.stats in parallel on CEP tiles and "${IN_RASTER}" using ${NCORES} threads"

for eid in $(cat pabu_builtup_common_tiles.txt)
do	
	TMP_MAPSET=rst_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${eid}.csv
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	echo "./slave_cep_conraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}_${eid}@${IN_RASTER_MAPSET} ${OUTCSV} ${PABU_MAPSET}"
done | parallel -j ${NCORES}

wait

## PART III: AGGREGATE CSV TILES
echo " "
echo "r.univar completed, now aggregating results..."
echo " "

rm -f ${RESULTSPATH}/${FINALCSV}.csv
cat ${RESULTSPATH}/${OUTCSV_ROOT}*.csv >> ${RESULTSPATH}/${FINALCSV}.csv
wait

## PART IV : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
echo " "
echo "Now importing csv table in Postgis..."
echo " "

psql ${dbpar2} -t -v vNAME=${FINALCSV} -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_runivar.sql
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.${FINALCSV} FROM '${RESULTSPATH}/${FINALCSV}.csv' delimiter '|' csv"


## PART V: COMPUTE AREA OF CIDs at BUILT UP RESOLUTION (NEEDED FOR POSTPROCESSING)
IN_RASTER="builtup2020"
	
for eid in $(cat pabu_builtup_common_tiles.txt)
do
	TMP_MAPSET=rst_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV_AREA="cid_area_built_"${eid}".csv"
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cid_area.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}_${eid}@${IN_RASTER_MAPSET} ${OUTCSV_AREA} ${PABU_MAPSET}"
done | parallel -j 64

rm -f ${RESULTSPATH}"/cid_area_pabu_built2020_"${wdpadate}".csv"
cat ${RESULTSPATH}/cid_area_built_*.csv >> ${RESULTSPATH}"/cid_area_pabu_built2020_"${wdpadate}".csv"

psql ${dbpar2} -t -c "DROP TABLE IF EXISTS ${RESULTSCH}.cid_area_pabu_built2020_${wdpadate};
CREATE TABLE ${RESULTSCH}.cid_area_pabu_built2020_${wdpadate} (qid integer,cid integer,area_m2 double precision);"
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.cid_area_pabu_built2020_${wdpadate} FROM '${RESULTSPATH}/cid_area_pabu_built2020_${wdpadate}.csv' delimiter '|' csv"

wait

## PART VI : CLEAN UP (delete mapsets and intermediate results)
rm -rf ${LOCATION_LL_PATH}/rst_*
rm -f ./dyn/*.sh

for eid in  $(cat pabu_builtup_common_tiles.txt)
do	
	rm -f  ${RESULTSPATH}/${OUTCSV_ROOT}_${eid}.csv
done

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on PABU flat and ${IN_RASTER} computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
