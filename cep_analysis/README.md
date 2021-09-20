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

1. Exporting CEP tiles in raster (648 1-x1 degrees tiles, numbered using eid values)
2. Importing CEP tiles in GRASS database
3. Computing statistics in GRASS
4. Aggregating results

### 1. Exporting CEP tiles in raster
CEP tiles export procedure is part of the [flattening workflow](https://andreamandrici.github.io/dopa_workflow/flattening/) for the production of CEP.

### 2. Importing CEP tiles in GRASS :
CEP tiles import in GRASS database is performed by the script `exec_import_tiles.sh` and its slave `slave_import_tiles.sh`
The GRASS function **r.external** is used to sequentially link tiff tiles to GRASS database.

In order to optimize processing time, both CEP and thematic layers should be cutted in tiles using the same grid [...] (topic to be expanded)


### 3. Computing statistics in GRASS
A different `exec_cep_rasterlayername_stats.sh` exists for each raster to be analyzed. Raster layer name and mapset in GRASS database are defined in each script.
Depending on the type of raster considered, each `exec_cep_rasterlayername_stats.sh` script calls the corresponding slave script.
Two base slave scripts perform the core of the analysis for categorical and continuous rasters, respectively:  `slave_cep_catraster_stats.sh` and `slave_cep_conraster_stats.sh`. 
Only for a few rasters, described under [SPECIAL CASES](#SPECIAL CASES), specific slave scripts have to be executed.


#### CATEGORICAL_RASTERS

[...]  (topic to be expanded)
`exec_cep_rasterlayername_stats.sh` and `slave_cep_catraster_stats.sh`

#### CONTINUOUS_RASTERS
[...]  (topic to be expanded)
`exec_cep_rasterlayername_stats.sh` and `slave_cep_conraster_stats.sh`

#### SPECIAL CASES
[...]





