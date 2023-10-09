#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_wdoecm_preprocessing.conf

## Derived variables
##((NCORES=${1:-DEFAULTVALUE}))
((NTILES=${NCORES}-1))
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
LOCATION_MO_PATH=${DATABASE}/${LOCATION_MO}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
PERMANENT_MO_MAPSET=${DATABASE}/${LOCATION_MO}"/PERMANENT"
PA_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${PA_MAPSET}
PA_MO_MAPSET_PATH=${DATABASE}/${LOCATION_MO}/${PA_MAPSET}

# CREATES RELEVANT MAPSETS
grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${PA_MAPSET}

# CREATE DIRECTORY FOR DYNAMIC SCRIPTS
mkdir -p ${WORKINGDIR}/dyn

# REPROJECTS PA LAYERS IN MOLLWEIDE
for PA in $(echo $(grass ${PA_LL_MAPSET_PATH}  --exec g.list vector mapset=${PA_MAPSET}))
do
	echo "./slave_project_pa.sh ${PA} ${LOCATION_LL} ${PA_MAPSET} ${PA_MO_MAPSET_PATH}"
done | parallel -j 1 &

wait

# # #IMPORT AND OVERWRITE 4 WELL-KNOWN PAs THAT ARE BADLY REPROJECTED BY v.proj (TOPOLOGICAL PROBLEMS)
# # CHECK IF THE FOUR PROBLEMATIC PAs STILL EXIST
# grass ${PA_MO_MAPSET_PATH} --exec v.info pa_101414@${PA_MAPSET}|grep "Name:"
# grass ${PA_MO_MAPSET_PATH} --exec v.info pa_555602213@${PA_MAPSET}|grep "Name:"
# grass ${PA_MO_MAPSET_PATH} --exec v.info pa_555603331@${PA_MAPSET}|grep "Name:" ## no more existing in wdpa_202202
# grass ${PA_MO_MAPSET_PATH} --exec v.info pa_555626104@${PA_MAPSET}|grep "Name:"

# # MANUAL CHECK OF LOG FILE: IF v.info ABOVE DO NOT GIVE ERRORS (MEANING THAT THOSE PAs STILL EXIST) RUN THE COMMANDS HERE BELOW:
grass ${PA_MO_MAPSET_PATH} --exec v.in.ogr --overwrite --quiet -t -o input="/globes/PROCESSING/WDPA/pa_101414_moll/pa_101414_moll.shp" output="pa_101414" min_area=0.0001 type="" snap=-1
grass ${PA_MO_MAPSET_PATH} --exec v.in.ogr --overwrite --quiet -t -o input="/globes/PROCESSING/WDPA/pa_555602213_moll/pa_555602213_moll.shp" output="pa_555602213" min_area=0.0001 type="" snap=-1
# grass ${PA_MO_MAPSET_PATH} --exec v.in.ogr --overwrite --quiet -t -o input="/globes/PROCESSING/WDPA/pa_555603331_moll/pa_555603331_moll.shp" output="pa_555603331" min_area=0.0001 type="" snap=-1
grass ${PA_MO_MAPSET_PATH} --exec v.in.ogr --overwrite --quiet -t -o input="/globes/PROCESSING/WDPA/pa_555626104_moll/pa_555626104_moll.shp" output="pa_555626104" min_area=0.0001 type="" snap=-1

echo " "
echo "PAs reprojected"
echo " "
echo "Now removing dynamic scripts..."
rm -f ${WORKINGDIR}/dyn/*.sh

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "PAs reprojected in "${runtime}" minutes"
echo "-----------------------------------------------------------------------------------"

exit
