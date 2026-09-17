#!/bin/bash
## IMPORT AND PROCESS IN POSTGRES RESULTS FOR MARINE SEA SURFACE TEMPERATURE

date

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

dbpar="-h ${host} -U ${user} -d ${db}"

##CREATE TABLE TO STORE RESULTS FROM r.univar AND IMPORT RELEVANT CSV FILES (PA)
for file in $(ls ${RESULTSPATH}/pa_sst*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "\copy ${schema_climate}.${tab} FROM '${RESULTSPATH}/${file}' delimiter '|' csv" > ./dyn/copy_csv.sql
	psql ${dbpar} -t -v vNAME=${tab} -v vSCHEMA=${schema_climate} -f ./sql/create_table_runivar_no_ext.sql
	psql ${dbpar} -t -f ./dyn/copy_csv.sql
	echo "ALTER TABLE ${schema_climate}.${tab}
	ADD COLUMN wdpaid integer;
	UPDATE ${schema_climate}.${tab}
	SET wdpaid= REPLACE (pa,'pa_','')::integer;" > ./dyn/build_wdpaid_pa.sql
	psql ${dbpar} -t -f ./dyn/build_wdpaid_pa.sql
done

## POST PROCESS DATA IN POSTGRES TO CREATE TABLES READY FOR DB PROD
psql ${dbpar} -t -v PA_SCHEMA=${pa_schema} -v SCHEMA_CLIM=${schema_climate} -v DATE=${wdpadate} -f ./sql/sst_pa_postproc.sql


## REMOVE ORIGINAL TABLES
for file in $(ls ${RESULTSPATH}/pa_sst*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "DROP TABLE IF EXISTS ${schema_climate}.${tab};" | psql ${dbpar}
done
date
