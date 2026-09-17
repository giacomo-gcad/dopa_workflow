#!/bin/bash
## COMBINE RESULTS FOR WORLDCLIM ND SST IN ONLY ONE TABLE 

date

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

cli="worldclim_wdpa_"${wdpadate}
sst="nasa_sst_wdpa_"${wdpadate}

dbpar="-h ${host} -U ${user} -d ${db}"

## POST PROCESS DATA IN POSTGRES TO CREATE TABLES READY FOR DB PROD
psql ${dbpar} -t -v SCHEMARESULTS=${schema_results} -v CLIMATESCHEMA=${schema_climate} -v MCL_TABLE=${sst}  -v TCL_TABLE=${cli} -v DATE=${wdpadate} -f ./sql/union_worldclim_sst_pa.sql

echo "worldclim and nasa sst tables merged in final table"
date
