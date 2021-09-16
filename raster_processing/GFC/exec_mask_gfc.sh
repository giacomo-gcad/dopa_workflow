#!/bin/bash
##PROCESS GLOBAL FOREST CHANGE: MASK VALUES BELOW 30% FRO TREECOVER, GAIN AND LOSSYEAR

echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

## SET VARIABLES
NCORES=56
base_indir="/spatial_data/Original_Datasets/GLOBAL_FOREST_CHANGE/archives/V_17"
base_outdir="/spatial_data/Derived_Datasets/RASTER/GFC"
temp_dir="/spatial_data/Derived_Datasets/RASTER/temp"  	# CREATED BY THE SCRIPT
rootstring="Hansen_GFC-2019-v1.7_"						# REMEMBER TO UPDATE THIS STRING ACCORDING TO THE VERSION USED
TREE_LIST_FILE=${base_indir}"/treecover_filelist.txt" 	# MUST EXIST BEFORE RUNNING THE SCRIPT
GAIN_LIST_FILE=${base_indir}"/gain_filelist.txt" 		# MUST EXIST BEFORE RUNNING THE SCRIPT
LOSS_LIST_FILE=${base_indir}"/lossyear_filelist.txt" 	# MUST EXIST BEFORE RUNNING THE SCRIPT

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

# # STEP 3: BUILD VIRTUAL CATALOGS
gdalbuildvrt ${base_outdir}/temp_treecover_over30_ll.vrt ${base_outdir}/treecover_over30_ll/*.tif -overwrite &
gdalbuildvrt ${base_outdir}/temp_gain_over30_ll.vrt ${base_outdir}/gain_over30_ll/*.tif -overwrite &
gdalbuildvrt ${base_outdir}/temp_lossyear_over30_ll.vrt ${base_outdir}/lossyear_over30_ll/*.tif -overwrite &

wait

sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_treecover_over30_ll.vrt >${base_outdir}/treecover_over30_ll.vrt
sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_gain_over30_ll.vrt >${base_outdir}/gain_over30_ll.vrt
sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_lossyear_over30_ll.vrt >${base_outdir}/lossyear_over30_ll.vrt

wait

# # STEP 4: COMPUTE STATISTICS ON VIRTUAL CATALOGS
gdalinfo -approx_stats ${base_outdir}/treecover_over30_ll.vrt &
gdalinfo -approx_stats ${base_outdir}/gain_over30_ll.vrt &
gdalinfo -approx_stats ${base_outdir}/lossyear_over30_ll.vrt &
wait

rm ${temp_dir} -rf
rm -f ./dyn/*
rm -f ${base_outdir}/temp_*.vrt


enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------"
echo "Global Forest Change tiles processed in "${runtime}" minutes"
echo "----------------------------------------------------------------"
exit
