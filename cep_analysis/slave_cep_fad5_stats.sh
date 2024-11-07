#!/bin/bash
##COMPUTE STATISTICS ON CEP AND CONTINUOUS RASTER

eid=$1
TMP_MAPSET=$2
RESULTSPATH=$3
IN_RASTER=$4
OUTCSV=$5
CEP_MAPSET=$6
YEAR=$7

SERVICEDIR="/globes/processing_current/servicefiles"
starttime=`date +%s`

# # CEP TILES ARE ANALYZED AT IN_RASTER RESOLUTION
# ## commenting/uncommenting 'align=${IN_RASTER}' allows to perform the analysis, respectively, at cep or IN_RASTER resolution

# # CREATE TEMPORARY FOLDER TO STORE INTERMEDIATE RESULTS
SUBDIR=${RESULTSPATH}/tmp_${eid}
mkdir -p ${SUBDIR}

for obj in $(cat ${SERVICEDIR}/qid_index.csv |grep "eid_${eid}|")
do
	# eid=$(echo ${obj} | while IFS="|" read a b c d e f; do echo ${a}; done)
	qid=$(echo ${obj} | while IFS="|" read a b c d e f; do echo ${b}; done)
	ncoor=$(echo ${obj} | while IFS="|" read a b c d e f; do echo ${c}; done)
    scoor=$(echo ${obj} | while IFS="|" read a b c d e f; do echo ${d}; done)
	ecoor=$(echo ${obj} | while IFS="|" read a b c d e f; do echo ${e}; done)
	wcoor=$(echo ${obj} | while IFS="|" read a b c d e f; do echo ${f}; done)
	
	region_str="g.region --q n=${ncoor} s=${scoor} w=${wcoor} e=${ecoor} align=${IN_RASTER}"
	echo "#!/bin/bash
## SET REGION
${region_str}
## ANALYZE IN_RASTER WITH R.UNIVAR
r.univar --q -e -t map=${IN_RASTER} zones=cepmask_${YEAR}_${eid}@${CEP_MAPSET} output=${SUBDIR}/z_${OUTCSV}_${qid}.csv
exit
" > ./dyn/runivar_${eid}_${qid}.sh
	chmod u+x ./dyn/runivar_${eid}_${qid}.sh
	grass ${TMP_MAPSET} -f --exec ./dyn/runivar_${eid}_${qid}.sh
	wait
	
	# POSTPROCESS RESULTS
	# remove headers
	sed -i.bak '/zone|label|non_null_cells|null_cells|min|max|range|mean|mean_of_abs|stddev|variance|coeff_var|sum|sum_abs|first_quart|median|third_quart|perc_90/d' ${SUBDIR}/z_${OUTCSV}_${qid}.csv
	# replace '-nan' with 0
	sed -i 's/nan/0/g' ${SUBDIR}/z_${OUTCSV}_${qid}.csv
	# add eid and qid at the beginning of each line
	prefix=${eid}"|"${qid}"|"
	awk -v prefix="${prefix}" '{print prefix $0}'  ${SUBDIR}/z_${OUTCSV}_${qid}.csv > ${SUBDIR}/${OUTCSV}_${qid}_final.csv
done

wait

# aggregate results by eid
echo "now aggregating results by eid"
rm -f  ${RESULTSPATH}/${OUTCSV}.csv
cat ${SUBDIR}/${OUTCSV}_*_final.csv >> ${RESULTSPATH}/${OUTCSV}.csv

# clean results folder
echo "now removing intermediate files"

echo dyn/runivar_${eid}*.sh |xargs rm -f
rm -rf ${SUBDIR}

endtime=`date +%s`
proctime_eid=$((endtime-starttime))
echo "eid ${eid} processed in " ${proctime_eid} "seconds"

exit
