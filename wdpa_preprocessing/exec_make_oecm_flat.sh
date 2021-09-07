#!/bin/bash
## IMPORT FULL WDPA IN GRASS AND MARE RASTER FLAT

date
start1=`date +%s`


# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

## Derived variables
dbpar="-h ${host} -U ${user} -d ${db}"
LOCATION_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
WDPA_MAPSET="WDPA_"${wdpadate}
WDPA_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${WDPA_MAPSET}
wdpa_flat="wdpa_oecm_flat"

# ## CREATE DB CONNECTION TO POSTGIS
grass ${PERMANENT_MAPSET} --exec db.connect driver=pg database=${db} schema=${wdpa_schema}
grass ${PERMANENT_MAPSET} --exec db.login --overwrite driver=pg database=${db} user=${user} password=${pw} host=${host} port=${port}

# ## IMPORT WDPA FROM POSTGIS
echo "Now importing wdpa_${wdpadate}..."
grass ${PERMANENT_MAPSET} --exec g.mapset --q -c ${WDPA_MAPSET}
grass ${WDPA_MAPSET_PATH} --exec v.in.ogr --q --overwrite -t -o input="PG:host=${host} dbname=${db} user=${user} password=${pw}" columns=cat,id,wdpaid snap=0.0000083 layer=${wdpa_schema}.wdpa_oecm_${wdpadate} output=wdpa_oecm_${wdpadate} >>${LOGPATH}wdpa_oecm_flat.log  2>&1
wait

date

# execute flat_slave.sh
echo "Now rasterizing and mosaiking tiles..."
grass ${WDPA_MAPSET_PATH} --exec sh ./slave_make_flat.sh wdpa_oecm_${wdpadate} ${wdpa_flat} >>${LOGPATH}/wdpa_oecm_flat.log  2>&1
wait

echo "Mosaic completed, now removing tiles..."
grass ${WDPA_MAPSET_PATH} --exec g.remove type=raster pattern=wdpa_tile* -f
wait

date
end1=`date +%s`
runtime=$(((end1-start1) / 60))
echo "Script $(basename "$0") executed in ${runtime} minutes"
exit