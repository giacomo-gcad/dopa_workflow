#!/bin/bash
##COMPUTE STATISTICS ON CEP AND 6 SPECIES

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

startdate=`date +%s`

echo "CEP mapset is: "${CEP_MAPSET}
echo "Results folder is: "${RESULTSPATH}
echo "Logpath is: "${LOGPATH}


./exec_cep_amphibians_stats.sh >${LOGPATH}/cep_amphibians_stats.log 2>&1 
wait
echo "--- exec_cep_amphibians_stats.sh ended at $(date)"

./exec_cep_birds_stats.sh >${LOGPATH}/cep_birds_stats.log 2>&1 
wait
echo "--- exec_cep_birds_stats.sh ended at $(date)"

./exec_cep_corals_stats.sh >${LOGPATH}/cep_corals_stats.log 2>&1 
wait
echo "--- exec_cep_corals_stats.sh ended at $(date)"

./exec_cep_mammals_stats.sh >${LOGPATH}/cep_mammals_stats.log 2>&1 
wait
echo "--- exec_cep_mammals_stats.sh ended at $(date)"

./exec_cep_reptiles_stats.sh >${LOGPATH}/cep_reptiles_stats.log 2>&1 
wait
echo "--- exec_cep_reptiles_stats.sh ended at $(date)"

./exec_cep_sharks_stats.sh >${LOGPATH}/cep_sharks_stats.log 2>&1 
wait
echo "--- exec_cep_sharks_stats.sh ended at $(date)"

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and species computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
