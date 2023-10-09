## **Raster data preprocessing and import in GRASS Database** 

Import as links (using r.external) to external Tiff or vrt files all the raster dataset needed for calculation of indicators. 
**SCRIPTS**:`exec_link_rasters.sh` and its slaves `slave_link_rasters_wgs84ll.sh`, `slave_link_rasters_mollweide.sh` and `slave_link_rasters_sst.sh`

If new raster datasets need to be added, the slave scripts will have to be edited accordingly, using the following rules:

* Continuous raster in Lat/Long: edit script `slave_link_rasters_wgs84ll.sh` and import it into CONRASTERS mapset
* Categorical raster in Lat/Long: edit script `slave_link_rasters_wgs84ll.sh` and import it into CATRASTERS mapset
* Continuous raster in MOLLWEIDE: edit script `slave_link_rasters_mollweide.sh` and import it into CONRASTERS mapset
* Categorical raster in MOLLWEIDE: edit script `slave_link_rasters_mollweide.sh` and import it into CATRASTERS mapset.


The GRASS Database to be used for import is defined by the configuration file  **[/servicefiles/wdpa\_preprocessing.conf](/servicefiles/wdpa\_preprocessing.conf)**.

**N.B. This script needs to be run only if a new GRASS database is used or if some raster datasets are changed.**

The following datasets are physically imported (with r.import) instead of linked because of problems with management of No Data values in the Tiff file.


* Worldclim (tavg, tmax and tmin)

* Sea Surface Temperature data (tavg, tmax and tmin)

Most of the raster datasets are imported 'as they are' from the /spatial\_data/Original\_Datasets folder but there are some exceptions. For each exception listed below, scripts for raster processing before import in GRASS database are provided in  **[/raster_processing/](/raster_processing/)** folder.

* Global Forest Change data need to be preprocessed to mask pixels with treecover value<30. Masking and renaming of tiles (using the same numbering of CEP tiles) are performed by the following scripts:
`exec_mask_gfc.sh`(/raster_processing/exec_mask_gfc.sh)
`rename_gain_tiles.sh`(/raster_processing/rename_gain_tiles.sh)
`rename_lossyear_tiles.sh`(/raster_processing/rename_lossyear_tiles.s)
`rename_treecover_tiles.sh`(/raster_processing/rename_treecover_tiles.sh)

* Groads is a raster dataset obtained through processing of the Groads vector layer. A buffer of 250m is built on the two sides of each road and rasterized at 250m resolution  in Mollweide projection. Two arcpy script are involved (an ArcGis license is required):
`process_groads_step1.py`
`process_groads_step2.py`

* Raster files of the THDI package are not imported by the script. They are included in the GRASS database /globes/USERS/GIACOMO/eHabitat/hdi_db/global_MW/ehabitat/ (see more details in [THDI](./wdpa_processing/#THDI) section -TO BE WRITTEN).

Processed/modified raster datasets are stored in /spatial\_data/Derived\_datasets/ 

Scripts to pre-process each of the above mentioned derived rasters are stored in /globes/processing\_current/raster\_processing/ 

