#!/bin/bash
## SECOND PART OF WDPA PRE-PROCESSING
## TO BE RUN AFTER MANUAL IMPLEMENTATION OF PROCEDURE FOR REPAIRING GEOMETRIES
## (SEE sql/fix_wdpa_geom.sql)

date
start1=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

dbpar2="-h ${host} -U ${user} -d ${db} -w"

## PRE-PROCESS WDPA (part 2)
echo "Now pre-processing data...
"

psql ${dbpar2}	-v vSCHEMA=${wdpa_schema} \
				-v vDATE=${wdpadate} \
				-v vgeomidx='_geom_idx' \
				-v vwdpaididx='_wdpaid_idx' \
				-v vidx='_idx' \
				-v THRESHOLD=${area_threshold} \
				-f ${SQLDIR}/wdpa_preprocessing_part_2.sql


date
end1=`date +%s`
runtime=$(((end1-start1) / 60))
echo "Script $(basename "$0") (part 2) executed in ${runtime} minutes"
exit

