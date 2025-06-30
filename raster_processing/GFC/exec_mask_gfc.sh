#!/bin/bash
##PROCESS GLOBAL FOREST CHANGE: MASK VALUES BELOW 30% FRO TREECOVER, GAIN AND LOSSYEAR

echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
source gfc_parameters.conf

## Derived variables
((NTILES=${NCORES}-1))

# # STEP 1: CREATE MASK FOR PIXELS WITH TRECOVER OVER 30%
# GDAL parallel processing block
mkdir -p ${temp_dir}

((ALLTILES=$(cat ${TREE_LIST_FILE} | wc -l)+1))
((TILESIZE=(${ALLTILES}+${NTILES})/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLTILES 
for TIL in $(for i in $(eval echo {0..${NTILES}}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
    echo "./slave_mask_gfc.sh ${TIL} ${TILESIZE} ${TREE_LIST_FILE} ${base_indir} ${base_outdir} ${temp_dir} ${rootstring}"
done | parallel -j ${NCORES}

echo "GFC tiles masked"
wait

## STEP 2 RENAME TILES USING EID GRID NUMBERS
#RENAME TREECOVER OVER30 TILES
./rename_treecover_tiles.sh 
wait
#RENAME LOSSYEAR OVER30 TILES 
./rename_lossyear_tiles.sh 
wait
#RENAME GAIN OVER30 TILES 
./rename_gain_tiles.sh 
wait

echo "GFC tiles renamed"

# # STEP 3: BUILD VIRTUAL CATALOGS
gdalbuildvrt ${base_outdir}/temp_treecover_over30_ll.vrt ${base_outdir}/treecover_over30_ll/*.tif -overwrite &
gdalbuildvrt ${base_outdir}/temp_gain_over30_ll.vrt ${base_outdir}/gain_over30_ll/*.tif -overwrite &
gdalbuildvrt ${base_outdir}/temp_lossyear_over30_ll.vrt ${base_outdir}/lossyear_over30_ll/*.tif -overwrite &

wait

sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_treecover_over30_ll.vrt >${base_outdir}/treecover_over30_ll.vrt
sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_gain_over30_ll.vrt >${base_outdir}/gain_over30_ll.vrt
sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_lossyear_over30_ll.vrt >${base_outdir}/lossyear_over30_ll.vrt

wait
echo "GFC virtual catalogs built"


# # STEP 4: COMPUTE STATISTICS ON VIRTUAL CATALOGS
gdalinfo -approx_stats ${base_outdir}/treecover_over30_ll.vrt &
gdalinfo -approx_stats ${base_outdir}/gain_over30_ll.vrt &
gdalinfo -approx_stats ${base_outdir}/lossyear_over30_ll.vrt &
wait

echo "GFC stats computed on vrt"

rm ${temp_dir} -rf
rm -f ./dyn/*
rm -f ${base_outdir}/temp_*.vrt


enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------"
echo "Global Forest Change tiles processed in "${runtime}" minutes"
echo "----------------------------------------------------------------"
exit
