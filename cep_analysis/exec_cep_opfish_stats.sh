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
IN_RASTER_MAPSET="OPFish"

## OVERRIDE VALUES FROM CONF FILE
NCORES=64

## PART I: COMPUTATION OF STATISTICS

for year in {2003..2020}
do
	IN_RASTER="OPFish_"${year}
	OUTCSV_ROOT="cep_"${IN_RASTER}
	
	echo "now running r.univar in parallel on 648 CEP tiles and "${IN_RASTER_ROOT}" using "${NCORES}" threads"
	
	for eid in {1..648}
	do	
		TMP_MAPSET=opf_${eid}
		TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
		grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
		wait
		echo "./slave_cep_conraster_stats.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV_ROOT}${eid} ${CEP_MAPSET}"
	done | parallel -j ${NCORES}

	wait

	## PART Ib: AGGREGATE CSV TILES
	FINALCSV="r_univar_"${OUTCSV_ROOT}"_"${wdpadate}
	rm -f ${RESULTSPATH}/${FINALCSV}.csv
	cat ${RESULTSPATH}/${OUTCSV_ROOT}*.csv >> ${RESULTSPATH}/${FINALCSV}.csv

	wait

	## PART Ic : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
	echo " "
	echo "Now importing csv table in Postgis..."
	echo " "

	psql ${dbpar2} -t -v vNAME=${FINALCSV} -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_runivar.sql
	psql ${dbpar2} -t -c "\copy ${RESULTSCH}.${FINALCSV} FROM '${RESULTSPATH}/${FINALCSV}.csv' delimiter '|' csv"

	wait

	# PART Id : CLEAN UP (delete intermediate files)
	rm -f ${RESULTSPATH}/${OUTCSV_ROOT}*.csv

done

## PART II: COMPUTE AREA OF CIDs at OPFish RESOLUTION (NEEDED FOR POSTPROCESSING)
IN_RASTER="OPFish_2020"
	
for eid in {1..648}
do
	TMP_MAPSET=opf_${eid}
	TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	OUTCSV_AREA="cid_area_opf_"${eid}".csv"
	grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	wait
	echo "./slave_cid_area.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER}@${IN_RASTER_MAPSET} ${OUTCSV_AREA} ${CEP_MAPSET}"
done | parallel -j 64

rm -f ${RESULTSPATH}"/cid_area_cep_opf_"${wdpadate}".csv"
cat ${RESULTSPATH}/cid_area_opf_*.csv >> ${RESULTSPATH}"/cid_area_cep_opf_"${wdpadate}".csv"

psql ${dbpar2} -t -c "DROP TABLE IF EXISTS ${RESULTSCH}.cid_area_cep_opf_${wdpadate};
CREATE TABLE ${RESULTSCH}.cid_area_cep_opf_${wdpadate} (qid integer,cid integer,area_m2 double precision);"
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.cid_area_cep_opf_${wdpadate} FROM '${RESULTSPATH}/cid_area_cep_opf_${wdpadate}.csv' delimiter '|' csv"

wait

## PART V : CLEAN UP (delete intermediate csv, mapsets and scripts)
rm -rf ${LOCATION_LL_PATH}/opf_*
echo dyn/cid_area_*.sh |xargs rm -f
rm -f ${RESULTSPATH}/"cid_area_opf_"*.csv

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "--------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "--------------------------------------------------------------------------------------"
echo "Stats on CEP and OPFish (2 dates) computed in "${runtime}" minutes using "${NCORES}" cores "
echo "--------------------------------------------------------------------------------------"
exit
