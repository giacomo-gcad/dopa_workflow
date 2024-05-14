# WDPA PREPROCESSING

After downloading of the WDPA zip file, a series of steps are run in order to pre-process and prepare all the necessary tables and layers for the subsequent analysis phase. All the scripts needed for this phase are stored into **/wdpa\_preprocessing/** folder.

**NOTES**
All parameters used by scripts are stored in the configuration file **[/servicefiles/wdpa\_preprocessing.conf](/servicefiles/wdpa\_preprocessing.conf)**. It has to be checked/edited before running the scripts.

N.B. passwords for connection to PostgreSQL database are not explicitly written  in the .conf file. Instead, they are read from the docker .pgpass file. Different settings on different docker machines could have different beahvours and it could be needed to edit the definition of the 'dbpar1' and/or 'dbpar2' in the exec* scripts.

Steps from 1 to 3 are devoted to the preparation of the base wdpa dataset (containing all relevant PAs) to be used for the preparation of the CEP. Also, a layer with  10km buffers on PAs over 10 km2 is created.

Steps from 4 to 8 are devoted to transfer of PAs over 5 km2 and of buffers in GRASS for subsequent computation of .

## **1. Data Import**

  1.1 Imports in PG database relevant WDPA data: access the downloaded .zip file, imports attributes and geometries of points and polygons in three distinct tables of PG database.
   Objects are filtered as follows:
	
    - points: `STATUS NOT IN ('Not Reported', 'Proposed') And DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve') And REP_AREA > 0`
	
    - polygons: `STATUS NOT IN ('Not Reported', 'Proposed') And DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')`
	
  1.2 Buffering of point PAs. Buffer radius is computed from the 'rep_area' field.

  1.3 Flagging invalid geometries and repairing them with ST_MakeValid.

  1.4 Creation of final wdpa table with attributes and wdpa_o5 (>5 sq.km.) table.

**SCRIPTS** (to be executed in this order): 

`exec_wdpa_import.sh`

`exec_wdpa_wdoecm_preprocessing_part_1.sh` and its slave `wdpa_wdoecm_preprocessing_part_1.sql`

`fix_wdpa_geom.sql` , to be executed in postgis **STEP BY STEP**, checking results after each step and, in case of need, manually repairing invalid geometries.

`exec_wdpa_wdoecm_preprocessing_part_2.sh` and its slave `exec_wdpa_wdoecm_preprocessing_part_2.sql`

## **2. Creation of 10 km buffers**

  2.1 Computes buffers on all features.

  2.2 Selects buffers intersecting anti-meridian, shift corresponding PAs, recompute buffers and shift them back.

  2.3 Creates the final buffers table.

**SCRIPTS**: `exec_buffers_processing.sh` and its slave `wdpa_buffers_processing.sql`; 

**N.B.** The 10km buffers computed here on PAs over 5 km2 are 'gross' buffers, while the 'unprotected' buffers are built as flat layer, using the same procedure used for [CEP](https://andreamandrici.github.io/dopa_workflow/flattening/).


## **3. Data preparation for GRASS**
 
  3.1 Creates necessary schemes for PAs and buffers.

  3.2 Creates PAs and buffers lists (full list, only terrestrial and coastal, only marine) as views and as text files, for later use in GRASS analysis loops.

  3.3 Creates individual views for each PA and for each Buffer.

**NOTES**
Text files with lists of PAs and buffers are used in all the GRASS based scripts for data analysis (see relevant section).

**SCRIPTS**: `exec_prepare_data_x_grass.sh` and its slave `prepare_data_x_grass.sql`

## **4. Data transfer from PG to GRASS**

  4.1 Iterates views of PAs to export each view in shapefile with ogr2ogr.

  4.2	Imports individual shapefiles of PAs in GRASS database using v.in.ogr.

**SCRIPTS**:`exec_pg_to_grass.sh` and its slave `slave_pg_to_grass.sh` 

**N.B.** Recommended n. of cores for this step: **no more than 40 cores (edit wdpa_preprocessing.conf accordingly)**. Using more than 40 cores may result in FATAL errors of ogr2ogr (too many connections).

## **5. Reprojection in Mollweide of individual PAs** 
 
  5.1 Iterates vector layers in GRASS database (WGS84LL location) of PAs and reproject them in Mollweide. Results are stored into MOLLWEIDE location.

**SCRIPTS**:`exec_project_pa_bu.sh` and its slave `slave_project_pa_bu.sh`

**NOTES**: Reprojection in Mollweide of PAs is required for computation of THDI (Terrestrial Habitat Diversity Profile) indicator (see [wdpa_processing](/wdpa_processing/#THDI)  section).


