#!/bin/bash
##COMPUTE STATISTICS ON CEP AND A USER DEFINED CONTINUOUS RASTER

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
IN_RASTER_MAPSET="POP_R2023"

## OVERRIDE VALUES FROM CONF FILE
NCORES=52

# CREATES LIST OF EXISTINGS PABU TILES
ls -1 ${DATABASE}/${LOCATION_LL}/${PABU_MAPSET}"/cell_misc"| sed 's/ceptile_//' >pabu_tiles.txt

## PART I: COMPUTATION OF STATISTICS

echo "now running r.univar in parallel on 648 CEP tiles using ${NCORES} threads"

for year in 2000 2020
do
	IN_RASTER_ROOT="pop"${year}"_"
	OUTCSV_ROOT="pabu_"${IN_RASTER_ROOT}
	FINALCSV="r_univar_"${OUTCSV_ROOT}${wdpadate}
	
	for eid in $(cat pabu_tiles.txt)
	do	
		IN_RASTER=${IN_RASTER_ROOT}${eid}
		TMP_MAPSET=pop_${eid}
		TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
		OUTCSV=${OUTCSV_ROOT}_${eid}
		grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
		wait
		echo "./slave_cep_conraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV} ${PABU_MAPSET}"
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

	## PART IV : CLEAN UP (delete intermediate files)
	rm -f ${RESULTSPATH}/${OUTCSV_ROOT}_*.csv

done


## COMPUTE AREA OF CIDs at GHS POP RESOLUTION

IN_RASTER="pop2020_109"
for eid in $(cat pabu_tiles.txt)
do
	TMP_MAPSET=pop_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV_AREA="cid_area_pabu_ghs_"${eid}".csv"
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cid_area.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV_AREA} ${PABU_MAPSET}"
done | parallel -j 32

rm -f ${RESULTSPATH}"/cid_area_pabu_ghs_pop_"${wdpadate}".csv"
cat ${RESULTSPATH}/cid_area_pabu_ghs_*.csv >> ${RESULTSPATH}"/cid_area_pabu_ghs_pop_"${wdpadate}".csv"

psql ${dbpar2} -t -c "DROP TABLE IF EXISTS ${RESULTSCH}.cid_area_pabu_ghs_pop_${wdpadate};
CREATE TABLE ${RESULTSCH}.cid_area_pabu_ghs_pop_${wdpadate} (qid integer,cid integer,area_m2 double precision);"
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.cid_area_pabu_ghs_pop_${wdpadate} FROM '${RESULTSPATH}/cid_area_pabu_ghs_pop_${wdpadate}.csv' delimiter '|' csv"

wait


## PART V : CLEAN UP (delete intermediate csv, mapsets and scripts)
rm -rf ${LOCATION_LL_PATH}/pop_*
echo dyn/cid_area_*.sh |xargs rm -f

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "--------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "--------------------------------------------------------------------------------------"
echo "Stats on CEP and ghs_pop (4 dates) computed in "${runtime}" minutes using "${NCORES}" cores "
echo "--------------------------------------------------------------------------------------"
exit
