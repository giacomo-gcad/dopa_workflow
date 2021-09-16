#!/bin/bash
##PROCESS GHS BUILTP UP: REPROJECT EACH TILE IN MOLLEWEIDE AND BUILD VIRTUAL CATALOG
echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

## SET VARIABLES
NCORES=64
working_dir="/globes/processing_current/raster_processing/GHSL"
base_indir="/spatial_data/Original_Datasets/GHSL/uncompressed/builtup/old_vers"
base_outdir="/spatial_data/Derived_Datasets/RASTER/GHSL/builtup_old"
TILES_LIST=${base_indir}"/list.txt"

## Derived variables
((NTILES=${NCORES}-1))

# # STEP 1: create folders structure and files list
cd ${base_indir}
find . -type d -exec mkdir -p -- ${base_outdir}/{} \;

wait
cd ${working_dir}

# # STEP 1: REPROJECT TILES IN MOLLEWEIDE
# GDAL parallel processing block
((ALLTILES=$(cat ${TILES_LIST} | wc -l)+1))
((TILESIZE=(${ALLTILES}+${NTILES})/${NCORES}))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLTILES 
for TIL in $(for i in $(eval echo {0..${NTILES}}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
	do
    echo "./slave_proj_builtup.sh ${TIL} ${TILESIZE} ${TILES_LIST} ${base_indir} ${base_outdir}"
done | parallel -j ${NCORES}

wait

# # STEP 2: BUILD VIRTUAL CATALOG
cd ${base_outdir}
find -name *.tif > tiles_list.txt
gdalbuildvrt -srcnodata 0 -vrtnodata 0 -input_file_list tiles_list.txt ${base_outdir}/temp.vrt -overwrite
sed 's/relativeToVRT="0"/relativeToVRT="1"/g' ${base_outdir}/temp.vrt >${base_outdir}/builtup_old.vrt
rm -f ${base_outdir}/temp.vrt
wait

# # STEP 3: COMPUTE STATISTICS ON VIRTUAL CATALOGS
gdalinfo -approx_stats ${base_outdir}/builtup_old.vrt
wait

cd ${working_dir}
rm -f ./dyn/*

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------"
echo "GHSL builtup tiles reprojected  in "${runtime}" minutes "
echo "----------------------------------------------------------------"
exit
