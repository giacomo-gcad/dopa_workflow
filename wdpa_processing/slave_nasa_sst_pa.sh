#!/bin/bash
# set variables

TEMPORARY_MAPSET_PATH=$1
RESULTSPATH=$2
TILESIZE=$3
PA_LIST_FILE=$4
PA_MAPSET=$5
TIL=$6

## ITERATE PA VECTORS
for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
do
	for MONTH in $(eval echo {01..12})
	do
		echo "#!/bin/bash
		## SET REGION AND MASK
		g.region --quiet vector=${PA}@${PA_MAPSET} align=sst_average_${MONTH}@NASA_SST
		r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
		## ANALYZE SST
		echo \"${PA}|\$(r.univar --q -t map=sst_average_${MONTH}@NASA_SST |tail -1)\" >>${RESULTSPATH}/pa_nasa_sst_avg_${MONTH}_tile_${TIL}.csv
		echo \"${PA}|\$(r.univar --q -t map=sst_maximum_${MONTH}@NASA_SST |tail -1)\" >>${RESULTSPATH}/pa_nasa_sst_max_${MONTH}_tile_${TIL}.csv
		echo \"${PA}|\$(r.univar --q -t map=sst_minimum_${MONTH}@NASA_SST |tail -1)\" >>${RESULTSPATH}/pa_nasa_sst_min_${MONTH}_tile_${TIL}.csv 
		wait
		r.mask -r
		"> ./dyn/process_sst_${MONTH}_${PA}.sh
		chmod u+x ./dyn/process_sst_${MONTH}_${PA}.sh
		grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_sst_${MONTH}_${PA}.sh
	done
done
exit
