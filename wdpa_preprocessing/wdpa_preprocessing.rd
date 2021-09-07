# WDPA PREPROESSING

After downloading of the WDPA zip file, a series of steps are run in order to pre-process and prepare all the necessary tables and layers for the subsequent analysis phase. All the scripts needed for this phase are stored into **/wdpa\_preprocessing/** folder.

**NOTES**
All parameters used by scripts are stored in the configuration file **[/service\_files/wdpa\_preprocessing.conf](/service\_files/wdpa\_preprocessing.conf)**. It has to be checked/edited before running the scripts.

N.B. passwords for connection to PostgreSQL database are not explicitly written  in the .conf file. Instead, they are read from the docker .pgpass file. Different settings on different docker machines could have different beahvours and it could be needed to edit the definition of the 'dbpar1' and/or 'dbpar2' in the exec* scripts.

Steps from 1 to 3 are devoted to the preparation of the three base wdpa datasets: all PAs, PAs over 5 km2 and 10km buffers on PAs over 10 km2.

Steps from 4 to 8 are devoted to transfer of  PAs over 10 km2 and of buffers in GRASS for subsequent analysis.


## **1. SOURCE*

## **2. IMPORT**

  2.1 Imports in PG database relevant WDPA data: access the downloaded .zip file, imports attributes and geometries of points and polygons in three distinct tables of PG database.
   Objects are filtered as follows:
	
    - points: `STATUS NOT IN ('Not Reported', 'Proposed') And DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve') And REP_AREA > 0`
	
    - polygons: `STATUS NOT IN ('Not Reported', 'Proposed') And DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')`
	
  2.2 Buffering of point PAs. Buffer radius is computed from the 'rep_area' field.

  2.3 Flagging invalid geometries and repairing them with ST_MakeValid.

  2.4 Creation of final wdpa table with attributes and wdpa_o5 (>5 sq.km.) table.

**SCRIPTS** (to be executed in this order): 

`exec_wdpa_import.sh`

`exec_wdpa_preprocessing_part_1.sh` and its slave `wdpa_preprocessing_part_1.sql`

`fix_wdpa_geom.sql` , to be executed in postgis **STEP BY STEP**, checking results after each step and, in case of need, manually repairing invalid geometries.

`exec_wdpa_preprocessing_part_2.sh` and its slave `wdpa_preprocessing_part_2.sql`

#### **3. Creation of 10 km buffers**

  3.1 Computes buffers on all features.

  3.2 Selects buffers intersecting anti-meridian, shift corresponding PAs, recompute buffers and shift them back.

  3.3 Creates the final buffers table.

**SCRIPTS**: `exec_buffers_processing.sh` and its slave `wdpa_buffers_processing.sql`; 

**N.B.** The 10km buffers computed here on PAs over 5 km2 are 'gross' buffers, while the 'unprotected' buffers are computed in GRASS (see Step 6 below).


#### **4. Data preparation for GRASS**
 
  4.1 Creates necessary schemes for PAs and buffers.

  4.2 Creates PAs and buffers lists (full list, only terrestrial and coastal, only marine) as views and as text files, for later use in GRASS analysis loops.

  4.3 Creates individual views for each PA and for each Buffer.

**NOTES**
Text files with lists of PAs and buffers are used in all the GRASS based scripts for data analysis (see relevant section).

**SCRIPTS**: `exec_prepare_data_x_grass.sh` and its slave `prepare_data_x_grass.sql`

#### **5. Creation of wdpa_flat** (required to produce at a later stage unprotected buffers in GRASS)
This flat is required in order to compute unprotected buffers (see Step 6)

  5.1 Import in GRASS database the whole WDPA dataset, without attributes table.

  5.2 Running in parallel on 32 different regions, converts to raster the vector WDPA at 3 arc-seconds resolution (about 90m at the equator).

  5.3 Using r.patch, mosaic the 32 raster tiles into a single raster layer.

**SCRIPTS**:`exec_make_flat.sh` and its slave `slave_make_flat.sh`

#### **6. Data transfer from PG to GRASS**

  6.1 Iterates views of PAs to export each view in shapefile with ogr2ogr.

  6.2	Imports individual shapefiles of PAs and buffers in GRASS database using v.in.ogr.

  6.3 Import and process individual shapefiles of BUs: buffers are erased with wdpa_flat in order to keep only their unprotected portion.

**SCRIPTS**:`exec_pg_to_grass.sh` and its slaves `slave_pg_to_grass.sh` and `slave_unprot_buffer.sh`

**N.B.** Recommended n. of cores for this step: **no more than 40 cores (edit wdpa_preprocessing.conf accordingly)**. Using more than 40 cores may result in FATAL errors of ogr2ogr (too many connections).

#### **7. Reprojection in Mollweide of individual PAs and BUs layers** 

  7.1 Iterates vector layers in GRASS database (WGS84LL location) of PAs and buffers and reproject them in Mollweide. Results are stored into MOLLWEIDE location.

**SCRIPTS**:`exec_project_pa_bu.sh` and its slave `slave_project_pa_bu.sh`

**NOTES**: Reprojection in Mollweide of PAs is required for computation of THDI (Terrestrial Habitat Diversity Profile) indicator (see [wdpa_processing](wdpa_processing.rd)  section)