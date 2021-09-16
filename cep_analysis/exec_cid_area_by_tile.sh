#!/bin/bash
##COMPUTE STATISTICS ON CEP AND A USER DEFINED CATEGORICAL RASTER

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="cep"
FINAL_CSV="cid_area_by_tile"

## PART I : COMPUTATION OF STATISTICS
echo "CEP Version: "${CEP_MAPSET}
echo "Now running r.stats in parallel on 648 CEP tiles and "${NCORES}" cores"

for reg in {1..648}
# for reg in {71..80}
do	
	TMP_MAPSET=tmp_${reg}
	prefix=${reg}"|"
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV=${OUTCSV_ROOT}_${reg}.csv
	CSV_POSTPROC=${OUTCSV_ROOT}_${reg}_final.csv
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	echo "./slave_cid_area_by_tile.sh ${reg} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${OUTCSV} ${CEP_MAPSET}"
done | parallel -j ${NCORES}

wait

echo " "
echo "r.stats completed, now aggregating results..."
echo " "

## PART II : POST-PROCESSING OF CSV TILES (add cep tile prefix)
for reg in {1..648}
# for reg in {71..80}
do
	prefix=${reg}"|"
	CSVTILE=${OUTCSV_ROOT}_${reg}".csv"
	CSV_POSTPROC=${OUTCSV_ROOT}_${reg}"_final.csv"
	awk -v prefix="${prefix}" '{print prefix $0}' ${RESULTSPATH}/${CSVTILE} > ${RESULTSPATH}/${CSV_POSTPROC}
done

wait

## PART III : AGGREGATE  CSV TILES
rm -f ${RESULTSPATH}/${FINAL_CSV}.csv
cat ${RESULTSPATH}/*_final.csv >> ${RESULTSPATH}/${FINAL_CSV}.csv
wait

## PART IV : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
psql ${dbpar2} -t -v vNAME=${FINAL_CSV} -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_cid_area.sql
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.${FINAL_CSV} FROM '${RESULTSPATH}/${FINAL_CSV}.csv' delimiter '|' csv"
psql ${dbpar2} -t -c "DELETE FROM ${RESULTSCH}.${FINALCSV} WHERE cid =0"

## PART V : CLEAN UP (delete mapsets and intermediate results)
rm -rf ${LOCATION_LL_PATH}/tmp*
rm -f ./dyn/*.sh

for reg in {1..648}
# for reg in {71..80}
do	
	rm -f  ${RESULTSPATH}/${OUTCSV_ROOT}_${reg}.csv
done
rm -f ${RESULTSPATH}/*_final.csv

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Stats on CEP and ${IN_RASTER} computed in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"
exit
