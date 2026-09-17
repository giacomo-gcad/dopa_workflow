#!/bin/bash
## IMPORT AND PROCESS IN POSTGRES RESULTS FOR GHS_POP

date

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

dbpar="-h ${host} -U ${user} -d ${db}"

#OVERRIDE SCHEMA DEFINED IN CONF FILE
schema_pressures="results_202101_non_cep"

##CREATE TABLE TO STORE RESULTS FROM r.univar AND IMPORT RELEVANT CSV FILES (BU)
for file in $(ls ${RESULTSPATH}/bu_pop*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "\copy ${schema_pressures}.${tab} FROM '${RESULTSPATH}/${file}' delimiter '|' csv" > ./dyn/copy_csv.sql
	psql ${dbpar} -t -v vNAME=${tab} -v vSCHEMA=${schema_pressures} -f ./sql/create_table_runivar.sql
	psql ${dbpar} -t -f ./dyn/copy_csv.sql
	echo "ALTER TABLE ${schema_pressures}.${tab}
	ADD COLUMN wdpaid integer;
	UPDATE ${schema_pressures}.${tab}
	SET wdpaid= REPLACE (pa,'bu_','')::integer;" > ./dyn/build_wdpaid_bu.sql
	psql ${dbpar} -t -f ./dyn/build_wdpaid_bu.sql
done

## POST PROCESS DATA IN POSTGRES TO CREATE TABLES READY FOR DB PROD
psql ${dbpar} -t -v BU_SCHEMA=${bu_schema} -v SCHEMA_PRESSURES=${schema_pressures} -v SCHEMA_RESULTS=${schema_results} -v WDPADATE=${wdpadate} -f ./sql/pop_bu_postproc.sql

## REMOVE RAW TABLES
for file in $(ls ${RESULTSPATH}/bu_pop*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "DROP TABLE IF EXISTS ${schema_pressures}.${tab};" | psql ${dbpar}
done
date
