#!/bin/bash
## IMPORT AND PROCESS IN POSTGRES RESULTS FOR BUILTUP v.2

date

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

dbpar="-h ${host} -U ${user} -d ${db}"

##CREATE TABLE TO STORE RESULTS FROM r.univar AND IMPORT RELEVANT CSV FILES (PA)
for file in $(ls ${RESULTSPATH}/bu_built*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	fil=${file}
	echo "\copy ${schema_pressures}.${tab} FROM '${RESULTSPATH}/${file}' delimiter '|' csv" > ./dyn/copy_csv.sql
	psql ${dbpar} -t -v vNAME=${tab} -v vSCHEMA=${schema_pressures} -f ./sql/create_table_rstats.sql
	psql ${dbpar} -t -f ./dyn/copy_csv.sql
	echo "ALTER TABLE ${schema_pressures}.${tab}
	ADD COLUMN wdpaid integer;
	UPDATE ${schema_pressures}.${tab}
	SET wdpaid= REPLACE (pa,'bu_','')::integer;" > ./dyn/build_wdpaid_bu.sql
	psql ${dbpar} -t -f ./dyn/build_wdpaid_bu.sql
done

## POST PROCESS DATA IN POSTGRES TO CREATE TABLES READY FOR DB PROD
psql ${dbpar} -t -v BU_SCHEMA=${bu_schema} -v SCHEMA_PRESSURES=${schema_pressures} -v SCHEMA_RESULTS=${schema_results} -v WDPADATE=${wdpadate} -f ./sql/builtup_bu_postproc.sql

## REMOVE ORIGINAL TABLES
for file in $(ls ${RESULTSPATH}/bu_built*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "DROP TABLE IF EXISTS ${schema_pressures}.${tab};" | psql ${dbpar}
done

date
