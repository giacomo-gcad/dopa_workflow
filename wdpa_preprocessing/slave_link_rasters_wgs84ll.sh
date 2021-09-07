#!/bin/bash
# set variables
ORIGDATA=$1
DERIVDATA=$2

# LINK RASTERS IN WGS84LL

## Create mapsets and grant access
g.mapset --q -c --overwrite mapset=CATRASTERS
g.mapset --q -c --overwrite mapset=CONRASTERS

## Import external continuous rasters 

## WORLDCLIM (tavg,tmax and tmin are physically imported: with r.external analysis fails, NoData value not acknowledged)
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_01.tif" output="worldclim_prec_01" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_02.tif" output="worldclim_prec_02" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_03.tif" output="worldclim_prec_03" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_04.tif" output="worldclim_prec_04" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_05.tif" output="worldclim_prec_05" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_06.tif" output="worldclim_prec_06" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_07.tif" output="worldclim_prec_07" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_08.tif" output="worldclim_prec_08" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_09.tif" output="worldclim_prec_09" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_10.tif" output="worldclim_prec_10" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_11.tif" output="worldclim_prec_11" &
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_12.tif" output="worldclim_prec_12"

r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_01.tif" output="worldclim_tavg_01" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_02.tif" output="worldclim_tavg_02" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_03.tif" output="worldclim_tavg_03" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_04.tif" output="worldclim_tavg_04" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_05.tif" output="worldclim_tavg_05" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_06.tif" output="worldclim_tavg_06" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_07.tif" output="worldclim_tavg_07" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_08.tif" output="worldclim_tavg_08" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_09.tif" output="worldclim_tavg_09" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_10.tif" output="worldclim_tavg_10" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_11.tif" output="worldclim_tavg_11" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_12.tif" output="worldclim_tavg_12" memory=2048

r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_01.tif" output="worldclim_tmax_01" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_02.tif" output="worldclim_tmax_02" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_03.tif" output="worldclim_tmax_03" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_04.tif" output="worldclim_tmax_04" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_05.tif" output="worldclim_tmax_05" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_06.tif" output="worldclim_tmax_06" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_07.tif" output="worldclim_tmax_07" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_08.tif" output="worldclim_tmax_08" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_09.tif" output="worldclim_tmax_09" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_10.tif" output="worldclim_tmax_10" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_11.tif" output="worldclim_tmax_11" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_12.tif" output="worldclim_tmax_12" memory=2048

r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_01.tif" output="worldclim_tmin_01" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_02.tif" output="worldclim_tmin_02" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_03.tif" output="worldclim_tmin_03" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_04.tif" output="worldclim_tmin_04" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_05.tif" output="worldclim_tmin_05" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_06.tif" output="worldclim_tmin_06" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_07.tif" output="worldclim_tmin_07" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_08.tif" output="worldclim_tmin_08" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_09.tif" output="worldclim_tmin_09" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_10.tif" output="worldclim_tmin_10" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_11.tif" output="worldclim_tmin_11" memory=2048
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_12.tif" output="worldclim_tmin_12" memory=2048

## GEBCO
r.external --overwrite input=${ORIGDATA}"/GEBCO/uncompressed/GEBCO2019/gebco2019.vrt" output="gebco"

## CROPLAND2005
r.external --overwrite input=${ORIGDATA}"/CROPLAND2005/uncompressed/cropland_hybrid_10042015v9/Hybrid_10042015v9.img" output="cropland2005"

## GLOBAL FOREST CHANGE
r.external --overwrite input=${DERIVDATA}"/RASTER/GFC/treecover_over30_ll.vrt" output="gfc_treecover"

## GLOBAL SOIL ORGANIC CARBON
r.external --overwrite input=${ORIGDATA}"/GSOC/uncompressed/GSOCmapV1.2.0.tif" output="GSOCmapV1"

## GLOBAL LIVESTOCK OF THE WORLD v. 3 (IMPORT AND PROCESS)
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Buffaloes/5_Bf_2010_Da.tif" output="glw3_bf_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Chickens/5_Ch_2010_Da.tif" output="glw3_ch_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Cattle/5_Ct_2010_Da.tif" output="glw3_ct_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Ducks/5_Dk_2010_Da.tif" output="glw3_dk_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Goats/5_Gt_2010_Da.tif" output="glw3_gt_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Horses/5_Ho_2010_Da.tif" output="glw3_ho_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Pigs/5_Pg_2010_Da.tif" output="glw3_pg_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Sheep/5_Sh_2010_Da.tif" output="glw3_sh_2010_da" memory=2048
r.import --overwrite input=${ORIGDATA}"/GLW3/PUBLIC/uncompressed/GLW_Sheep/8_Areakm.tif" output="glw3_areakm" memory=2048

g.region raster=glw3_ct_2010_da align=glw3_ct_2010_da

qqq=`eval g.list raster mapset=CONRASTERS pattern=*2010_da`
for q in ${qqq}
do
	echo ${q}
	r.recode -d --overwrite input=${q} output=${q}_recoded rules=- << EOF
0:100000000:0:100000000
EOF
	r.mapcalc --overwrite "${q}_dens = ${q}_recoded / glw3_areakm"
done
g.remove type=raster pattern=*recoded -f

## ABOVE GROUND BIOMASS v. 2017
r.external --overwrite input=${ORIGDATA}"/GlobBiomass/archives/agb_2017.vrt" output="agb_2017_100m"
## BELOW GROUND BIOMASS v. 2017
r.external input=/globes/USERS/EDUARDO/ORIGINAL_DATASETS/MOLLWEIDE/Glob_Biomass/below_ground_biomass/bgb_processing/BGB/bgb_int_wo_nodata.vrt output=bgb2017_100m

## GHS POPULATION 9 ARCSEC (V. 1, 2019)
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/9arcsec/GHS_POP_E1975_GLOBE_R2019A_4326_9ss_V1_0.tif" output="ghs_pop_9as_1975" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/9arcsec/GHS_POP_E1990_GLOBE_R2019A_4326_9ss_V1_0.tif" output="ghs_pop_9as_1990" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/9arcsec/GHS_POP_E2000_GLOBE_R2019A_4326_9ss_V1_0.tif" output="ghs_pop_9as_2000" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/9arcsec/GHS_POP_E2015_GLOBE_R2019A_4326_9ss_V1_0.tif" output="ghs_pop_9as_2015"


#############################################################

## Link external categorical rasters (mapset=CATRASTERS)
g.mapset --q mapset=CATRASTERS

## CEP (gaul_eez+ecoregions+flat)
r.external --overwrite input=${DERIVDATA}"/DOPA_PROCESSING_2018/cep.tif" output="cep"

## COPERNICUS LAND COVER
# r.external --overwrite input=${ORIGDATA}"/COPERNICUS/LAND_COVER/archives/ProbaV_LC100_epoch2015_global_v2.0.2_discrete-classification_EPSG-4326_CenterPixel_cutted.tif" output="copernicus_lc_vito_2015"
r.external --overwrite input=${ORIGDATA}"/COPERNICUS/LAND_COVER/archives/PROBAV_LC100_global_v3.0.1_2019-nrt_Discrete-Classification-map_EPSG-4326.tif" output="copernicus_lc_2019"


## LPD
r.external --overwrite input=${ORIGDATA}"/LPD/LPD.tif" output="lpd"

## GLOBAL FOREST CHANGE
r.external --overwrite input=${DERIVDATA}"/RASTER/GFC/gain_over30_ll.vrt" output="gfc_gain"
r.external --overwrite input=${DERIVDATA}"/RASTER/GFC/lossyear_over30_ll.vrt" output="gfc_lossyear"
