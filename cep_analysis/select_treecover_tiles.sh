#!/bin/bash
directory="/spatial_data/Derived_Datasets/RASTER/GFC/treecover_over30_ll"

for file in "$directory"/*.tif
do
	strmax="    STATISTICS_MAXIMUM="
	xxx=`gdalinfo -stats ${file}| grep "MAXIMUM"`
	maxval=${xxx#"$strmax"}
	if [ ${maxval} != "0" ]; then 
		echo ${file} >>treecover_tiles_selected_derived.txt
	fi
	echo ${file}
done
exit
