#!/bin/bash
# LINK RASTERS IN MOLLWEIDE (to be run in MOLLWEIDE location)

# set variables
ORIGDATA=$1
DERIVDATA=$2

## Create mapsets and grant access
g.mapset --q -c --overwrite mapset=CONRASTERS
g.mapset --q -c --overwrite mapset=CATRASTERS

## Link external categorical rasters (mapset=CATRASTERS)

##ESA-CCI LAND COVER
r.external --overwrite input=${DERIVDATA}"/RASTER/ESA_CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-1995-v2.0.7.tif" output="esalc_1995" &
r.external --overwrite input=${DERIVDATA}"/RASTER/ESA_CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2000-v2.0.7.tif" output="esalc_2000" &
r.external --overwrite input=${DERIVDATA}"/RASTER/ESA_CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2005-v2.0.7.tif" output="esalc_2005" &
r.external --overwrite input=${DERIVDATA}"/RASTER/ESA_CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7.tif" output="esalc_2010" &
r.external --overwrite input=${DERIVDATA}"/RASTER/ESA_CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif" output="esalc_2015"

##LANDSCAPE FRAGMENTATION (MSPA_LC)
r.external --overwrite input=${DERIVDATA}"/RASTER/MSPA_LC/CCI1995_spa6.tif" output="mspa_lc_1995" &
r.external --overwrite input=${DERIVDATA}"/RASTER/MSPA_LC/CCI2000_spa6.tif" output="mspa_lc_2000" &
r.external --overwrite input=${DERIVDATA}"/RASTER/MSPA_LC/CCI2005_spa6.tif" output="mspa_lc_2005" &
r.external --overwrite input=${DERIVDATA}"/RASTER/MSPA_LC/CCI2010_spa6.tif" output="mspa_lc_2010" &
r.external --overwrite input=${DERIVDATA}"/RASTER/MSPA_LC/CCI2015_spa6.tif" output="mspa_lc_2015"

## GLOBAL FOREST CHANGE - GAIN AND LOSSYEAR
r.external --overwrite input=${DERIVDATA}"/RASTER/GFC/gain_over30.vrt" output="gfc_gain" &
r.external --overwrite input=${DERIVDATA}"/RASTER/GFC/lossyear_over30.vrt" output="gfc_lossyear"

## GLOBAL SURFACE WATER
r.external --overwrite input=${DERIVDATA}"/RASTER/GSW/gsw.vrt" output="gsw_transitions"

## BUILT UP AREAS
r.external --overwrite input=${DERIVDATA}"/RASTER/GHSL/builtup/builtup_v2.vrt" output="ghs_built_v2"


## Link external continuous rasters in Mollweide  (mapset=CONRASTERS)

g.mapset --q mapset=CONRASTERS

## GHS_POP 1km
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/1km/GHS_POP_GPW41975_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW41975_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_1975" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/1km/GHS_POP_GPW41990_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW41990_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_1990" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/1km/GHS_POP_GPW42000_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW42000_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_2000" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/1km/GHS_POP_GPW42015_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW42015_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_2015"

## GHS_POP 250km (v. 2019)
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/250m/GHS_POP_E1975_GLOBE_R2019A_54009_250_V1_0.tif" output="ghs_pop250_1975" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/250m/GHS_POP_E1990_GLOBE_R2019A_54009_250_V1_0.tif" output="ghs_pop250_1990" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/250m/GHS_POP_E2000_GLOBE_R2019A_54009_250_V1_0.tif" output="ghs_pop250_2000" &
r.external --overwrite input=${ORIGDATA}"/GHSL/uncompressed/population/250m/GHS_POP_E2015_GLOBE_R2019A_54009_250_V1_0.tif" output="ghs_pop250_2015"

## gROADS Buffers 250 m
r.external --overwrite input=${DERIVDATA}"/RASTER/gROADS/groads_buffer_250m_moll.tif" output="groads"

exit
