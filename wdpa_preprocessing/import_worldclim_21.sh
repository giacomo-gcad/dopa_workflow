#!/bin/bash
# set variables
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf
ORIGDATA="/spatial_data/Original_Datasets"
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
MAPSET=${DATABASE}/${LOCATION_LL}"/CONRASTERS"

date

# LINK RASTERS IN WGS84LL

## WORLDCLIM
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_01.tif" output="worldclim_prec_01" title="Worldclim 2.1 - Rainfall jan"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_02.tif" output="worldclim_prec_02" title="Worldclim 2.1 - Rainfall feb"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_03.tif" output="worldclim_prec_03" title="Worldclim 2.1 - Rainfall mar"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_04.tif" output="worldclim_prec_04" title="Worldclim 2.1 - Rainfall apr"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_05.tif" output="worldclim_prec_05" title="Worldclim 2.1 - Rainfall may"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_06.tif" output="worldclim_prec_06" title="Worldclim 2.1 - Rainfall jun"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_07.tif" output="worldclim_prec_07" title="Worldclim 2.1 - Rainfall jul"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_08.tif" output="worldclim_prec_08" title="Worldclim 2.1 - Rainfall aug"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_09.tif" output="worldclim_prec_09" title="Worldclim 2.1 - Rainfall sep"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_10.tif" output="worldclim_prec_10" title="Worldclim 2.1 - Rainfall oct"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_11.tif" output="worldclim_prec_11" title="Worldclim 2.1 - Rainfall nov"
grass ${MAPSET} -f --exec r.external --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_prec/wc2.1_30s_prec_12.tif" output="worldclim_prec_12" title="Worldclim 2.1 - Rainfall dec"
echo "prec imported"
date

grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_01.tif" output="worldclim_tavg_01" memory=4096 title="Worldclim 2.1 - Tmean jan"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_02.tif" output="worldclim_tavg_02" memory=4096 title="Worldclim 2.1 - Tmean feb"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_03.tif" output="worldclim_tavg_03" memory=4096 title="Worldclim 2.1 - Tmean mar"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_04.tif" output="worldclim_tavg_04" memory=4096 title="Worldclim 2.1 - Tmean apr"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_05.tif" output="worldclim_tavg_05" memory=4096 title="Worldclim 2.1 - Tmean may"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_06.tif" output="worldclim_tavg_06" memory=4096 title="Worldclim 2.1 - Tmean jun"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_07.tif" output="worldclim_tavg_07" memory=4096 title="Worldclim 2.1 - Tmean jul"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_08.tif" output="worldclim_tavg_08" memory=4096 title="Worldclim 2.1 - Tmean aug"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_09.tif" output="worldclim_tavg_09" memory=4096 title="Worldclim 2.1 - Tmean sep"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_10.tif" output="worldclim_tavg_10" memory=4096 title="Worldclim 2.1 - Tmean oct"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_11.tif" output="worldclim_tavg_11" memory=4096 title="Worldclim 2.1 - Tmean nov"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tavg/wc2.1_30s_tavg_12.tif" output="worldclim_tavg_12" memory=4096 title="Worldclim 2.1 - Tmean dec"
echo "tavg imported"
date

grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_01.tif" output="worldclim_tmax_01" memory=4096 title="Worldclim 2.1 - Tmax jan"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_02.tif" output="worldclim_tmax_02" memory=4096 title="Worldclim 2.1 - Tmax feb"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_03.tif" output="worldclim_tmax_03" memory=4096 title="Worldclim 2.1 - Tmax mar"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_04.tif" output="worldclim_tmax_04" memory=4096 title="Worldclim 2.1 - Tmax apr"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_05.tif" output="worldclim_tmax_05" memory=4096 title="Worldclim 2.1 - Tmax may"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_06.tif" output="worldclim_tmax_06" memory=4096 title="Worldclim 2.1 - Tmax jun"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_07.tif" output="worldclim_tmax_07" memory=4096 title="Worldclim 2.1 - Tmax jul"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_08.tif" output="worldclim_tmax_08" memory=4096 title="Worldclim 2.1 - Tmax aug"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_09.tif" output="worldclim_tmax_09" memory=4096 title="Worldclim 2.1 - Tmax sep"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_10.tif" output="worldclim_tmax_10" memory=4096 title="Worldclim 2.1 - Tmax oct"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_11.tif" output="worldclim_tmax_11" memory=4096 title="Worldclim 2.1 - Tmax nov"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmax/wc2.1_30s_tmax_12.tif" output="worldclim_tmax_12" memory=4096 title="Worldclim 2.1 - Tmax dec"
echo "tmax imported"
date

grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_01.tif" output="worldclim_tmin_01" memory=4096 title="Worldclim 2.1 - Tmin jan"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_02.tif" output="worldclim_tmin_02" memory=4096 title="Worldclim 2.1 - Tmin feb"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_03.tif" output="worldclim_tmin_03" memory=4096 title="Worldclim 2.1 - Tmin mar"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_04.tif" output="worldclim_tmin_04" memory=4096 title="Worldclim 2.1 - Tmin apr"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_05.tif" output="worldclim_tmin_05" memory=4096 title="Worldclim 2.1 - Tmin may"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_06.tif" output="worldclim_tmin_06" memory=4096 title="Worldclim 2.1 - Tmin jun"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_07.tif" output="worldclim_tmin_07" memory=4096 title="Worldclim 2.1 - Tmin jul"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_08.tif" output="worldclim_tmin_08" memory=4096 title="Worldclim 2.1 - Tmin aug"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_09.tif" output="worldclim_tmin_09" memory=4096 title="Worldclim 2.1 - Tmin sep"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_10.tif" output="worldclim_tmin_10" memory=4096 title="Worldclim 2.1 - Tmin oct"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_11.tif" output="worldclim_tmin_11" memory=4096 title="Worldclim 2.1 - Tmin nov"
grass ${MAPSET} -f --exec r.import --o input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.1_30s_tmin/wc2.1_30s_tmin_12.tif" output="worldclim_tmin_12" memory=4096 title="Worldclim 2.1 - Tmin dec"
echo "tmin imported"
echo "-------------------------------"
date
echo "PROCEDURE COMPLETED"
