#!/bin/bash
date

INDIR="/spatial_data/Original_Datasets/GHSL/uncompressed/builtup/R2023A"
OUTDIR_ROOT="/spatial_data/Derived_Datasets/RASTER/GHSL/R2023A/builtup/"
OUTFILE="GHS_BUILT_S_E2020_GLOBE_R2023A_4326.tif"

gdalwarp -of Gtiff -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 \
-ot UInt16 -co BIGTIFF=YES \
-te -180 -90 180 90 -ts 360820 180000 -t_srs EPSG:4326 \
${INDIR}/GHS_BUILT_S_E2020_GLOBE_R2023A_54009_100_V1_0.tif  ${OUTFILE}

#!/bin/bash
date
