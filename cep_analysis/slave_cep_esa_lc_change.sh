#!/bin/bash
##COMPUTE LAND COVER CHANGE ON ESA CCI datasets (1995 and 2020)

eid=$1
TMP_MAPSET=$2
RESULTSPATH=$3
IN_RASTER1=$4
IN_RASTER2=$5
OUTCSV=$6
CEP_MAPSET=$7

## commenting/uncommenting 'align=${IN_RASTER}' at line 15 allows to perform the analysis, respectively, at cep/${IN_RASTER} resolution

echo "#!/bin/bash
## SET REGION
g.region raster=ceptile_${eid}@${CEP_MAPSET} align=${IN_RASTER1}
## ANALYZE IN_RASTER WITH R.STATS
r.stats -a --o --q input=qid_grid@PERMANENT,ceptile_${eid}@${CEP_MAPSET},${IN_RASTER1},${IN_RASTER2} separator=pipe null_value=0 output=${RESULTSPATH}/${OUTCSV}
exit
" > ./dyn/rstats_${eid}.sh
chmod u+x ./dyn/rstats_${eid}.sh
grass ${TMP_MAPSET} --exec ./dyn/rstats_${eid}.sh
exit


