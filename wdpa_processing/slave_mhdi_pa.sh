#!/bin/bash
## PROCESS GEBCO ON MARINE PAs FOR MHDI

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET=$6
GEBCO=$7

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## SET REGION AND MASK
    g.region --quiet vector=${PA}@${PA_MAPSET} align=${GEBCO}
	r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    ## ANALYSE GEBCO
    echo \"${PA}|\$(r.univar -e -t map=${GEBCO} |tail -1)\" >>${RESULTSPATH}/pa_gebco_tile${TIL}.csv
    ## CLEAN PROCESSING ENVIRONMENT
    r.mask -r --q
    exit
    " > ./dyn/process_gebco_${PA}.sh
		wait
	[ ! -f ./dyn/process_gebco_${PA}.sh ] && echo "File ./dyn/process_gebco_${PA}.sh not found!"
    chmod u+x ./dyn/process_gebco_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_gebco_${PA}.sh

done
exit
