#!/bin/bash
## RUNS IN SEQUENCE A SERIES OF SCRIPTS FOR CEP ANALYSIS

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf

# echo "$(date): Now processing cid area by tile dataset"
# ./exec_cid_area_by_tile.sh >${LOGPATH}/cid_area_by_tile.log 2>&1
# wait

# echo "$(date): Now processing gebco 2020 dataset"
# ./exec_cep_gebco_stats.sh >${LOGPATH}/cep_gebco.log 2>&1
# wait

# echo "$(date): Now processing agc_2017 dataset"
# ./exec_cep_agc2017_100m_stats.sh >${LOGPATH}/cep_agc.log 2>&1
# wait

# echo "$(date): Now processing bgc_2017 dataset"
# ./exec_cep_bgc2017_100m_stats.sh >${LOGPATH}/cep_bgc.log 2>&1
# wait

# echo "$(date): Now processing gsoc dataset"
# ./exec_cep_gsoc_stats.sh >${LOGPATH}/cep_gsoc.log 2>&1
# wait

# echo "$(date): Now processing carbon 2020 dataset"
# ./exec_cep_carbon_tot_stats.sh >${LOGPATH}/cep_carbon_tot.log 2>&1
# wait

# echo "$(date): Now processing gsw 2020 dataset"
# ./exec_cep_gsw_transitions_stats.sh >${LOGPATH}/cep_gsw.log 2>&1
# wait

# echo "$(date): Now processing gfc lossyear dataset"
# ./exec_cep_gfc_lossyear_over30_stats.sh >${LOGPATH}/cep_gfc_lossyear.log 2>&1
# wait

# echo "$(date): Now processing gfc gain dataset"
# ./exec_cep_gfc_gain_over30_stats.sh >${LOGPATH}/cep_gfc_gain.log 2>&1
# wait

# echo "$(date): Now processing gfc treecover dataset"
# ./exec_cep_gfc_treecover_over30_stats.sh >${LOGPATH}/cep_gfc_treecover.log 2>&1
# wait

# echo "$(date): Now processing lpd dataset"
# ./exec_cep_lpd_stats.sh >${LOGPATH}/cep_lpd.log 2>&1
# wait

# echo "$(date): Now processing ESA-CCI Land Cover datasets (5 years)"
# ./exec_cep_esa_lc_stats.sh >${LOGPATH}/cep_esa_lc.log 2>&1
# wait

# echo "$(date): Now processing Land Fragmentation datasets (5 years)"
# ./exec_cep_mspa_stats.sh >${LOGPATH}/cep_mspa.log 2>&1
# wait

# echo "$(date): Now processing Land Cover Change using ESA-CCI daasets"
# ./exec_cep_esa_lc_change.sh >${LOGPATH}/cep_esa_lc_change.log 2>&1
# wait

# echo "$(date): Now processing lc copernicus dataset"
# ./exec_cep_copernicus_lc_stats.sh >${LOGPATH}/cep_copernicus.log 2>&1
# wait

# echo "$(date): Now processing builtup dataset"
# ./exec_cep_builtup_stats.sh >${LOGPATH}/cep_builtup.log 2>&1
# wait

# echo "$(date): Now processing GHS Population dataset"
# ./exec_cep_ghs_pop_stats.sh >${LOGPATH}/cep_ghs_pop.log 2>&1
# wait

echo "$(date): Now processing Amphibians dataset"
./exec_cep_amphibians_stats.sh >${LOGPATH}/cep_amphibians.log 2>&1
wait

echo "$(date): Now processing Birds dataset"
./exec_cep_birds_stats.sh >${LOGPATH}/cep_birds.log 2>&1
wait

echo "$(date): Now processing Corals dataset"
./exec_cep_corals_stats.sh >${LOGPATH}/cep_corals.log 2>&1
wait

echo "$(date): Now processing Mammals dataset"
./exec_cep_mammals_stats.sh >${LOGPATH}/cep_mammals.log 2>&1
wait

echo "$(date): Now processing Sharks and Rays dataset"
./exec_cep_sharks_stats.sh >${LOGPATH}/cep_sharks.log 2>&1
wait

enddate1=`date +%s`
runtime1=$(((enddate1-startdate) / 60))

echo "-----------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "-----------------------------------------------------------------------------------"
echo "Total time "${runtime1}" minutes"
echo "-----------------------------------------------------------------------------------"
exit