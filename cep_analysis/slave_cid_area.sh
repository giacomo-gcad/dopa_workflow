#!/bin/bash
##COMPUTE STATISTICS ON CEP AND CATEGORICAL RASTER AT RESOLUTION OF RASTER

eid=$1
TMP_MAPSET=$2
RESULTSPATH=$3
IN_RASTER=$4
OUTCSV=$5
CEP_MAPSET=$6

echo "#!/bin/bash
## SET REGION
g.region raster=ceptile_${eid}@${CEP_MAPSET} align=${IN_RASTER}
## COMPUTE CID AREA AT IN_RASTER RESOLUTION WITH R.STATS
r.stats -a --o --q input=qid_grid@PERMANENT,ceptile_${eid}@${CEP_MAPSET} separator=pipe null_value=0 output=${RESULTSPATH}/${OUTCSV}
exit
" > ./dyn/cid_area_${eid}.sh
chmod u+x ./dyn/cid_area_${eid}.sh
grass ${TMP_MAPSET} --exec ./dyn/cid_area_${eid}.sh
exit
