#!/bin/bash


startdate=`date +%s`
in_file="/spatial_data/Derived_Datasets/RASTER/gROADS/groads_buffer_250m_moll.tif"
out_file="/spatial_data/Derived_Datasets/RASTER/gROADS/groads_buffer_250m_wgs84.tif"

## REPROJECT IN WGS84 THE RASTER DATASETS OF BUFFERS ON ROADS
gdalwarp -t_srs EPSG:4326 -co "COMPRESS=LZW" ${in_file} ${out_file}.tif

enddate=`date +%s`
runtime=$(( enddate-startdate ))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "gRoads 250m buffers reprojected in wgs84 in "${runtime}" seconds"
echo "---------------------------------------------------------------------------------------"
exit
