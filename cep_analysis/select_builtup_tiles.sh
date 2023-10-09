#!/bin/bash
for eid in {1..648}
do
	# strmin="    STATISTICS_MINIMUM="
	strmax="    STATISTICS_MAXIMUM="
	# mmm=`gdalinfo -stats /spatial_data/Derived_Datasets/RASTER/GHSL/builtup_ll/tiles/builtup_tile_${eid}.tif| grep "MINIMUM"`
	xxx=`gdalinfo -stats /spatial_data/Derived_Datasets/RASTER/GHSL/builtup_ll/tiles/builtup_tile_${eid}.tif| grep "MAXIMUM"`
	# minval=${mmm#"$strmin"}
	maxval=${xxx#"$strmax"}
	if [ ${maxval} != "0" ]; then 
		echo ${eid}
	fi
done
exit
