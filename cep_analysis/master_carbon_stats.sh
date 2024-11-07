#!/bin/bash
##COMPUTE STATISTICS ON CEP AND 5+1 carbon stocks

echo "-----------------------------------------------------------------------------------"
echo "1 of 6 - Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

startdate=`date +%s`

echo "CEP mapset is: "${CEP_MAPSET}
echo "Results folder is: "${RESULTSPATH}
echo "Logpath is: "${LOGPATH}


./exec_cep_carbon_agc_stats.sh >${LOGPATH}/cep_agc_stats.log 2>&1 
wait
echo "1 of 6 - exec_cep_carbon_agc_stats.sh ended at $(date)"

./exec_cep_carbon_bgc_stats.sh >${LOGPATH}/cep_bgc_stats.log 2>&1 
wait
echo "2 of 6 - exec_cep_carbon_bgc_stats.sh ended at $(date)"

./exec_cep_carbon_dwc_stats.sh >${LOGPATH}/cep_dwc_stats.log 2>&1 
wait
echo "3 of 6 - exec_cep_carbon_dwc_stats.sh ended at $(date)"

./exec_cep_carbon_ltc_stats.sh >${LOGPATH}/cep_ltc_stats.log 2>&1 
wait
echo "4 of 6 - exec_cep_carbon_ltc_stats.sh ended at $(date)"

./exec_cep_carbon_gsoc_stats.sh >${LOGPATH}/cep_gsoc_stats.log 2>&1 
wait
echo "5 of 6 - exec_cep_carbon_gsoc_stats.sh ended at $(date)"

./exec_cep_carbon_tot_stats.sh >${LOGPATH}/cep_carbon_tot_stats.log 2>&1 
wait
echo "6 of 6 - exec_cep_carbon_tot_stats.sh ended at $(date)"

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and carbon stocks computed in "${runtime}" minutes using "${NCORES}" cores "
echo "---------------------------------------------------------------------------------------"
exit
