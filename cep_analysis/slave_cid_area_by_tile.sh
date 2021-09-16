#!/bin/bash
##COMPUTE STATISTICS ON CEP AND CATEGORICAL RASTER

eid=$1
TMP_MAPSET=$2
RESULTSPATH=$3
OUTCSV=$4
CEP_MAPSET=$5

echo "#!/bin/bash
    ## SET REGION
	g.region raster=ceptile_${eid}@${CEP_MAPSET}
	## ANALYZE IN_RASTER WITH R.STATS
	r.stats -a --o --q input=ceptile_${eid}@${CEP_MAPSET} separator=pipe null_value=0 output=${RESULTSPATH}/${OUTCSV}
	exit
	" > ./dyn/cidarea_${eid}.sh
    chmod u+x ./dyn/cidarea_${eid}.sh
    grass ${TMP_MAPSET} --exec ./dyn/cidarea_${eid}.sh
exit


