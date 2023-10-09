#!/bin/bash
##PROCESS GHS BUILTP UP R2022A: REPROJECT EACH EPOCH in LATLONG WGS84
echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

## SET VARIABLES
working_dir="/globes/processing_current/raster_processing/GHSL"
base_indir="/spatial_data/Original_Datasets/GHSL/uncompressed/builtup/R2022A"
base_outdir="/spatial_data/Derived_Datasets/RASTER/GHSL/R2022A/builtup"
TILES_LIST=${base_indir}"/list.txt"

# # STEP 1: create folders structure and files list
cd ${base_indir}
find . -type d -exec mkdir -p -- ${base_outdir}/{} \;
find *.tif > ${TILES_LIST}

wait
cd ${working_dir}

# # STEP 1: REPROJECT BUILTUP GLOBAL FILES IN LATLONG

./slave_proj_builtup_r2022a.sh ${TILES_LIST} ${base_indir} ${base_outdir}

wait

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------"
echo "GHSL builtup tiles reprojected  in "${runtime}" minutes "
echo "----------------------------------------------------------------"
exit
