# ---------------------------------------------------------------------------
# Roads Reproject and rasterize (arcpy)
# This script projects in MOLLWEIDE the buffers generated with 
# 'process_groads_step1.py' and rasterize it at the resolution specified by
# the user. Output is a GeoTIFF file
# ---------------------------------------------------------------------------

# Import arcpy modules
import arcpy
from arcpy import env
import os
import os.path
from arcpy.sa import *

from datetime import datetime
firststarttime=datetime.now()
print("PROCEDURE STARTED at ", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

## Check out any necessary licenses
arcpy.CheckOutExtension("spatial")

## Global variables:
arcpy.env.overwriteOutput = True
arcpy.env.pyramid = "NONE"

## Local variables (to be edited by the user)
in_dataset="Y:/Derived_Datasets/RASTER/gROADS/gROADS.gdb/groads_buffers_250m"
out_dataset="Y:/Derived_Datasets/RASTER/gROADS/gROADS.gdb/groads_buffers_250m_moll"
outRaster1="Y:/Derived_Datasets/RASTER/gROADS/groads_buffer_250m_moll_tmp.tif"
outRaster2="Y:/Derived_Datasets/RASTER/gROADS/groads_buffer_250m_moll.tif"
expression="100"
valField="value"
assignmentType=""
priorityField=""
cellSize=250

## Reprojects gROADS buffers in Mollweide
arcpy.Project_management(in_dataset, out_dataset, out_coor_system="PROJCS['World_Mollweide',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Mollweide'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],UNIT['Meter',1.0]]", transform_method="", in_coor_system="GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]]", preserve_shape="NO_PRESERVE_SHAPE", max_deviation="", vertical="NO_VERTICAL")
print("gROADS buffers reprojected in Mollweide")

## Add a field to store the value to be used for rasterization
arcpy.AddField_management(out_dataset, "value", "SHORT")
arcpy.CalculateField_management(out_dataset, "value", expression, "PYTHON3")

## Rasterize gROADS buffers
print("Now rasterizing buffers, please be patient...")
arcpy.PolygonToRaster_conversion(out_dataset, valField, outRaster1, assignmentType, priorityField, cellSize)

## Reclass NoData to zero
print("Now reclassing NoData values to zero, please be patient...")
remap = RemapValue([["NODATA",0]])
outReclass = Reclassify(outRaster1, "Value", remap, "DATA")
outReclass.save(outRaster2)

## Remove temporary files
leng=len(outRaster1)-4
rootrast=outRaster1[0:leng]
rastfiles=rootrast+".*"
print(rastfiles)
os.remove(rastfiles)


endtime=datetime.now()
totaltime= endtime-firststarttime
print(' ')
print('PROCEDURE COMPLETED. Elapsed time: ', totaltime)
print(' ')
