# COMPUTATION OF DOPA INDICATORS

Most of thematic rater layers used of computation of indicators can be analysed using the [CEP](https://andreamandrici.github.io/dopa_workflow/flattening/) in order to get, with a single run, disaggregated data for country, ecoregion and pa.
Based on the type of raster layer to be analyzed, two different GRASS functions are used:
+ Categorical rasters : [r.stats](https://grass.osgeo.org/grass78/manuals/r.stats.html)
	The surface in square meters of each category of the raster is computed for each object (cid) of the CEP	

+ Continuous rasters: [r.univar](https://grass.osgeo.org/grass78/manuals/r.univar.html)
		Basic statistics (n. of non null cells, min, max, range, mean, st.dev., variance, coeff. of variation, 1st, s2nd,  3rd quartile, 90th percentile) are computed for each object (cid) of the CEP.

All parameters used by scripts are stored in the configuration file **[/servicefiles/cep\_processing.conf](/servicefiles/cep\_processing.conf)**. It has to be checked/edited before running the scripts.
The analysis is performed in parallel, The number of cores used (parameter `NCORES`must be inversely proportional to the resolution of the raster analysed.  For high resolution rasters (30m, such as Global Surface Water) **maximum recommended values is 18**  (higher values will run out server memory with killed processes and unreliable results). Default number of cores is 64. 
**N.B. always check/set the appropriate number of cores before running any script.**


The procedure includes the following steps:

1. Exporting CEP tiles in raster (648 1x1 degrees tiles, numbered using eid values)
2. Importing CEP tiles in GRASS database
3. Computing statistics in GRASS
4. Aggregating results

### 1. Exporting CEP tiles in raster
CEP tiles export procedure is part of the [flattening workflow](https://andreamandrici.github.io/dopa_workflow/flattening/) for the production of CEP.

### 2. Importing CEP tiles in GRASS :
CEP tiles import in GRASS database is performed by the script `exec_import_tiles.sh` and its slave `slave_import_tiles.sh`
The GRASS function **r.external** is used to sequentially link tiff tiles to GRASS database.

### 3. Computing statistics in GRASS
A different `exec_cep_rasterlayername_stats.sh` exists for each raster to be analyzed. Raster layer name and mapset in GRASS database are defined in each script.
Depending on the type of raster considered, each `exec_cep_rasterlayername_stats.sh` script calls the corresponding slave script.
Two base slave scripts perform the core of the analysis for categorical and continuous rasters, respectively:  `slave_cep_catraster_stats.sh` and `slave_cep_conraster_stats.sh`. 
Only for a few rasters, described under [SPECIAL CASES](#SPECIAL CASES), specific slave scripts have to be executed.


#### CATEGORICAL_RASTERS

Scripts:

`exec_cep_rasterlayername_stats.sh` and `slave_cep_catraster_stats.sh`

The two scripts perform the following operations:
+ run r.stats in parallel on each CEP tile, writing in output a csv file specific fot each tile.
+ aggregate all the csv files into a single one
+ build a table in pg dabatase and import csv


#### CONTINUOUS_RASTERS

Scripts:

`exec_cep_rasterlayername_stats.sh` and `slave_cep_conraster_stats.sh`

For memory management reasons, analysis of continuous layers is performed with two nested cycles: the main cycle is run in parallel over eid tiles, while for each eid tile a second cycle is run sequentially over each qid, adapting accordingly the working region for each cycle.
Region parameters of each qid are extracted from the [qid_index.csv](../servicefiles/qid_index.csv) file, having the following structure:
    
	eid_id|qid|y_max|y_min|x_max|x_min

The [qid_index.csv](../servicefiles/qid_index.csv) file can be generated in pg from the cep.grid_vector table with the following query:

    SELECT 
    'eid_'||eid::text eid_id,qid,y_max,y_min,x_max,x_min
    FROM cep.grid_vector ORDER BY eid,qid

The two scripts perform the following operations:
+ launch in parallel a slave script for each eid tile; the slave performs the followings:
	+ set the region on each qid and run r.univar with extended statistics. A csv file is written i output foe each qid;
	+ post-process each csv file:
		- remove header;
		- add eid and qid values at the beginning of each line;
		- replace 'nan' with 0.
	+ aggregate all csv files  for that eid.
+ aggregate all the csv files into a single one
+ build a table in pg database and import the final csv.

#### SPECIAL CASES
[...]

### NOTES
1. In order to optimize processing time, both CEP and thematic layers should be cutted in tiles using the same grid [...] (topic to be expanded)

2. When data are available only for land, processing time can be significantly reduced by processing only eid tiles including non null values in the considered raster. It is particularly useful for high resolution rasters such as GFC and GHS Built up.
This can be implemented by replacing

    for eid in {1..648} 
      do this and that
    done

	with 

		for eid in $(cat /path_to_tiles_list_file/tiles_list.txt)
		  do this and that
		done

	Presently, list of tiles to be processed exist for the following themes:

	+ [GHSL Builtup](builtup_tiles_selected.txt)

	+ [GFC Treecover, Gain and Loss](treecover_tiles_selected.txt)

	+ [Worldclim](worldclim_tiles_selected.txt) (presently not analysed with CEP)

	+ [SeaSurface temperature](sst_tiles_selected.txt) (presently not analysed with CEP)


	For Global Surface Water, analysis is lintesa dlimited to actually existing GSW tiles:

		for eid in {109..612} 
		  do this and that
		done

