#!/bin/bash
## IMPORT AND PROCESS IN POSTGRES RESULTS FOR THDI

date
startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_postprocessing.conf

#DERIVED VARIABLES
dbpar="-h ${host} -U ${user} -d ${db}"

########################### EDITED FOR TESTS ON 202406 ##############################
schema_results=${schema_hdi}
segments_table="segments_pa_probl"
segments_attr_pa="segments_attr_pa_probl"
segments_attr_pa_full_path=${RESULTSPATH}"/hdi/2nd_run/"${segments_attr_pa}
pa_schema=${schema_hdi}
segments_layer="segments_layer_probl"
#####################################################################################

## PART I: POST PROCESS HDI INDICATOR
psql ${dbpar} -t -v vNAME=${segments_attr_pa}_${wdpadate} -v vSCHEMA=${schema_hdi} -f ./sql/create_table_thdi_tmp.sql
echo "\copy ${schema_hdi}.${segments_attr_pa}_${wdpadate} FROM '${segments_attr_pa_full_path}.csv' DELIMITER ',' CSV HEADER"  | psql ${dbpar}
echo "ALTER TABLE ${schema_hdi}.${segments_attr_pa}_${wdpadate}
ADD COLUMN wdpaid integer;
UPDATE ${schema_hdi}.${segments_attr_pa}_${wdpadate}
SET wdpaid= REPLACE (wdpaid_pa,'pa_','')::integer;"| psql ${dbpar}

echo "thdi attributes imported in DB"

psql ${dbpar} -t -v WDPA_SCHEMA=${wdpa_schema} -v WDPA_DATE=${wdpadate} -v LIST_PA="list_pa_tc_probl" -v SCHEMA_RESULTS=${schema_results} -v TABLE_IND="wdpa_habitat_diversity_profile_thdi_probl_"${wdpadate} -v SCHEMA_HDI=${schema_hdi} -v PA_SCHEMA=${pa_schema} -v DATA_HDI=${segments_attr_pa}_${wdpadate} -f ./sql/thdi_pa_postproc_probl.sql

echo "thdi attributes postprocessed"

## PART II: POST PROCESS SEGMENTS LAYER
echo "Now importing segments shapefile.... "
ogr2ogr -progress -overwrite -skipfailures \
-f "PostgreSQL"  PG:"host=${host} user=${user} dbname=${db} active_schema=${schema_hdi} password=${pw}" \
-t_srs EPSG:4326 \
-nln ${schema_hdi}"."${segments_table} -nlt "MULTIPOLYGON" \
${RESULTSPATH}"/hdi/2nd_run/"${segments_table}".shp"

echo "thdi geometries imported in DB"

wait

psql ${dbpar} -t -c "DROP TABLE IF EXISTS segment_tmp; CREATE TEMPORARY TABLE segment_tmp AS
SELECT ogc_fid id, wkb_geometry geom, cat, label,
LTRIM(wdpaid_pa,'pa_')::integer wdpaid_pa, aleat, segm_id
FROM  ${schema_hdi}.${segments_table};
DROP TABLE IF EXISTS ${schema_hdi}.${segments_layer}; CREATE TABLE  ${schema_hdi}.${segments_layer} AS
WITH
countall AS (SELECT wdpaid_pa,COUNT(cat)::integer count_tot FROM segment_tmp GROUP BY wdpaid_pa),
countcat AS (SELECT wdpaid_pa,cat,COUNT(id)::integer count_cat FROM segment_tmp GROUP BY wdpaid_pa,cat)
SELECT a.id,a.geom,a.cat,a.label,a.wdpaid_pa,a.aleat,a.segm_id,b.count_cat::integer,c.count_tot::integer,ROUND(count_cat/count_tot::numeric,5) norm
FROM segment_tmp a LEFT JOIN countcat b USING (wdpaid_pa,cat) LEFT JOIN countall c USING (wdpaid_pa)
--WHERE wdpaid_pa NOT IN (SELECT wdpaid FROM protected_sites.wdoecm_${wdpadate}) -- COMMENT THIS LINE TO KEEP ALSO OECM
ORDER BY wdpaid_pa;
ALTER TABLE  ${schema_hdi}.${segments_layer}
ADD PRIMARY KEY (id);
CREATE INDEX segments_layer_idx ON  ${schema_hdi}.${segments_layer} USING gist (geom);"

echo "attributes of geometries processed"

# ## REMOVE ORIGINAL TABLES
# psql ${dbpar} -t -c "DROP TABLE IF EXISTS ${schema_hdi}.${segments_table};
# DROP TABLE IF EXISTS ${schema_hdi}.${segments_attr_pa};"

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))
echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "HDI postprocessed in "${runtime}" minutes"
echo "---------------------------------------------------------------------------------------"
exit
