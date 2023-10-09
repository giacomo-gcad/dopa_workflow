#!/bin/bash
##COMPUTE STATISTICS ON CEP AND MANY THEMATIC LAYERS

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


./exec_cep_esa_lc_stats.sh >${LOGPATH}/cep_esa_lc.log 2>&1 
wait
echo "--- exec_cep_esa_lc_stats.sh ended at $(date)"

./exec_cep_esa_lc_change.sh >${LOGPATH}/cep_esa_lc_change.log 2>&1 
wait
echo "--- exec_cep_esa_lc_change.sh ended at $(date)"

./exec_cep_gfc_gain_over30_stats.sh >${LOGPATH}/cep_gfc_gain.log 2>&1 
wait
echo "--- exec_cep_gfc_gain_over30_stats.sh ended at $(date)"

./exec_cep_gfc_lossyear_over30_stats.sh >${LOGPATH}/cep_gfc_loss.log 2>&1 
wait
echo "--- exec_cep_gfc_lossyear_over30_stats.sh ended at $(date)"

./exec_cep_gfc_treecover_over30_stats.sh >${LOGPATH}/cep_gfc_treecover.log 2>&1 
wait
echo "--- exec_cep_gfc_treecover_over30_stats.sh ended at $(date)"

./exec_cep_groads_stats.sh >${LOGPATH}/cep_groads.log 2>&1 
wait
echo "--- exec_cep_groads_stats.sh ended at $(date)"

./exec_cep_gsw_transitions_stats.sh >${LOGPATH}/cep_gsw_transitions.log 2>&1 
wait
echo "--- exec_cep_gsw_transitions_stats.sh ended at $(date)"

./exec_cep_lpd_stats.sh >${LOGPATH}/cep_lpd.log 2>&1 
wait
echo "--- exec_cep_lpd_stats.sh ended at $(date)"

./exec_cep_mspa_stats.sh >${LOGPATH}/cep_mspa.log 2>&1 
wait
echo "--- exec_cep_mspa_stats.sh ended at $(date)"

./exec_cep_gebco_stats.sh >${LOGPATH}/cep_gebco.log 2>&1 
wait
echo "--- exec_cep_gebco_stats.sh ended at $(date)"

###############################################
###CHANGE WORKING DIR
cd /globes/processing_current/kba_processing
###############################################

./exec_kba_stats.sh  >logs/202302/cep_kba.log 2>&1 
wait
echo "--- exec_kba_stats.sh ended at $(date)"

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and may thematic layers computed in "${runtime}" minutes"
echo "---------------------------------------------------------------------------------------"
exit
