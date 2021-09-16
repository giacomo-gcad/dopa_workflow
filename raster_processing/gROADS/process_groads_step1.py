# ---------------------------------------------------------------------------
# Roads Buffer (arcpy)
# This script makes buffers around lines of gROADS vector layer
# Bufferized layer is the used by the 'process_groads_step2.py' script to 
# make a raster layer
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
 
## Local variables:
buffer_value="250 Meters"
out_path = arcpy.env.workspace
roads_vector = "Y:/Original_Datasets/gROADS/uncompressed/gROADS_v1.gdb/Global_Roads"
out_folder_path = "Y:/Derived_Datasets/RASTER/gROADS/"
out_gdb = "gROADS.gdb"
out_name = "groads_buffers_250m"
roads_Buffer_01 = out_folder_path+out_gdb+"/gROADS_buff_01"
roads_Buffer_02 = out_folder_path+out_gdb+"/gROADS_buff_02"
roads_Buffer_03 = out_folder_path+out_gdb+"/gROADS_buff_03"
roads_Buffer_04 = out_folder_path+out_gdb+"/gROADS_buff_04"
roads_Buffer_05 = out_folder_path+out_gdb+"/gROADS_buff_05"
roads_Buffer_06 = out_folder_path+out_gdb+"/gROADS_buff_06"
roads_Buffer_07 = out_folder_path+out_gdb+"/gROADS_buff_07"
roads_Buffer_08 = out_folder_path+out_gdb+"/gROADS_buff_08"

geometry_type = "POLYGON"
template = roads_Buffer_01
has_m = "DISABLED"
has_z = "DISABLED"

arcpy.env.workspace = out_folder_path + out_gdb

## Execute CreateFileGDB
if arcpy.Exists(out_folder_path+out_gdb):
    print("Output gdb already exists.")
else:
    print("Creating output gdb...")
    arcpy.CreateFileGDB_management(out_folder_path, out_gdb)

## Buffer around roads is done splitting the process into 8 steps (querying the gRoads layer with OBJECTID equal intervals).
## Then, the 8 vector tiles are appended into a single one

# Select and make buffer on objects 1 - 200000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_01")
print('Layer 01 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_01", selection_type="NEW_SELECTION", where_clause="OBJECTID >=1 AND OBJECTID <=200000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_01", roads_Buffer_01, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 01 completed')

# Select and make buffer on objects 200000 - 400000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_02")
print('Layer 02 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_02", selection_type="NEW_SELECTION", where_clause="OBJECTID >=200001 AND OBJECTID <=400000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_02", roads_Buffer_02, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 02 completed')

# Select and make buffer on objects 400000 - 600000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_03")
print('Layer 03 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_03", selection_type="NEW_SELECTION", where_clause="OBJECTID >=400001 AND OBJECTID <=600000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_03", roads_Buffer_03, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 03 completed')

# Select and make buffer on objects 600000 - 800000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_04")
print('Layer 04 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_04", selection_type="NEW_SELECTION", where_clause="OBJECTID >=600001 AND OBJECTID <=800000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_04", roads_Buffer_04, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 04 completed')

# Select and make buffer on objects 800000 - 1000000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_05")
print('Layer 05 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_05", selection_type="NEW_SELECTION", where_clause="OBJECTID >=800001 AND OBJECTID <=1000000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_05", roads_Buffer_05, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 05 completed')

# Select and make buffer on objects 1000000 - 1200000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_06")
print('Layer 06 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_06", selection_type="NEW_SELECTION", where_clause="OBJECTID >=1000001 AND OBJECTID <=1200000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_06", roads_Buffer_06, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 06 completed')

# Select and make buffer on objects 1200000 - 1400000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_07")
print('Layer 07 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_07", selection_type="NEW_SELECTION", where_clause="OBJECTID >=1200001 AND OBJECTID <=1400000")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_07", roads_Buffer_07, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 07 completed')

# Select and make buffer on objects 1400000 - 1607000
arcpy.MakeFeatureLayer_management(roads_vector, "roads_tile_08")
print('Layer 08 created ')
arcpy.SelectLayerByAttribute_management(in_layer_or_view="roads_tile_08", selection_type="NEW_SELECTION", where_clause="OBJECTID >=1400001")
print('Objects selected')
print('Now buffering, be patient...')
arcpy.Buffer_analysis("roads_tile_08", roads_Buffer_08, buffer_value, "FULL", "ROUND", "ALL", "")
print('Buffering Layer 08 completed')


# Append tiles to final layer
fcList = roads_Buffer_01, roads_Buffer_02, roads_Buffer_03, roads_Buffer_04, roads_Buffer_05, roads_Buffer_06, roads_Buffer_07, roads_Buffer_08
#fcList = arcpy.ListFeatureClasses()

spatial_reference = arcpy.Describe(roads_Buffer_01).spatialReference

schemaType = "NO_TEST"
fieldMappings = ""
subtype = ""

arcpy.CreateFeatureclass_management(out_path, out_name, geometry_type, template, has_m, has_z, spatial_reference)
print('Now appending layers, be patient...')
arcpy.Append_management(fcList, out_name, schemaType, fieldMappings, subtype)
print('Layers appended')

# Delete tiles
arcpy.Delete_management(roads_Buffer_01)
arcpy.Delete_management(roads_Buffer_02)
arcpy.Delete_management(roads_Buffer_03)
arcpy.Delete_management(roads_Buffer_04)
arcpy.Delete_management(roads_Buffer_05)
arcpy.Delete_management(roads_Buffer_06)
arcpy.Delete_management(roads_Buffer_07)
arcpy.Delete_management(roads_Buffer_08)
print('Intermediate layers deleted')

print(' ')
print('-------------------------------------------------------')
endtime=datetime.now()
totaltime= endtime-firststarttime
print(' ')
print('PROCEDURE COMPLETED. Elapsed time: ', totaltime)
print(' ')
