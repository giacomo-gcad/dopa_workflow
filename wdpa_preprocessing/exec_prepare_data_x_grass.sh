#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

# set local
LC_TIME=en_US.utf8

# SET DERIVED VARIABLES
dbpar="-h ${host} -U ${user} -d ${db}"
PA_LIST_FILE=${SERVICEDIR}/${pa_list}".txt"
PA_TC_LIST_FILE=${SERVICEDIR}/${pa_tc_list}".txt"
PA_MA_LIST_FILE=${SERVICEDIR}/${pa_ma_list}".txt"

# CREATE SCHEMAS AND LISTS. EXPORTS LISTS IN .txt FILE
psql ${dbpar} -v paschema=${pa_schema} -v wdpaschema=${wdpa_schema} -v vDATE=${wdpadate} -f ${SQLDIR}/prepare_data_x_grass.sql

psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_pa) to '${PA_LIST_FILE}' with csv'
psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_pa_tc) to '${PA_TC_LIST_FILE}' with csv'
psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_pa_ma) to '${PA_MA_LIST_FILE}' with csv'

echo " "
echo "Schemas and lists for PAs and buffers created"
echo " "

# CREATE INDIVIDUAL VIEWS FOR PAs
for PA in $(cat ${PA_LIST_FILE})
    do
    echo "DROP VIEW IF EXISTS ${pa_schema}.${PA};
    CREATE VIEW ${pa_schema}.${PA} AS
            SELECT a.wdpaid,a.gname,a.geom
            FROM (SELECT wdpaid,'pa_'||wdpaid::text gname,geom FROM ${wdpa_schema}.wdpa_wdoecm_o5_${wdpadate}) a
            WHERE a.gname='${PA}'
	"|psql ${dbpar} 
done

echo " "
echo "Individual views for PAs created"
echo " "

enddate_final=`date +%s`
runtime=$(((enddate_final-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Runtime: "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"
exit
