#!/bin/bash
##PROCESS GLOBAL SURFACE WATER: REPROJECT EACH TRANSITIONS TILE IN MOLLEWEIDE AND BUILD VIRTUAL CATALOG
echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

## SET VARIABLES
NCORES=40
base_indir="/spatial_data/Original_Datasets/COPERNICUS/GLOBAL_SURFACE_WATER/archives/2019"
base_outdir="/spatial_data/Derived_Datasets/RASTER/GSW"
TILES_LIST=${base_indir}"/gsw_tileslist.txt"

## Derived variables
((NTILES=${NCORES}-1))

mkdir -p ${base_outdir}/transitions

# # STEP 1: REPROJECT TILES IN MOLLEWEIDE
# GDAL parallel processing block
((ALLTILES=$(cat ${TILES_LIST} | wc -l)+1))
((TILESIZE=(${ALLTILES}+${NTILES})/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLTILES 
for TIL in $(for i in $(eval echo {0..${NTILES}}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
    echo "./slave_proj_gsw.sh ${TIL} ${TILESIZE} ${TILES_LIST} ${base_indir} ${base_outdir}"
done | parallel -j ${NCORES}
wait

# # STEP 2: BUILD VIRTUAL CATALOG
gdalbuildvrt ${base_outdir}/temp_gsw.vrt ${base_outdir}/transitions/*.tif -overwrite
sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp_gsw.vrt >${base_outdir}/gsw.vrt
wait

# # STEP 3: COMPUTE STATISTICS ON VIRTUAL CATALOGS
gdalinfo -approx_stats ${base_outdir}/gsw.vrt
wait

rm -f ./dyn/*
rm -f ${base_outdir}/temp_gsw.vrt


enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------"
echo "Global Surface Water tiles reprojected  in "${runtime}" minutes "
echo "----------------------------------------------------------------"
exit
