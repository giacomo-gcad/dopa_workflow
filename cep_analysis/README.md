# COMPUTATION OF DOPA INDICATORS

Most of thematic rater layers used of computation of indicators can be analysed using the [CEP](https://andreamandrici.github.io/dopa_workflow/flattening/) in order to get, with a single run, disaggregated data for country, ecoregion and pa.
The procedure includes the following steps:

1. exporting CEP tiles in raster (648 1-x1 degrees tiles, numbered using eid values)
2. importing CEP tiles in GRASS database
3. computing statistics in GRASS for each tile with a parallelized approach
4. aggregating results

CEP tiles export procedure is part of the [flattening workflow](https://andreamandrici.github.io/dopa_workflow/flattening/)

Steps 2-4 are executed by a series of scripts stored in **/cep_analysis/** folder.

CEP tiles import in GRASS database is performed by the script `exec_import_tiles.sh` and its slave `slave_import_tiles.sh`


In orter to optimize processing time, both CEP and thematic layers should be cutted in tiles using the same grid [...]


## CATEGORICAL_RASTERS
[...]
`exec_cep_rasterlayername_stats.sh` and `slave_cep_catraster_stats.sh`

## CONTINUOUS_RASTERS
[...]
`exec_cep_rasterlayername_stats.sh` and `slave_cep_conraster_stats.sh`

## SPECIAL CASES
[...]



