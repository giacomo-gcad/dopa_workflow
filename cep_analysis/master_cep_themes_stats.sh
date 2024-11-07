#!/bin/bash
## IMPORT CEP TILES IN GRASS DB AND COMPUTE STATISTICS ON CEP AND MANY THEMATIC LAYERS

echo "--------------------------------------------------------------------------------------------"
echo "Script $(basename "$0") started at $(date)"
echo "--------------------------------------------------------------------------------------------"

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

startdate=`date +%s`

echo "CEP mapset is:     "${CEP_MAPSET}
echo "Results folder is: "${RESULTSPATH}
echo "Results schema is: "${RESULTSCH}
echo "Logpath is:        "${LOGPATH}
echo "--------------------------------------------------------------------------------------------"

echo " "
#####################################################
############ IMPORT CEP TILES IN GRASS ##############

echo "Now importing CEP tiles in GRASS DB"
./exec_import_tiles.sh >${LOGPATH}/import_cep_tiles.log 2>&1 
wait
date1=`date +%s`
proc_time=$(((date1-startdate) / 60))
echo "1 of 17 - exec_import_tiles.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"


################################################
################## SPECIES #####################
echo "Now running master script for species..."
./cep_species_stats.sh >${LOGPATH}/cep_species.log 2>&1 
wait
date2=`date +%s`
proc_time=$(((date2-date1) / 60))
echo "2 of 17 - cep_species_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"
################################################

echo "Now running exec_cep_gsw_transitions_stats..."
./exec_cep_gsw_transitions_stats.sh >${LOGPATH}/cep_gsw_transitions.log 2>&1 
wait
date3=`date +%s`
proc_time=$(((date3-date2) / 60))
echo "3 of 17 - exec_cep_gsw_transitions_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_copernicus_lc_stats..."
./exec_cep_copernicus_lc_stats.sh >${LOGPATH}/cep_copernicus_lc.log 2>&1 
wait
date4=`date +%s`
proc_time=$(((date4-date3) / 60))
echo "4 of 17 - exec_cep_copernicus_lc_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_esa_lc_stats..."
./exec_cep_esa_lc_stats.sh >${LOGPATH}/cep_esa_lc.log 2>&1 
wait
date5=`date +%s`
proc_time=$(((date5-date4) / 60))
echo "5 of 17 - exec_cep_esa_lc_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_esa_lc_change..."
./exec_cep_esa_lc_change.sh >${LOGPATH}/cep_esa_lc_change.log 2>&1 
wait
date6=`date +%s`
proc_time=$(((date6-date5) / 60))
echo "6 of 17 - exec_cep_esa_lc_change.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

################################################
################## GFC #########################

echo "Now running exec_cep_gfc_gain_over30_stats..."
./exec_cep_gfc_gain_over30_stats.sh >${LOGPATH}/cep_gfc_gain.log 2>&1 
wait
date7=`date +%s`
proc_time=$(((date7-date6) / 60))
echo "7 of 17 - exec_cep_gfc_gain_over30_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_gfc_lossyear_over30_stats..."
./exec_cep_gfc_lossyear_over30_stats.sh >${LOGPATH}/cep_gfc_loss.log 2>&1 
wait
date8=`date +%s`
proc_time=$(((date8-date7) / 60))
echo "8 of 17 - exec_cep_gfc_lossyear_over30_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_gfc_treecover_over30_stats..."
./exec_cep_gfc_treecover_over30_stats.sh >${LOGPATH}/cep_gfc_treecover.log 2>&1 
wait
date9=`date +%s`
proc_time=$(((date9-date8) / 60))
echo "9 of 17 - exec_cep_gfc_treecover_over30_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"
################################################

echo "Now running exec_cep_groads_stats..."
./exec_cep_groads_stats.sh >${LOGPATH}/cep_groads.log 2>&1 
wait
date10=`date +%s`
proc_time=$(((date10-date9) / 60))
echo "10 of 17 - exec_cep_groads_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_lpd_stats..."
./exec_cep_lpd_stats.sh >${LOGPATH}/cep_lpd.log 2>&1 
wait
date11=`date +%s`
proc_time=$(((date11-date10) / 60))
echo "11 of 17 - exec_cep_lpd_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_mspa_stats..."
./exec_cep_mspa_stats.sh >${LOGPATH}/cep_mspa.log 2>&1 
wait
date12=`date +%s`
proc_time=$(((date12-date11) / 60))
echo "12 of 17 - exec_cep_mspa_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_gebco_stats..."
./exec_cep_gebco_stats.sh >${LOGPATH}/cep_gebco.log 2>&1 
wait
date13=`date +%s`
proc_time=$(((date13-date12) / 60))
echo "13 of 17 - exec_cep_gebco_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_builtup_r2023_stats..."
./exec_cep_builtup_r2023_stats.sh >${LOGPATH}/cep_builtup_r2023.log 2>&1 
wait
date14=`date +%s`
proc_time=$(((date14-date13) / 60))
echo "14 of 17 - exec_cep_builtup_r2023_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

echo "Now running exec_cep_ghs_pop_stats..."
/exec_cep_ghs_pop_stats.sh >${LOGPATH}/cep_ghs_pop.log 2>&1 
wait
date15=`date +%s`
proc_time=$(((date15-date14) / 60))
echo "15 of 17 - exec_cep_ghs_pop_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"

################################################
################ CARBON POOLS ##################
echo "Now running master script for carbon pools..."
./master_carbon_stats.sh >${LOGPATH}/master_carbon.log 2>&1 
wait
date16=`date +%s`
proc_time=$(((date16-date15) / 60))
echo "16 of 17 - master_carbon_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"
################################################

################################################
########## KEY BIODIVERSITY AREAS ##############
## CHANGE WORKING DIR
echo "Now running exec_kba_stats..."
cd /globes/processing_current/kba_processing
./exec_kba_stats.sh  >logs/202408/cep_kba.log 2>&1 
wait
date17=`date +%s`
proc_time=$(((date17-date16) / 60))
echo "17 of 17 - exec_kba_stats.sh ended at $(date). Proc. time: "${proc_time}" minutes"
echo "--------------------------------------------------------------------------------------------"
################################################

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo " "
echo "--------------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo " "
echo "Stats on CEP and many thematic layers computed in "${runtime}" minutes"
echo "--------------------------------------------------------------------------------------------"
exit
