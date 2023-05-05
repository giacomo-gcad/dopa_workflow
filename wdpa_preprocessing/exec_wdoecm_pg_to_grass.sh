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
LOCATION_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_MAPSET_PATH=${DATABASE}/${LOCATION_LL}"/PERMANENT"
PA_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${PA_MAPSET}
BU_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${BU_MAPSET}
PA_MO_MAPSET_PATH=${DATABASE}/${LOCATION_MO}/${PA_MAPSET}
BU_MO_MAPSET_PATH=${DATABASE}/${LOCATION_MO}/${BU_MAPSET}
OECM_LIST_FILE=${SERVICEDIR}"/oecm_list.txt"
OECM_TC_LIST_FILE=${SERVICEDIR}"/oecm_list_tc.txt"
OECM_MA_LIST_FILE=${SERVICEDIR}"/oecm_list_ma.txt"
BU_OECM_LIST_FILE=${SERVICEDIR}"/bu_oecm_list.txt"
BU_OECM_TC_LIST_FILE=${SERVICEDIR}"/bu_oecm_list_tc.txt"
BU_OECM_MA_LIST_FILE=${SERVICEDIR}"/bu_oecm_list_ma.txt"
WDPA_MAPSET="WDPA_"${wdpadate}
WDPA_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${WDPA_MAPSET}
FLAT="wdpa_oecm_flat@WDPA_202101"

# ############################# PREPARE DATA
# # CREATE OECM OVER 5 TABLE
# psql ${dbpar} -c 'DROP TABLE IF EXISTS '${wdpa_schema}'.wdoecm_o5_'${wdpadate}'; CREATE  TABLE '${wdpa_schema}'.wdoecm_o5_'${wdpadate}' AS
# SELECT * FROM '${wdpa_schema}'.wdoecm_'${wdpadate}' WHERE area_geo>=5 ORDER BY wdpaid;'

# # COMPUTE BUFFERS OF OECM OVER 5
# psql ${dbpar} -v paschema=${pa_schema} -v buschema=${bu_schema} -v vSCHEMA=${wdpa_schema} -v vDATE=${wdpadate} -f ${SQLDIR}/wdoecm_buffers_processing.sql

# # CREATE LISTS AND EXPORTS LISTS IN .txt FILE
# psql ${dbpar} -v paschema=${pa_schema} -v buschema=${bu_schema} -v wdpaschema=${wdpa_schema} -v vDATE=${wdpadate} -f ${SQLDIR}/prepare_oecm_x_grass.sql

# psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_oecm) to '${OECM_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_oecm_tc) to '${OECM_TC_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_oecm_ma) to '${OECM_MA_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${bu_schema}'.list_bu_oecm) to '${BU_OECM_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${bu_schema}'.list_bu_oecm_tc) to '${BU_OECM_TC_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${bu_schema}'.list_bu_oecm_ma) to '${BU_OECM_MA_LIST_FILE}' with csv'

# echo " "
# echo "Schemas and lists for PAs and buffers created"
# echo " "

# ############################# CREATE VIEWS
# echo " "
# echo "Now creating views for oecm and buffers of oecm..."
# echo " "

# # CREATE INDIVIDUAL VIEWS FOR PAs
# for PA in $(cat ${OECM_LIST_FILE})
    # do
    # echo "DROP VIEW IF EXISTS ${pa_schema}.${PA};
    # CREATE VIEW ${pa_schema}.${PA} AS
            # SELECT a.wdpaid,a.gname,a.geom
            # FROM (SELECT wdpaid,'pa_'||wdpaid::text gname,geom FROM ${wdpa_schema}.wdoecm_o5_${wdpadate}) a
            # WHERE a.gname='${PA}'
	# "|psql ${dbpar} 
# done

# echo " "
# echo "Individual views for OECM  created"
# echo " "

# # CREATE INDIVIDUAL VIEWS FOR BUs
# for BU in $(cat ${BU_OECM_LIST_FILE})
    # do
    # echo "DROP VIEW IF EXISTS ${bu_schema}.${BU};
    # CREATE VIEW ${bu_schema}.${BU} AS
            # SELECT a.wdpaid,a.gname,a.geom
            # FROM (SELECT wdpaid,'bu_'||wdpaid::text gname,geom FROM ${wdpa_schema}.wdoecm_o5_buffers_${wdpadate}) a
            # WHERE a.gname='${BU}'
	# "|psql ${dbpar} 
# done

# echo " "
# echo "Individual views for BUs of OECM created"
# echo " "

# ############################# EXPORT INDIVIDUAL VIEWS AS SHAPEFILES
# echo " "
# echo "Now creating shapefiles for oecm and buffers of oecm..."
# echo " "

# # # CREATE SHPs for OECM
# for PA in $(cat ${OECM_LIST_FILE})
	# do
	# ogr2ogr -overwrite -f "ESRI Shapefile" ${SHPDIR_PA}/${PA}.shp PG:"${dbpar1}" ${pa_schema}.${PA}
# done

# ## CREATE SHPs for BUFFERS OF OECM
# for BU in $(cat ${BU_OECM_LIST_FILE})
	# do
	# ogr2ogr -overwrite -f "ESRI Shapefile" ${SHPDIR_BU}/${BU}.shp PG:"${dbpar1}" ${bu_schema}.${BU}
# done

# wait

# echo " "
# echo "Shapefiles for oecm and buffers of oecm created"
# echo " "

# ############################# IMPORT OECM AND BUFFERS IN GRASS
# echo " "
# echo "Now importing oecm and buffers of oecm shapefiles to GRASS DB..."
# echo " "

# #IMPORT OECM
# for PA in $(cat ${OECM_LIST_FILE})
	# do
	# grass ${PA_LL_MAPSET_PATH} --exec v.in.ogr --quiet --overwrite -o -t input=${SHPDIR_PA}/${PA}.shp output=${PA%} key=wdpaid
	# wait
# done &

# #IMPORT AND PROCESS BUFFERS OF OECM
# for BU in $(cat ${BU_OECM_LIST_FILE})
	# do
	# echo "./slave_unprot_buffer.sh ${BU} ${SHPDIR_BU} ${BU_LL_MAPSET_PATH} ${FLAT}"
# done |parallel -j 1

# ############################## DELETE BUFFERS WITH EMPTY GEOMETRIES
# echo " "
# echo "Now removing OECM buffers with empty geometries (fully protected buffers)..."
# echo " "

# for BU in $(cat ${BU_OECM_LIST_FILE})
	# do
	# ## the following is aimed to write a list of buffers resulting in empty geometry (i.e. buffers fully protected by other PAs)
	# mm=`grass ${BU_LL_MAPSET_PATH} --exec v.report map=${BU} option=coor| tail -n +1|wc -l`
	# if (( ${mm} == 1 ))
	# then echo ${BU}>>${WORKINGDIR}/bus_oecm_to_be_deleted.csv
	# grass ${BU_LL_MAPSET_PATH} --exec g.remove type=vector name=${BU} -f
	# fi
# done |parallel -j 1

# ############################## UPDATE LIST FILES ADDING OECM
# # REMOVE EMPTY BUFFERS OF OECM FORM LIST 
# for BU in $(cat ${WORKINGDIR}/bus_oecm_to_be_deleted.csv)
# do
	# # UPDATE FULL LIST
	# grep -w -v ${BU} ${BU_OECM_LIST_FILE} >${SERVICEDIR}/temp_bu.txt
	# mv ${SERVICEDIR}/temp_bu.txt ${BU_OECM_LIST_FILE}
	# # UPDATE LIST OF TERRESTRIAL AND COASTAL PAs
	# grep -w -v ${BU} ${BU_OECM_TC_LIST_FILE} >${SERVICEDIR}/temp_bu_tc.txt
	# mv ${SERVICEDIR}/temp_bu_tc.txt ${BU_OECM_TC_LIST_FILE}
	# # UPDATE LIST OF MARINE PAs
	# grep -w -v ${BU} ${BU_OECM_MA_LIST_FILE} >${SERVICEDIR}/temp_bu_ma.txt
	# mv ${SERVICEDIR}/temp_bu_ma.txt ${BU_OECM_MA_LIST_FILE}
# done

# # APPEND OECM
# cat ${OECM_LIST_FILE} >>${SERVICEDIR}/${pa_list}.txt
# cat ${OECM_TC_LIST_FILE} >>${SERVICEDIR}/${pa_tc_list}.txt
# cat ${OECM_MA_LIST_FILE} >>${SERVICEDIR}/${pa_ma_list}.txt

# # APPEND BUFFERS OF OECM
# cat ${BU_OECM_LIST_FILE} >>${SERVICEDIR}/${bu_list}.txt
# cat ${BU_OECM_TC_LIST_FILE} >>${SERVICEDIR}/${bu_tc_list}.txt
# cat ${BU_OECM_MA_LIST_FILE} >>${SERVICEDIR}/${bu_ma_list}.txt

################################## REPROJECTS OECM AND BUFFERS OF OECM IN MOLLWEIDE
echo " "
echo "Now projecting OECM and OECM buffers in Mollweide..."
echo " "

for PA in $(cat ${OECM_LIST_FILE})
do
	echo "./slave_project_pa.sh ${PA} ${LOCATION_LL} ${PA_MAPSET} ${PA_MO_MAPSET_PATH}"
done | parallel -j 1 &

# REPROJECTS BU LAYERS IN MOLLWEIDE
for BU in $(cat ${BU_OECM_LIST_FILE})
do
	echo "./slave_project_bu.sh ${BU} ${LOCATION_LL} ${BU_MAPSET} ${BU_MO_MAPSET_PATH}"
done | parallel -j 1

################################## CLEAN UP
rm -f ${WORKINGDIR}/dyn/*.sh
rm -f ${SERVICEDIR}/temp_*
rm -f ${WORKINGDIR}/bus_oecm_to_be_deleted.csv

enddate_final=`date +%s`
runtime=$(((enddate_final-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Runtime: "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"
exit
