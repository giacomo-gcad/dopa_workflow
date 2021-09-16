#!/bin/bash
# PROCESS AGB AND BGB IN ORDER TO DERIVE AGC AND BGC

export GRASS_COMPRESSOR=ZLIB # added on 20201008

# SET MAPSET
g.mapset CONRASTERS -p

############### RESAMPLING PHASE ############################
## SET REGION FOR AGB

g.region raster=agb2017_100m -p # re-run on 20201008
## CONVERT AGB (DENSITY) IN ABOVE GROUND CARBON AMOUNT. OUTPUT UNITS: Mg
r.mapcalc --overwrite expression="agc2017_100m=agb2017_100m@CONRASTERS / 2 * area() / 10000"  # re-run on 20201008
## SET REGION FOR AGB 1km resolution
g.region raster=agb2017_100m res=0:00:30 -p  # re-run on 20201009
##RESAMPLE AGC to GSOC RESOLUTION (1km) WITH AGGREGATION (SUM) OUTPUT UNITS: Mg
r.resamp.stats --overwrite input=agc2017_100m output=agc2017_1km method=sum  # re-run on 20201009

## SET REGION FOR BGB
g.region raster=bgb2017_100m -p
## CONVERT BGB (DENSITY) IN BELOW GROUND CARBON AMOUNT. OUTPUT UNITS: Mg
r.mapcalc --overwrite expression="bgc2017_100m=bgb2017_100m@CONRASTERS / 2 * area() / 10000"   # re-run on 20201009
## SET REGION FOR AGB 1km resolution
g.region raster=bgb2017_100m res=0:00:30 -p
## RESAMPLE BGB to GSOC RESOLUTION (1km) WITH AGGREGATION (SUM) OUTPUT UNITS: Mg
r.resamp.stats --overwrite input=bgc2017_100m output=bgc2017_1km method=sum

# SET REGION FOR GSOC
g.region raster=gsoc -p
## CONVERT SOIL CARBON DENSITY IN SOIL CARBON AMOUNT. OUTPUT UNITS: Mg
# r.mapcalc --overwrite expression="gsoc_tot=gsoc@CONRASTERS * 100 * area() / 1000000" # No need to re-run it, already exists

############### COMPUTING TOTAL CARBON LAYER ############################
g.region raster=cep_202009@CEP align=agc2017_1km -p	# re-run on 20201009
r.mapcalc --overwrite expression="carbon_tot_202009=gsoc_tot + agc2017_1km + bgc2017_1km"	# re-run on 20201009
