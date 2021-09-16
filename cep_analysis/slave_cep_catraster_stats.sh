#!/bin/bash
##COMPUTE STATISTICS ON CEP AND CATEGORICAL RASTER

eid=$1
TMP_MAPSET=$2
RESULTSPATH=$3
IN_RASTER=$4
OUTCSV=$5
CEP_MAPSET=$6

## commenting/uncommenting 'align=${IN_RASTER}' at line 15 allows to perform the analysis, respectively, at cep/${IN_RASTER} resolution

echo "#!/bin/bash
## SET REGION
g.region raster=ceptile_${eid}@${CEP_MAPSET} align=${IN_RASTER}
## ANALYZE IN_RASTER WITH R.STATS
r.stats -a --o --q input=qid_grid@PERMANENT,ceptile_${eid}@${CEP_MAPSET},${IN_RASTER} separator=pipe null_value=0 output=${RESULTSPATH}/${OUTCSV}
exit
" > ./dyn/rstats_${eid}.sh
chmod u+x ./dyn/rstats_${eid}.sh
t1=`date +%s`
grass ${TMP_MAPSET} --exec ./dyn/rstats_${eid}.sh
t2=`date +%s`
proctime=$((t2-t1))
echo "eid ${eid} processed in " ${proctime} "seconds"
exit
