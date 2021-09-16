#!/bin/bash
# EXPORT THDI RASTER LAYERS TO TIFF
date

# SET VARIABLES
grass_mapset="/globes/USERS/GIACOMO/eHabitat/hdi_db/global_MW/rasterized_parks"
outpath="/spatial_data/Derived_Datasets/RASTER/THDI/"

grass ${grass_mapset} --exec r.out.gdal -c input=bio output=${outpath}"bio.tif" type=Float32 nodata=0 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=ndwi output=${outpath}"ndwi.tif" type=Byte nodata=255 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=herb output=${outpath}"herb.tif" type=Byte nodata=255 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=tree output=${outpath}"tree.tif" type=Byte nodata=255 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=pre output=${outpath}"pre.tif" type=Float32 nodata=0 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=slope output=${outpath}"slope.tif" type=Float32 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=ndvimax2 output=${outpath}"ndvimax2.tif" type=UInt32 nodata=0 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=ndvimin output=${outpath}"ndvimin.tif" type=UInt32 nodata=0 createopt="COMPRESS=DEFLATE" --o --q
grass ${grass_mapset} --exec r.out.gdal -c input=eprsqrt2 output=${outpath}"eprsqrt2.tif" type=UInt32 nodata=0 createopt="COMPRESS=DEFLATE" --o --q

date
exit
