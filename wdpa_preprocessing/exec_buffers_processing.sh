#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

# set local
LC_TIME=en_US.utf8

# SET DERIVED VARIABLES
dbpar2="-h ${host} -U ${user} -d ${db} -w"

## PRE-PROCESS WDPA
echo "Now processing wdpa buffers - 10 km...
"

psql ${dbpar2} -v vSCHEMA=${wdpa_schema} -v vDATE=${wdpadate} -f ${SQLDIR}/wdpa_buffers_processing.sql

finaldate=`date`
echo " "
echo "---------------------------------------------------"
echo "Buffers processing chain completed at ${finaldate}"
echo " "
