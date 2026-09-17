#!/bin/bash
##COMPUTE STATISTICS ON CEP AND MANY THEMATIC LAYERS

echo "-----------------------------------------------------------------------------------"
echo "--- Script $(basename "$0") started at $(date)"
echo "-----------------------------------------------------------------------------------"

startdate=`date +%s`

./exec_mhdi_pa.sh >logs/mhdi_pas.log 2>&1 
wait
echo "--- exec_mhdi_pa.sh ended at $(date)"

./exec_worldclim_pa.sh >logs/worldclim_pas.log 2>&1 
wait
echo "--- exec_worldclim_pa.sh ended at $(date)"

enddate=`date +%s`
runtime=$(((enddate-startdate) / 60))

echo "---------------------------------------------------------------------------------------"
echo "Script $(basename "$0") ended at $(date)"
echo "---------------------------------------------------------------------------------------"
echo "Stats on CEP and may thematic layers computed in "${runtime}" minutes"
echo "---------------------------------------------------------------------------------------"
exit
