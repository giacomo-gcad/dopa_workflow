#!/bin/bash
## IMPORT AND PROCESS IN POSTGRES RESULTS FOR COPERNICUS LC

date

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

dbpar="-h ${host} -U ${user} -d ${db}"

## OVERRIDE SCHEMA DEFINED IN conf FILE

##CREATE TABLE TO STORE RESULTS FROM r.stats AND IMPORT RELEVANT CSV FILES (PA)
for file in $(ls ${RESULTSPATH}/bu_cop*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	fil=${file}
	echo "\copy ${schema_results}.${tab} FROM '${RESULTSPATH}/${file}' delimiter '|' csv" > ./dyn/copy_csv.sql
	psql ${dbpar} -t -v vNAME=${tab} -v vSCHEMA=${schema_results} -f ./sql/create_table_rstats.sql
	psql ${dbpar} -t -f ./dyn/copy_csv.sql
	echo "ALTER TABLE ${schema_results}.${tab}
	ADD COLUMN wdpaid integer;
	UPDATE ${schema_results}.${tab}
	SET wdpaid= REPLACE (pa,'bu_','')::integer;" > ./dyn/build_wdpaid_pa.sql
	psql ${dbpar} -t -f ./dyn/build_wdpaid_pa.sql
done

# POST PROCESS DATA IN POSTGRES TO CREATE TABLES READY FOR DB PROD
psql ${dbpar} -t -v BU_SCHEMA=${bu_schema} -v SCHEMA_PRESSURES=${schema_results} -f ./sql/agri_copernicus_bu_postproc.sql

## REMOVE ORIGINAL TABLES
for file in $(ls ${RESULTSPATH}/bu_cop*.csv | xargs -n 1 basename)
	do
	tab=${file%.csv}
	echo "DROP TABLE IF EXISTS ${schema_results}.${tab};" | psql ${dbpar}
done

date
