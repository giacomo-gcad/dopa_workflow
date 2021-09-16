##!/bin/bash
##COMPUTE STATISTICS ON CEP AND A USER DEFINED CATEGORICAL RASTER

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

########################################################################################################
# DEFINE CATEGORICAL RASTER (NAME OF GRASS LAYER) AND MAPSET TO BE ANALYZED WITH R.STATS
IN_RASTER1="esalc_1995"
IN_RASTER2="esalc_2015"
IN_RASTER_MAPSET="CATRASTERS"
########################################################################################################

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
OUTCSV_ROOT="cep_esa_lcc_1995_2015"
FINALCSV="r_stats_"${OUTCSV_ROOT}"_${wdpadate}"

# ## PART I: COMPUTATION OF STATISTICS
# echo "Input rasters: "${IN_RASTER1}@${IN_RASTER_MAPSET}", " ${IN_RASTER2}@${IN_RASTER_MAPSET} 
# echo "now running r.stats in parallel on 648 CEP tiles and ${NCORES} threads"

# for eid in {1..648}
# do	
	# TMP_MAPSET=rst_${eid}
	# TMP_MAPSET_PATH=${LOCATION_LL_PATH}/${TMP_MAPSET}
	# OUTCSV=${OUTCSV_ROOT}_${eid}.csv
	# grass ${PERMANENT_LL_MAPSET} --exec g.mapset --o --q -c ${TMP_MAPSET}
	# echo "./slave_cep_esa_lc_change.sh ${eid} ${TMP_MAPSET_PATH} ${RESULTSPATH} ${IN_RASTER1}@${IN_RASTER_MAPSET} ${IN_RASTER2}@${IN_RASTER_MAPSET} ${OUTCSV} ${CEP_MAPSET}"
# done | parallel -j ${NCORES}

# wait

# ## PART II: AGGREGATE CSV TILES
# echo " "
# echo "r.stats completed, now aggregating results..."
# echo " "

# rm -f ${RESULTSPATH}/${FINALCSV}.csv
# cat ${RESULTSPATH}/${OUTCSV_ROOT}*.csv >> ${RESULTSPATH}/${FINALCSV}.csv
# wait

## PART III : CREATE PG TABLE AND IMPORT FINAL CSV IN POSTGIS
echo " "
echo "Now importing csv table in Postgis..."
echo " "

psql ${dbpar2} -t -v vNAME="temp_lcc" -v vSCHEMA=${RESULTSCH} -f ./sql/create_table_rstats_lcc.sql
psql ${dbpar2} -t -c "\copy ${RESULTSCH}.temp_lcc FROM '${RESULTSPATH}/${FINALCSV}.csv' delimiter '|' csv"
psql ${dbpar2} -t -c "DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT qid,cid,lc_1995,lc_2015,area_m2 FROM results_202101_cep_in.temp_lcc;
DROP TABLE IF EXISTS ${RESULTSCH}.${FINALCSV}; CREATE TABLE ${RESULTSCH}.${FINALCSV} AS
WITH
a AS (SELECT lc_code,lc1_code,lc1_class FROM themes.class_lc_esa WHERE lc_code !=0 ORDER BY lc_code,lc1_code),
b AS (SELECT DISTINCT lc1_code,lc1_class FROM a ORDER BY lc1_code),
c AS (SELECT ROW_NUMBER () OVER () cat,a.lc1_code lc1_1995,b.lc1_code lc1_2015 FROM b a CROSS JOIN b ORDER BY a.lc1_code,b.lc1_code),
d AS (SELECT qid,cid,lc_1995,a.lc1_code lc1_1995,lc_2015,b.lc1_code lc1_2015,area_m2 FROM theme JOIN a ON a.lc_code=lc_1995 JOIN a b ON b.lc_code=lc_2015),
e AS (SELECT * FROM d NATURAL JOIN c),
f AS (SELECT qid,cid,cat,lc1_1995,lc1_2015,SUM(area_m2) area_m2 FROM e GROUP BY qid,cid,cat,lc1_1995,lc1_2015 ORDER BY qid,cid,cat),
g AS (SELECT DISTINCT f.qid,f.cid,c.cat,c.lc1_1995,c.lc1_2015 FROM f,c)
SELECT * FROM g LEFT JOIN f USING(qid,cid,cat,lc1_1995,lc1_2015) WHERE cid!=0 ORDER BY qid,cid,cat;
"
psql ${dbpar2} -t -c "DROP TABLE IF EXISTS ${RESULTSCH}.temp_lcc;"

# ## PART IV : CLEAN UP (delete mapsets and intermediate results)
# rm -rf ${LOCATION_LL_PATH}/rst_*
# echo dyn/*.sh |xargs rm -f

# for eid in {1..648}
# do	
	# rm -f  ${RESULTSPATH}/${OUTCSV_ROOT}_${eid}.csv
# done

enddate=`date +%s`
runtime=$((enddate-startdate))

echo "------------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "------------------------------------------------------------------------------------------"
echo "Stats on CEP, ${IN_RASTER1} and ${IN_RASTER2} computed in "${runtime}" seconds using "${NCORES}" cores "
echo "------------------------------------------------------------------------------------------"
exit
