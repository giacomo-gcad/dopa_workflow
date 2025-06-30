#!/bin/bash
# # Import and compute time series stats for VIIRS SST

echo "Script $(basename "$0") started at $(date)"
startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
NASA_SST_MAPSET=${DATABASE}/${LOCATION_LL}"/NASA_SST"

WDIR="/globes/processing_current/raster_processing/NASA_SST"
fil="nc_list.txt"
path="/spatial_data/Original_Datasets/MARINE_SST/archives/NASA"
# outpath="/spatial_data/Original_Datasets/MARINE_SST/uncompressed/NASA"

## 1. IMPORT NETCDF IN GRASS
for map in $(cat ${path}/${fil})
do
	yyyymm=${map:11:6}
	echo ${map}
	grass ${NASA_SST_MAPSET} --exec r.external --o source="NETCDF:${path}/${map}:sst" output=sst_${yyyymm} -o
done

echo "External files imported in grass"

# # 3. CREATE GRASS TIME SERIES
grass ${NASA_SST_MAPSET} --exec t.create --o type=strds temporaltype=absolute output=sst title="Sea Surface Temperature" description="VIIRS SST monthly  average" semantictype=mean
grass ${NASA_SST_MAPSET} --exec g.list raster mapset="NASA_SST" pattern="sst_*" separator=newline output=${WDIR}"/sst_maps_list.txt" --o
grass ${NASA_SST_MAPSET} --exec t.register --o -i type=raster input=sst file=${WDIR}"/sst_maps_list.txt" start="2012-01-01" increment="1 months"
date
echo "Time series created"


# 4. COMPUTE AVG, MAX AND MIN ON TIME SERIES
grass ${NASA_SST_MAPSET} --exec g.region raster=sst_201201 -p

for MONTH in `seq -w 1 12` ; do 
  for METHOD in average minimum maximum ; do 
    grass ${NASA_SST_MAPSET} --exec t.rast.series --o input=sst method=${METHOD} where="strftime('%m', start_time)='${MONTH}'" output=sst_${METHOD}_${MONTH} 
	echo ${METHOD}" computed."
  done
done

echo "Average, minimum and maximum values computed"

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "----------------------------------------------------------------------"
echo "VIIRS SST MONTHLY DATA IMPORTED AND PROCESSED in "${runtime}" minutes "
echo "----------------------------------------------------------------------"
exit

exit

