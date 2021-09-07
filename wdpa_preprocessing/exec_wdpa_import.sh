#!/bin/bash
## FIRST PART OF WDPA PRE-PROCESSING
## IMPORT WDPA DATA FROM ZIPPED GDB

date
start1=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
#source ${SERVICEDIR}/wdpa_preprocessing.conf				## TO BE USED TO PREPROCESS GDB FILES WITHOUT OECM
source ${SERVICEDIR}/wdpa_wdoecm_preprocessing.conf			## TO BE USED TO PREPROCESS GDB FILES WITH OECM

# set local
LC_TIME=en_US.utf8

# SET DYNAMIC VARIABLES
y1=`date -d $wdpadate"01" +%Y`
m1=`date -d $wdpadate"01" +%m`
y2=`date -d $wdpadate"01" +%y`
m2=`date -d $wdpadate"01" +%b`

# SET DERIVED VARIABLES
arch=${pref}"_"${m2}${y1}"_"${suff}
fpath="/vsizip/"${vpath}"/"${y1}"/"${y2}${m1}"_"${arch}${ext1}"/"${arch}${ext2}   # DOES NOT WORK ANYMORE
fpath_u=${upath}"/"${arch}${ext2}
# poly=`ogrinfo -ro $fpath | grep poly | awk '{print $2}'`  # DOES NOT WORK ANYMORE
poly=`ogrinfo -ro ${upath}"/"${arch}${ext2}| grep 'poly' | awk '{print $2}'`
#point=`ogrinfo -ro $fpath | grep point | awk '{print $2}'`   # DOES NOT WORK ANYMORE
point=`ogrinfo -ro ${upath}"/"${arch}${ext2}| grep 'point' | awk '{print $2}'`
cpoly=`ogrinfo -ro -al -so $fpath_u ${poly} | grep 'Feature Count' | awk '{print $3}'`
cpoint=`ogrinfo -ro -al -so $fpath_u ${point} | grep 'Feature Count' | awk '{print $3}'`
((ctot=${cpoly}+${cpoint}))
atts_tab=${atts_table}"_"${y1}${m1}
polytab=${poly_table}"_"${y1}${m1}
pointtab=${point_table}"_"${y1}${m1}
dbpar1="host=${host} user=${user} dbname=${db}"
dbpar2="-h ${host} -U ${user} -d ${db} -w"

echo "Processing ${arch}${ext2}.

Geometry ${poly} contains ${cpoly} objects.

Geometry ${point} contains ${cpoint} objects.

The final number of rows should be ${ctot}."

## CREATE THE OUTPUT SCHEMA  IF NOT EXISTS.
psql ${dbpar2} -c 'CREATE SCHEMA IF NOT EXISTS '${wdpa_schema}' AUTHORIZATION h05ibex; GRANT ALL ON SCHEMA '${wdpa_schema}' TO h05ibex; GRANT ALL ON SCHEMA '${wdpa_schema}' TO h05mandand; GRANT USAGE ON SCHEMA '${wdpa_schema}' TO h05ibexro;'


# IMPORT POLY AND POINT ATTRIBUTES
# SET LONG SQL
sql="
SELECT DISTINCT CAST(WDPAID AS integer) AS WDPAID,WDPA_PID,CAST(PA_DEF AS integer) AS PA_DEF,NAME,ORIG_NAME,DESIG,DESIG_ENG,DESIG_TYPE,IUCN_CAT,INT_CRIT,CAST(MARINE as integer) AS MARINE,REP_M_AREA,GIS_M_AREA,REP_AREA,GIS_AREA,NO_TAKE,NO_TK_AREA,STATUS,STATUS_YR,GOV_TYPE,OWN_TYPE,MANG_AUTH,MANG_PLAN,VERIF,METADATAID,SUB_LOC,PARENT_ISO3,ISO3
FROM ${poly}
UNION
SELECT DISTINCT CAST(WDPAID AS integer) AS WDPAID,WDPA_PID,CAST(PA_DEF AS integer) AS PA_DEF,NAME,ORIG_NAME,DESIG,DESIG_ENG,DESIG_TYPE,IUCN_CAT,INT_CRIT,CAST(MARINE as integer) AS MARINE,REP_M_AREA,'' AS GIS_M_AREA,REP_AREA,'' AS GIS_AREA,NO_TAKE,NO_TK_AREA,STATUS,STATUS_YR,GOV_TYPE,OWN_TYPE,MANG_AUTH,MANG_PLAN,VERIF,METADATAID,SUB_LOC,PARENT_ISO3,ISO3
FROM ${point}
"

echo "Importing ${poly} and ${point} attributes in "${wdpa_schema}"."${atts_tab}

ogr2ogr \
-overwrite \
-dialect sqlite \
-sql """$sql""" \
-f "PostgreSQL" PG:"host=${host} user=${user} dbname=${db}" \
"""$fpath""" \
-nln ${wdpa_schema}"."${atts_tab}

wait

crows=`ogrinfo -ro -al -so PG:"host=$host user=$user dbname=$db" ${wdpa_schema}"."$atts_tab | grep 'Feature Count' | awk '{print $3}'`

echo "
Attributes of ${poly} and ${point} imported in final table ${wdpa_schema}"."$atts_tab.

Final table ${wdpa_schema}.${atts_tab} contains $crows rows.

"

# compare number of objects in source and target
        if ((${ctot} - ${crows} == 0)); then
            tput setaf 2;
            echo "Number of objects imported is ${GREEN}correct."
        else
            tput setaf 1; 
            echo "Number of objects imported is ${RED}NOT correct. Check the results."
        fi
echo " "

## IMPORT POLYGONS LAYER
ogr2ogr \
-overwrite \
-skipfailures \
-dialect sqlite \
-sql "
SELECT * FROM "${poly}" 
" \
-f "PostgreSQL" PG:"host=${host} user=${user} dbname=${db} active_schema=${wdpa_schema}" \
-nln ${wdpa_schema}.${polytab} \
-nlt "MULTIPOLYGON" \
${fpath}

echo "
Layer "${poly}" imported in " ${db}

## IMPORT POINTS LAYER
ogr2ogr \
-overwrite \
-skipfailures \
-explodecollections \
-dialect sqlite \
-sql "
SELECT * FROM "${point}" 
" \
-f "PostgreSQL" PG:"host=${host} user=${user} dbname=${db} active_schema=${wdpa_schema}" \
-nln ${wdpa_schema}.${pointtab} \
-nlt "MULTIPOINT" \
${fpath}

wait 

echo "
Layer "${point}" imported in " ${db} 
echo " "

echo "---------------------------------------------------------------------------------------------"
echo "Tables with polygons, points and attributes imported in postgis."
echo "Now Now run exec_wdpa_preprocessing_part_1.sh"
echo "---------------------------------------------------------------------------------------------"

date
end1=`date +%s`
runtime=$(((end1-start1) / 60))
echo "Script $(basename "$0") executed in ${runtime} minutes"
exit

