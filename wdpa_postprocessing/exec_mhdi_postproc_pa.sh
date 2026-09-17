#!/bin/bash
## IMPORT AND PROCESS IN POSTGRES RESULTS FOR GEBCO

date

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

dbpar="-h ${host} -U ${user} -d ${db}"

##CREATE TABLE TO STORE RESULTS FROM r.univar AND IMPORT RELEVANT CSV FILES (PA)
for file in $(ls ${RESULTSPATH}/pa_marine_gebco.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "\copy ${schema_hdi}.${tab} FROM '${RESULTSPATH}/${file}' delimiter '|' csv" > ./dyn/copy_csv.sql
	psql ${dbpar} -t -v vNAME=${tab} -v vSCHEMA=${schema_hdi} -f ./sql/create_table_runivar.sql
	psql ${dbpar} -t -f ./dyn/copy_csv.sql
	echo "ALTER TABLE ${schema_hdi}.${tab}
	ADD COLUMN wdpaid integer;
	UPDATE ${schema_hdi}.${tab}
	SET wdpaid= REPLACE (pa,'pa_','')::integer;" > ./dyn/build_wdpaid_pa.sql
	psql ${dbpar} -t -f ./dyn/build_wdpaid_pa.sql
done

## POST PROCESS DATA IN POSTGRES TO CREATE TABLES READY FOR DB PROD
psql ${dbpar} -t -v PA_SCHEMA=${pa_schema} -v SCHEMA_MHDI=${schema_hdi} -v SCHEMA_RESULTS=${schema_results} -f ./sql/mhdi_pa_postproc.sql


## REMOVE ORIGINAL TABLES
for file in $(ls ${RESULTSPATH}/pa_marine_gebco.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "DROP TABLE IF EXISTS ${schema_hdi}.${tab};" | psql ${dbpar}
done

enddate=`date +%s`
runtime=$((enddate-startdate))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Marine HDI post-processed in "${runtime}" seconds"
echo "---------------------------------------------------------------------------------------"
exit


