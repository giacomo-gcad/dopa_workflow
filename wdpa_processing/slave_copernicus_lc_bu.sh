#!/bin/bash
##ANALYZE COPERNICUS LAND COVER

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
BU_LIST_FILE=$5
BU_MAPSET=$6

for BU in $(cat ${BU_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## SET REGION AND MASK
    g.region --quiet vector=${BU}@${BU_MAPSET} align=copernicus_lc_2019@CATRASTERS
    r.mask --overwrite --quiet vector=${BU}@${BU_MAPSET}
    ## ANALYZE LAND PRODUCTIVITY DYNAMICS
	r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_cop_lc_totsurface_tile${TIL}.csv
    r.stats --q -a -n -N --overwrite input=copernicus_lc_2019@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_cop_lc_tile${TIL}.csv
    ## UNSET REGION AND MASK
    r.mask -r --q
    g.region -d --quiet
    exit
    "  > ./dyn/process_cop_lc_${BU}.sh
    chmod u+x ./dyn/process_cop_lc_${BU}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_cop_lc_${BU}.sh

done
exit
