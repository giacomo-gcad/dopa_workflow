#!/bin/bash
# IMPORT VARIABLES

SHPDIR=$1
schema=$2
LIST_FILE=$3
TIL=$4
TILESIZE=$5
host=$6
user=$7
db=$8
pswd=$9

mkdir -p ${SHPDIR}

for PA in $(cat ${LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
	do
	# pgsql2shp -f ${SHPDIR}/${PA} ${dbpars} ${db} ${schema}.${PA}
	ogr2ogr -f "ESRI Shapefile" ${SHPDIR}/${PA}.shp PG:"host=${host} user=${user} dbname=${db} password=${pswd}" ${schema}.${PA}
	done
exit

