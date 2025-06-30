gdalwarp -of Gtiff -co COMPRESS=DEFLATE -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -ot UInt16 -te 50 70 60 80 /spatial_data/Original_Datasets/GHSL/uncompressed/builtup/R2023A/GHS_BUILT_S_E2020_GLOBE_R2023A_4326_3ss_V1_0.tif /spatial_data/Derived_Datasets/RASTER/GHSL/R2023A/builtup/tiles_2020/builtup_tile_600.tif

