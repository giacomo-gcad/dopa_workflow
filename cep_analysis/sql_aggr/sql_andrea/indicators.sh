#!/bin/bash
### PLEASE CHECK THE CHANGEME LINES!

# EXECUTE AS ./execute.sh > logs/execute.log 2>&1

## CAN COMMENT WITH  if [ ]; then ## .... fi; ##

###------------------------------------------------------------------------------------------------------------------------------------------------#

# TIMER START
START_T1=$(date +%s)

###------------------------------------------------------------------------------------------------------------------------------------------------#

# PARAMETERS
source workflow_parameters.conf

# echo "DEFINED PARAMETERS ARE = "

# echo "--GENERAL---------------"
# echo "V_COUNTRY IS = " ${V_COUNTRY}
# echo "V_ECOREGION IS = "  ${V_ECOREGION}
# echo "V_WDPA IS = "  ${V_WDPA}
# echo  "V_CEP IS = " ${V_CEP}
# echo  "V_RCEP_IN IS = " ${V_RCEP_IN}
# echo  "V_RCEP_OUT IS = " ${V_RCEP_OUT}
# echo  "V_R_NON_CEP IS = " ${V_R_NON_CEP}
# echo  "V_TARGET IS = " ${V_TARGET}

# ## CAN COMMENT WITH
# #if [ ]; then
# #fi; ##

# ###--GENERAL---------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# psql ${dbpar2} -f ./${SQL}/001_results_cep_out.sql -v v_rcep_out=${V_RCEP_OUT}
# wait
# fi; ## DONE

# if [ ]; then # DONE
# ###------------------------------------------------------------------------------------------------------------------------------------------------
# psql ${dbpar2} -f ./${SQL}/010_cep_atts_indexes.sql -v v_country=${V_COUNTRY} -v v_ecoregion=${V_ECOREGION} -v v_wdpa=${V_WDPA} -v v_cep=${V_CEP} -v v_buffers=${V_BUFFERS} -v v_rcep_in=${V_RCEP_IN}
# wait
# ###------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--100-200 INFORMATION-CONSERVATION
# ###----201 CONSERVATION COVERAGE ---------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# psql ${dbpar2} -f ./${SQL}/100_200_cep_information_conservation_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_conservation_coverage # country_conservation_coverage_ecoregions_stats # ecoregion_conservation_coverages # wdpa_conservation_coverages
# fi; ## # DONE

# ###-----201 CONSERVATION MTA -------------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# psql ${dbpar2} -f ./${SQL}/201_cep_conservation_mta.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT} -v v_target=${V_TARGET} 
# wait ## percentage of achievement
# fi; ## # DONE

# ###-----202 CONSERVATION PA_LISTS -------------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# psql ${dbpar2} -f ./${SQL}/202_cep_conservation_pa_lists.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ##OUTPUTS: country_pa_list # ecoregion_pa_list #
# fi; ## # DONE

# ###--300-CARBON----------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- CARBON ---------------"
# ###----301 CARBON ABOVE GROUND -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_301 - CARBON ABOVE GROUND IS = " ${V_THEME_301}
# psql ${dbpar2} -f ./${SQL}/301_cep_carbon_above_ground_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_301} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_carbon_above_ground # ecoregion_carbon_above_ground # wdpa_carbon_above_ground
# ###----302 CARBON BELOW GROUND -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_302 - CARBON BELOW GROUND IS = " ${V_THEME_302}
# psql ${dbpar2} -f ./${SQL}/302_cep_carbon_below_ground_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_302} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_carbon_below_ground # ecoregion_carbon_below_ground # wdpa_carbon_below_ground
# ###----303 CARBON SOIL -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_303 - CARBON SOIL ORGANIC IS = " ${V_THEME_303}
# psql ${dbpar2} -f ./${SQL}/303_cep_carbon_soil_organic_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_303} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_carbon_soil_organic # ecoregion_carbon_soil_organic # wdpa_carbon_soil_organic
# ###----305 CARBON DEAD WOOD -------------------------------------------------------------------------------------------------------------------------------------------------
# echo "V_THEME_305 - CARBON DEAD WOOD IS = " ${V_THEME_305}
# psql ${dbpar2} -f ./${SQL}/305_cep_carbon_deadwood_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_305} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_carbon_deadwood # ecoregion_carbon_deadwood # wdpa_carbon_deadwood
# ###----306 CARBON LITTER -------------------------------------------------------------------------------------------------------------------------------------------------
# echo "V_THEME_306 - CARBON LITTER IS = " ${V_THEME_306}
# psql ${dbpar2} -f ./${SQL}/306_cep_carbon_litter_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_306} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_carbon_litter # ecoregion_carbon_litter # wdpa_carbon_litter
# ###----304 CARBON TOTAL -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_304 - CARBON TOTAL IS = " ${V_THEME_304}
# psql ${dbpar2} -f ./${SQL}/304_cep_carbon_total_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_304} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # country_carbon_total # ecoregion_carbon_total # wdpa_carbon_total
# fi; ## # DONE

# ###--500 ELEVATION PROFILE
# if [ ]; then # DONE
# echo "-- ELEVATION PROFILE ----"
# echo  "V_THEME_501 - ELEVATION PROFILE IS = " ${V_THEME_501a}
# echo  "V_NAME_501 - ELEVATION PROFILE FIELD NAME IS = " ${V_NAME_501a}
# ###----501 ELEVATION PROFILE -------------------------------------------------------------------------------------------------------------------------------------------------
# psql ${dbpar2} -f ./${SQL}/cep_r_univar_continuous_quantity.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_501a} -v v_theme=${V_THEME_501a} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_elevation_profile_intermediate # ecoregion_elevation_profile_intermediate # wdpa_elevation_profile_intermediate
# psql ${dbpar2} -f ./${SQL}/501_elevation_profile.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_elevation_profile # ecoregion_elevation_profile # wdpa_elevation_profile
# ###------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--600 GLOBAL FOREST COVER
# if [ ]; then # DONE
# echo "-- GLOBAL FOREST --------"
# ###----601 GLOBAL FOREST COVER GAIN -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_601 - GLOBAL FOREST GAIN IS = " ${V_THEME_601}
# psql ${dbpar2} -f ./${SQL}/601_cep_global_forest_cover_gain_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_601} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_global_forest_cover_gain # ecoregion_global_forest_cover_gain # wdpa_global_forest_cover_gain
# ###----602 GLOBAL FOREST COVER LOSS -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_602 - GLOBAL FOREST LOSS IS = " ${V_THEME_602}
# psql ${dbpar2} -f ./${SQL}/602_cep_global_forest_cover_loss_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_602} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_global_forest_cover_loss # ecoregion_global_forest_cover_loss # wdpa_global_forest_cover_loss
# ###----603 GLOBAL FOREST COVER TREECOVER -------------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_603 - GLOBAL FOREST TREECOVER IS = " ${V_THEME_603}
# psql ${dbpar2} -f ./${SQL}/603_cep_global_forest_cover_treecover_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_603} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_global_forest_cover_treecover # ecoregion_global_forest_cover_teecover # wdpa_global_forest_cover_treecover
# ###------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--800 LAND COVER
# if [ ]; then # DONE
# echo "-- LANDCOVER ------------"
# ###----801 LAND COVER - COPERNICUS----------------------------------------------------------------------------------------------------------------------------
# echo "-- LC COPERNICUS --------"
# echo  "V_THEME_801 - lc_copernicurs - LANDCOVER-COPERNICUS THEME IS = " ${V_THEME_801}
# echo  "V_NAME_801 - lc_copernicus - LANDCOVER-COPERNICUS NAME IS = " ${V_NAME_801}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_801}  -v v_theme=${V_THEME_801} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_copernicus # ecoregion_intemediate_lc_copernicus # wdpa_intemediate_lc_copernicus
# psql ${dbpar2} -f ./${SQL}/801_cep_lc_copernicus_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_lc_copernicus # ecoregion_lc_copernicus # wdpa_lc_copernicus
# ###----805 LAND COVER - ESA ---------------------------------------------------------------------------------------------------------------------
# echo "-- LC ESA ---------------"
# echo  "V_THEME_805a - lc_esa - LANDCOVER-esa THEME a IS = " ${V_THEME_805a}
# echo  "V_NAME_805a - lc_esa - LANDCOVER-esa NAME a IS = " ${V_NAME_805a}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_805a}  -v v_theme=${V_THEME_805a} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_esa_1995 # ecoregion_intemediate_lc_esa_1995 # wdpa_intemediate_lc_1995
# echo  "V_THEME_805b - lc_esa - LANDCOVER-esa THEME b IS = " ${V_THEME_805b}
# echo  "V_NAME_805b - lc_esa - LANDCOVER-esa NAME b IS = " ${V_NAME_805b}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_805b}  -v v_theme=${V_THEME_805b} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_esa_2000 # ecoregion_intemediate_lc_esa_2000 # wdpa_intemediate_lc_2000
# echo  "V_THEME_805c - lc_esa - LANDCOVER-esa THEME c IS = " ${V_THEME_805c}
# echo  "V_NAME_805c - lc_esa - LANDCOVER-esa NAME c IS = " ${V_NAME_805c}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_805c}  -v v_theme=${V_THEME_805c} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_esa_2005 # ecoregion_intemediate_lc_esa_2005 # wdpa_intemediate_lc_2005
# echo  "V_THEME_805d - lc_esa - LANDCOVER-esa THEME d IS = " ${V_THEME_805d}
# echo  "V_NAME_805d - lc_esa - LANDCOVER-esa NAME d IS = " ${V_NAME_805d}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_805d}  -v v_theme=${V_THEME_805d} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_esa_2010 # ecoregion_intemediate_lc_esa_2010 # wdpa_intemediate_lc_2010
# echo  "V_THEME_805e - lc_esa - LANDCOVER-esa THEME d IS = " ${V_THEME_805e}
# echo  "V_NAME_805e - lc_esa - LANDCOVER-esa NAME d IS = " ${V_NAME_805e}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_805e}  -v v_theme=${V_THEME_805e} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_esa_2015 # ecoregion_intemediate_lc_esa_2015 # wdpa_intemediate_lc_2015
# echo  "V_THEME_805f - lc_esa - LANDCOVER-esa THEME d IS = " ${V_THEME_805f}
# echo  "V_NAME_805f - lc_esa - LANDCOVER-esa NAME d IS = " ${V_NAME_805f}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_805f}  -v v_theme=${V_THEME_805f} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lc_esa_2020 # ecoregion_intemediate_lc_esa_2020 # wdpa_intemediate_lc_2020
# psql ${dbpar2} -f ./${SQL}/805_cep_lc_esa_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # wdpa_lc_esa
# ##----806 LAND COVER CHANGE - ESA----------------------------------------------------------------------------------------------------
# echo "-- LCC ESA ---------------"
# echo  "V_NAME_806a - lcc_esa - LANDCOVER-esa NAME e IS = " ${V_NAME_806a}
# echo  "V_THEME_806a - lcc_esa - LANDCOVER CHANGE-esa THEME e IS = " ${V_THEME_806a}
# echo  "V_NAME_806a - lcc_esa - LANDCOVER CHANGE-esa NAME e IS = " ${V_NAME_806a}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_806a}  -v v_theme=${V_THEME_806a} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lcc_esa # ecoregion_intemediate_lcc_esa # wdpa_intemediate_lcc_esa
# psql ${dbpar2} -f ./${SQL}/806_cep_lcc_esa_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_806a}  -v v_theme=${V_THEME_806a} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_lcc_esa # ecoregion_lcc_esa # wdpa_lcc_esa
# ##------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--900 - LPD - LAND DEGRADATION
# if [ ]; then # DONE
# echo "-- LAND DEGRADATION -----"
# echo  "V_THEME_901 - LPD - LAND DEGRADATION THEME IS = " ${V_THEME_901}
# echo  "V_NAME_901 - LPD - LAND DEGRADATION NAME IS = " ${V_NAME_901}
# ###----901-lpd-------------------------------------------------------------------------------------------------------------------
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN}  -v v_name=${V_NAME_901}  -v v_theme=${V_THEME_901} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_lpd # ecoregion_intemediate_lpd # wdpa_intemediate_lpd
# psql ${dbpar2} -f ./${SQL}/901_cep_lpd_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_lpd # ecoregion_lpd # wdpa_lpd
# ###------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--1000 - MSPA - LAND FRAGMENTATION
# if [ ]; then # DONE
# echo "-- LAND FRAGMENTATION ------------"
# echo "-- LAND FRAGMENTATION MSPA ---------------"

# ###----1001 LC FRAGMENTATION MSPA ---------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_1001a - mspa_lc - LAND FRAGMENTATION-esa THEME a IS = " ${V_THEME_1001a}
# echo  "V_NAME_1001a - mspa_lc - LAND FRAGMENTATION-esa NAME a IS = " ${V_NAME_1001a}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1001a}  -v v_theme=${V_THEME_1001a} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_mspa_1995 # ecoregion_intemediate_mspa_1995 # wdpa_intermediate_mspa_1995

# echo  "V_THEME_1001b - mspa_lc - LAND FRAGMENTATION-esa THEME b IS = " ${V_THEME_1001b}
# echo  "V_NAME_1001b - mspa_lc - LAND FRAGMENTATION-esa NAME b IS = " ${V_NAME_1001b}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1001b}  -v v_theme=${V_THEME_1001b} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_mspa_2000 # ecoregion_intemediate_mspa_2000 # wdpa_intermediate_mspa_2000

# echo  "V_THEME_1001c - mspa_lc - LAND FRAGMENTATION-esa THEME c IS = " ${V_THEME_1001c}
# echo  "V_NAME_1001c - mspa_lc - LAND FRAGMENTATION-esa NAME c IS = " ${V_NAME_1001c}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1001c}  -v v_theme=${V_THEME_1001c} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_mspa_2005 # ecoregion_intemediate_mspa_2005 # wdpa_intermediate_mspa_2005

# echo  "V_THEME_1001d - mspa_lc - LAND FRAGMENTATION-esa THEME d IS = " ${V_THEME_1001d}
# echo  "V_NAME_1001d - mspa_lc - LAND FRAGMENTATION-esa NAME d IS = " ${V_NAME_1001d}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1001d}  -v v_theme=${V_THEME_1001d} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_mspa_2010 # ecoregion_intemediate_mspa_2010 # wdpa_intermediate_mspa_2010

# echo  "V_THEME_1001e - mspa_lc - LAND FRAGMENTATION-esa THEME d IS = " ${V_THEME_1001e}
# echo  "V_NAME_1001e - mspa_lc - LAND FRAGMENTATION-esa NAME d IS = " ${V_NAME_1001e}
# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1001e}  -v v_theme=${V_THEME_1001e} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_mspa_2015 # ecoregion_intemediate_mspa_2015 # wdpa_intermediate_mspa_2015

# psql ${dbpar2} -f ./${SQL}/1001_cep_mspa_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_mspa # ecoregion_mspa # wdpa_mspa
# ###------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--1100  PRESSURES PA ----------------------------------------------------------------------------------------------------------------------------------------------
# ###----1101 - PRESSURE_AGRICULTURE_PA-------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- PRESSURES PA------------"
# echo "-- PRESSURE AGRICULTURE PA -----"
# #  THIS ONE POINTS TO outputs from 801 cep_lc_copernicus (intermediate)
# psql ${dbpar2} -f ./${SQL}/1101_cep_pressure_agriculture_pa.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_pressure_agriculture_pa
# fi; ## # DONE

# if [ ]; then # DONE
# ###----1102 - PRESSURE_BUILTUP PA-------------------------------------------------------------------------------------------------------------------------------------------
# echo  "V_THEME_1102 - PRESSURE_BUILTUP PA = " ${V_THEME_1102}
# psql ${dbpar2} -f ./${SQL}/1102_cep_pressure_builtup_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1102} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # country_carbon_total # ecoregion_carbon_total # wdpa_carbon_total
# fi; ## # DONE

# if [ ]; then # TODO
# echo "-- PRESSURE BUILTUP PA -----"
# echo  "V_THEME_1102 - p_builtup - PRESSURE BUILTUP THEME IS = " ${V_THEME_1102}
# echo  "V_NAME_1102 - p_builtup - PRESSURE BUILTUP NAME IS = " ${V_NAME_1102}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN}  -v v_name=${V_NAME_1102}  -v v_theme=${V_THEME_1102} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_p_builtup # ecoregion_intemediate_p_builtup # wdpa_intemediate_p_builtup

# psql ${dbpar2} -f ./${SQL}/1102_cep_pressure_builtup_pa.sql  -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_pressure_builtup_pa
# fi; ## # TODO

# ###----1103 - PRESSURE_ROADS PA-------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- PRESSURE ROAD PA-----"
# echo  "V_THEME_1103 - p_roads - PRESSURE BUILTUP THEME IS = " ${V_THEME_1103}
# echo  "V_NAME_1103 - p_roads - PRESSURE BUILTUP NAME IS = " ${V_NAME_1103}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN}  -v v_name=${V_NAME_1103}  -v v_theme=${V_THEME_1103} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_p_roads # ecoregion_intemediate_p_roads # wdpa_intemediate_p_roads

# psql ${dbpar2} -f ./${SQL}/1103_cep_pressure_roads_pa.sql  -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_pressure_roads_pa
# fi; ## # DONE

###----1105- PRESSURE POPULATION PA-------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
echo "-- PRESSURE POPULATION PA--"

echo  "V_THEME_1105a - PRESSURE POPULATION FIRST EPOCH THEME IS = " ${V_THEME_1105a}
echo  "V_NAME_1105a - PRESSURE POPULATION FIRST EPOCH NAME IS = " ${V_NAME_1105a}
psql ${dbpar2} -f ./${SQL}/cep_r_univar_continuous_quantity.sql -v v_rcep_in=${V_RCEP_IN}  -v v_name=${V_NAME_1105a}  -v v_theme=${V_THEME_1105a} -v v_rcep_out=${V_RCEP_OUT}
wait ## OUTPUTS: country_pressure_population_first_epoch # ecoregion_pressure_population_first_epoch # wdpa_pressure_population_first_epoch

echo  "V_THEME_1105b - PRESSURE POPULATION LAST EPOCH THEME IS = " ${V_THEME_1105b}
echo  "V_NAME_1105b - PRESSURE POPULATION LAST EPOCH NAME IS = " ${V_NAME_1105b}
psql ${dbpar2} -f ./${SQL}/cep_r_univar_continuous_quantity.sql -v v_rcep_in=${V_RCEP_IN}  -v v_name=${V_NAME_1105b}  -v v_theme=${V_THEME_1105b} -v v_rcep_out=${V_RCEP_OUT}
wait ## OUTPUTS: country_pressure_population_last_epoch # ecoregion_pressure_population_last_epoch # wdpa_pressure_population_last_epoch

echo  "V_THEME_1105 - PRESSURE POPULATION THEME IS = " ${V_THEME_1105}
psql ${dbpar2} -f ./${SQL}/1105_cep_pressure_population_alt_version.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1105} -v v_rcep_out=${V_RCEP_OUT}
wait ## OUTPUTS: # wdpa_pressure_population_pa

# ###------------------------------------------------------------------------------------------------------------------------------------------------
# fi; ## # DONE

# ###--1110  PRESSURES BU ----------------------------------------------------------------------------------------------------------------------------------------------
# echo "-- PRESSURES BU------------"

# ###----1111 - PRESSURE_AGRICULTURE_BU-------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- PRESSURE AGRICULTURE BU -----"
# echo  "V_THEME_1111 - p_builtup - PRESSURE AGRICULTURE THEME IS = " ${V_THEME_1111}
# echo  "V_NAME_1111 - p_builtup - PRESSURE AGRICULTURE NAME IS = " ${V_NAME_1111}
# psql ${dbpar2} -f ./${SQL}/pabu_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1111}  -v v_theme=${V_THEME_1111} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # pabu_intemediate_p_agriculture_bu
# psql ${dbpar2} -f ./${SQL}/1111_pabu_pressure_agriculture_bu.sql -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_pressure_agriculture_bu
# fi; ## # DONE

# ###----1112 - PRESSURE_BUILTUP BU-------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # TODO
# echo "-- PRESSURE BUILTUP BU -----"
# echo  "V_THEME_1112 - p_builtup - PRESSURE BUILTUP THEME IS = " ${V_THEME_1112}
# echo  "V_NAME_1112 - p_builtup - PRESSURE BUILTUP NAME IS = " ${V_NAME_1112}
# psql ${dbpar2} -f ./${SQL}/pabu_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1112} -v v_theme=${V_THEME_1112} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # pabu_intemediate_p_builtup_bu
# psql ${dbpar2} -f ./${SQL}/1112_pabu_pressure_builtup_bu.sql  -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_pressure_builtup_bu
# fi; ## # TODO

# ###----1113 - PRESSURE_ROADS BU-------------------------------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- PRESSURE ROAD BU-----"
# echo  "V_THEME_1113 - p_roads - PRESSURE BUILTUP THEME IS = " ${V_THEME_1113}
# echo  "V_NAME_1113 - p_roads - PRESSURE BUILTUP NAME IS = " ${V_NAME_1113}
# psql ${dbpar2} -f ./${SQL}/pabu_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN}  -v v_name=${V_NAME_1113}  -v v_theme=${V_THEME_1113} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: pabu_intemediate_p_roads_bu
# psql ${dbpar2} -f ./${SQL}/1113_pabu_pressure_roads_bu.sql  -v v_rcep_in=${V_RCEP_IN} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_pressure_roads_bu
# fi; ## # DONE

# ###----1115- PRESSURE POPULATION BU-------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- PRESSURE POPULATION BU--"
# echo  "V_THEME_1115a - PRESSURE POPULATION FIRST EPOCH THEME IS = " ${V_THEME_1115a}
# echo  "V_NAME_1115a - PRESSURE POPULATION FIRST EPOCH NAME IS = " ${V_NAME_1115a}
# psql ${dbpar2} -f ./${SQL}/pabu_r_univar_continuous_quantity.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1115a} -v v_theme=${V_THEME_1115a} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # pabu_pressure_population_first_epoch_bu

# echo  "V_THEME_1115b - PRESSURE POPULATION LAST EPOCH THEME IS = " ${V_THEME_1115b}
# echo  "V_NAME_1115b - PRESSURE POPULATION LAST EPOCH NAME IS = " ${V_NAME_1115b}
# psql ${dbpar2} -f ./${SQL}/pabu_r_univar_continuous_quantity.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1115b} -v v_theme=${V_THEME_1115b} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # pabu_pressure_population_last_epoch_bu

# echo  "V_THEME_1115 - PRESSURE POPULATION THEME IS = " ${V_THEME_1115}
# psql ${dbpar2} -f ./${SQL}/1115_pabu_pressure_population.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1115} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: # wdpa_pressure_population_bu
# fi; ## # DONE

# ###----1300 - WATER SURFACE-------------------------------------------------------------------------------------------------------------------
# if [ ]; then # DONE
# echo "-- WATER SURFACE --------"
# echo  "V_THEME_1300 - WATER SURFACE IS = " ${V_THEME_1300}
# ###----1300 - WATER SURFACE-------------------------------------------------------------------------------------------------------------------
# psql ${dbpar2} -f ./${SQL}/1300_cep_water_surface_inland_aggregations.sql -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1300} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_water_surface_inland # ecoregion_water_surface_inland # wdpa_water_surface_inland
# fi; ## # DONE

# ###--1200 SPECIES
# if [ ]; then # DONE
# ###------------------------------------------------------------------------------------------------------------------------------------------------
# echo "-- SPECIES ------------"
# ###----1201 SPECIES - CORALS----------------------------------------------------------------------------------------------------------------------------
# echo "-- CORALS --------"
# echo "V_TOPIC_1201 - CORALS IS ="${V_TOPIC_1201}
# echo  "V_THEME_1201 - species_corals - SPECIES CORALS THEME IS = " ${V_THEME_1201}
# echo  "V_NAME_1201 - species_corals - SPECIES CORALS NAME IS = " ${V_NAME_1201}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1201}  -v v_theme=${V_THEME_1201} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_species_corals # ecoregion_intemediate_species_corals # wdpa_intemediate_species_corals
# psql ${dbpar2} -f ./${SQL}/1200_cep_species_list.sql -v v_topic=${V_TOPIC_1201} -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1201} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_species_corals # ecoregion_species_corals # wdpa_intemediate_corals

# ###----1202 SPECIES - AMPHIBIANS----------------------------------------------------------------------------------------------------------------------------
# echo "-- AMPHIBIANS --------"
# echo "V_TOPIC_1202 - AMPHIBIANS IS ="${V_TOPIC_1202}
# echo  "V_THEME_1202 - species_amphibians - SPECIES AMPHIBIANS THEME IS = " ${V_THEME_1202}
# echo  "V_NAME_1202 - species_amphibians - SPECIES AMPHIBIANS NAME IS = " ${V_NAME_1202}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1202}  -v v_theme=${V_THEME_1202} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_species_amphibians # ecoregion_intemediate_species_amphibians # wdpa_intemediate_species_amphibians
# psql ${dbpar2} -f ./${SQL}/1200_cep_species_list.sql -v v_topic=${V_TOPIC_1202} -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1202} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_species_amphibians # ecoregion_species_amphibians # wdpa_species_amphibians

# ###----1203 SPECIES - SHARKS----------------------------------------------------------------------------------------------------------------------------
# echo "-- SHARKS_RAYS_CHIMAERAS --------"
# echo "V_TOPIC_1203 - SHARKS_RAYS_CHIMAERAS IS ="${V_TOPIC_1203}
# echo  "V_THEME_1203 - species_sharks_rays_chimaeras - SPECIES SHARKS_RAYS_CHIMAERAS THEME IS = " ${V_THEME_1203}
# echo  "V_NAME_1203 - species_sharks_rays_chimaeras - SPECIES SHARKS_RAYS_CHIMAERAS NAME IS = " ${V_NAME_1203}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1203}  -v v_theme=${V_THEME_1203} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_species_sharks_rays_chimaeras # ecoregion_intemediate_species_sharks # wdpa_intemediate_species_sharks_rays_chimaeras
# psql ${dbpar2} -f ./${SQL}/1200_cep_species_list.sql -v v_topic=${V_TOPIC_1203} -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1203} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_species_sharks_rays_chimaeras # ecoregion_species_sharks # wdpa_species_sharks_rays_chimaeras

# ###----1204 SPECIES - MAMMALS----------------------------------------------------------------------------------------------------------------------------
# echo "-- MAMMALS --------"
# echo "V_TOPIC_1204 - MAMMALS IS ="${V_TOPIC_1204}
# echo  "V_THEME_1204 - species_mammals - SPECIES MAMMALS THEME IS = " ${V_THEME_1204}
# echo  "V_NAME_1204 - species_mammals - SPECIES MAMMALS NAME IS = " ${V_NAME_1204}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1204}  -v v_theme=${V_THEME_1204} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_species_mammals # ecoregion_intemediate_species_mammals # wdpa_intemediate_species_mammals
# psql ${dbpar2} -f ./${SQL}/1200_cep_species_list.sql -v v_topic=${V_TOPIC_1204} -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1204} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_species_mammals # ecoregion_species_mammals # wdpa_species_mammals

# ###----1205 SPECIES - BIRDS----------------------------------------------------------------------------------------------------------------------------
# echo "-- BIRDS --------"
# echo "V_TOPIC_1205 - BIRDS IS ="${V_TOPIC_1205}
# echo  "V_THEME_1205 - species_birds - SPECIES BIRDS THEME IS = " ${V_THEME_1205}
# echo  "V_NAME_1205 - species_birds - SPECIES BIRDS NAME IS = " ${V_NAME_1205}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1205}  -v v_theme=${V_THEME_1205} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_species_birds # ecoregion_intemediate_species_birds # wdpa_intemediate_species_birds

# psql ${dbpar2} -f ./${SQL}/1200_cep_species_list.sql -v v_topic=${V_TOPIC_1205} -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1205} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_species_birds # ecoregion_species_birds # wdpa_species_birds
# #fi; ## # TODO

# ###----1207 SPECIES - REPTILES----------------------------------------------------------------------------------------------------------------------------
# echo "-- REPTILES --------"
# echo "V_TOPIC_1207 - REPTILES IS ="${V_TOPIC_1207}
# echo  "V_THEME_1207 - species_reptiles - SPECIES REPTILES THEME IS = " ${V_THEME_1207}
# echo  "V_NAME_1207 - species_reptiles - SPECIES REPTILES NAME IS = " ${V_NAME_1207}

# psql ${dbpar2} -f ./${SQL}/cep_r_stats_discrete_classes.sql -v v_rcep_in=${V_RCEP_IN} -v v_name=${V_NAME_1207}  -v v_theme=${V_THEME_1207} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_intemediate_species_reptiles # ecoregion_intemediate_species_reptiles # wdpa_intemediate_species_reptiles
# psql ${dbpar2} -f ./${SQL}/1200_cep_species_list.sql -v v_topic=${V_TOPIC_1207} -v v_rcep_in=${V_RCEP_IN} -v v_theme=${V_THEME_1207} -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: country_species_reptiles # ecoregion_species_reptiles # wdpa_species_reptiles

# ###----1206 SPECIES - WDPA - ALL SPECIES----------------------------------------------------------------------------------------------------------------------------
# echo "-- ALL SPECIES --------"
# echo  "v_rcep_out IS = " =${V_RCEP_OUT}

# psql ${dbpar2} -f ./${SQL}/1206_cep_wdpa_species_list.sql -v v_rcep_out=${V_RCEP_OUT}
# wait ## OUTPUTS: wdpa_species
# fi; ## # DONE

# ##THIS IS NOW IN NON_CEP
# ##psql ${dbpar2} -f ./${SQL}/1210_cep_species_iucn_list.sql -v v_r_non_cep=${V_R_NON_CEP}
# ##wait ## OUTPUTS: country_iucn_species


echo "analysis done"
# stop timer
END_T1=$(date +%s)
TOTAL_DIFF=$(($END_T1 - $START_T1))
echo "TOTAL SCRIPT TIME: $TOTAL_DIFF"
