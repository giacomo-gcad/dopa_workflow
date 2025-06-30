#!/bin/bash
##PROCESS ESA-CCI LAND COVER AND MSPA_LC
echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

set -o nounset  # Break if a variable is unset

## SET VARIABLES
NCORES=5
esa_dir="/spatial_data/Original_Datasets/ESA_CCI/uncompressed/1992-2015"
mspa_dir="/spatial_data/Original_Datasets/MSPA_LC/uncompressed/CCI_SPA_1995_2015"
esa_outdir="/spatial_data/Derived_Datasets/RASTER/ESA_CCI"
mspa_outdir="/spatial_data/Derived_Datasets/RASTER/MSPA_LC"

# # REPROJECT TILES IN MOLLEWEIDE
# GDAL parallel processing block

for FIL in $(eval ls  ${esa_dir}/*.tif)
	do
	esa_out=${esa_outdir}"/"${FIL:63:46}
	gdalwarp -t_srs "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs" -ot Byte -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -ts 129600 64800 ${FIL} ${esa_out} &
done
wait

for FIL in $(eval ls  ${mspa_dir}/*.tif)
	do
	mspa_out=${mspa_outdir}"/"${FIL:71:16}
	gdalwarp -t_srs "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs" -ot Byte -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -ts 129600 64800 ${FIL} ${mspa_out} &
done
wait


enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------"
echo "ESA-CCI and MSPA_LC files reprojected  in "${runtime}" minutes "
echo "---------------------------------------------------------------"
exit
