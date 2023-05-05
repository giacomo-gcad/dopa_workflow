#!/bin/bash
## THIS SCRIPT WRITES A TABLE WITH BUFFERS FOR PAs OVER 1 KM.
## IT HAS TO BE USED TO PREPARE THE INPUT FOR COMPUTATION OF UNPROTECTED BUFFERS USING THE CEP WORKFLOW


echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_wdoecm_preprocessing.conf

# set local
LC_TIME=en_US.utf8

# SET DERIVED VARIABLES
dbpar2="-h ${host} -U ${user} -d ${db} -w"

## PRE-PROCESS WDPA
echo "Now processing wdpa buffers - 10 km...
"

psql ${dbpar2} -v vSCHEMA=${wdpa_schema} -v vDATE=${wdpadate} -f ${SQLDIR}/wdpa_buffers_processing_1km.sql
wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Buffers of PAs over 1 km computed in "${runtime}" minutes"
echo "---------------------------------------------------------------------------------------"
exit
