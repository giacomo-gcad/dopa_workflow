#!/bin/bash
##PROCESS COPERNICUS LAND COVER
date
start1=`date +%s`

set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

## Derived variables
((NTILES=${NCORES}-1))
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"

## PAs TO BE ANALYZED ************************CHECK/EDIT IT BEFORE RUN
BU_LIST_FILE=${SERVICEDIR}/${bu_tc_list}.txt

## GRASS parallel processing block
((ALLBUS=$(cat ${BU_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLBUS}+(${NCORES}-1))/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLBUS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    TIL=${TIL}
    TEMPORARY_MAPSET=cop_lc_${TIL}
    TEMPORARY_MAPSET_PATH=${LOCATION_LL_PATH}/${TEMPORARY_MAPSET}
    #Build temporary Mapset name
    grass ${PERMANENT_LL_MAPSET} --exec g.mapset --q -c --overwrite mapset=${TEMPORARY_MAPSET}
    echo "./slave_copernicus_lc_bu.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${BU_LIST_FILE} ${BU_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_cop_lc_bu.log

echo "GRASS Processing completed, now post-processing results..."

# merge results LC
cat ${RESULTSPATH}/bu_cop_lc_totsurface_tile*.csv >> ${RESULTSPATH}/bu_cop_lc_totsurface.csv
cat ${RESULTSPATH}/bu_cop_lc_tile*.csv >> ${RESULTSPATH}/bu_cop_lc.csv

wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -rf ${LOCATION_LL_PATH}/cop_lc_${TIL}
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING FOR BUs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/bu_cop_lc_totsurface.csv | awk '{print $2}' FS="|">./bu_cop_lc_actually_done.csv # for outputs from r.stats the bu id is in the second field, so we need to use '{print $2}'
comm -23 <(sort ${BU_LIST_FILE}) <(sort ./bu_cop_lc_actually_done.csv)>./bu_cop_lc_to_be_repeated.csv
MISSING_BU_LIST="bu_cop_lc_to_be_repeated.csv"
for bu in $(cat ${MISSING_BU_LIST})
    do
    grass ${PERMANENT_LL_MAPSET} --exec ./dyn/process_bu_cop_lc_${bu}.sh
done
cat ${RESULTSPATH}/bu_cop_lc_totsurface_tile*.csv >> ${RESULTSPATH}/bu_cop_lc_totsurface.csv
cat ${RESULTSPATH}/bu_cop_lc_tile*.csv >> ${RESULTSPATH}/bu_cop_lc.csv

## delete intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done
rm -f ./*actually_done.csv
rm -f ./*to_be_repeated.csv

## delete dynamic scripts
echo dyn/process_cop_lc_*.sh |xargs rm -f

date
end1=`date +%s`
runtime=$(((end1-start1) / 60))
echo "Script $(basename "$0") executed in ${runtime} minutes"
exit
