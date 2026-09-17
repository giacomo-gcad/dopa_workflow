 -----------------------------------
-- SETUP THE RIGHT INPUT SCHEMA ---
-----------------------------------
/*
DROP SCHEMA IF EXISTS :v_rest CASCADE;CREATE SCHEMA :v_rest;
GRANT USAGE ON SCHEMA :v_rest TO h05ibexro;

-----------------------------------
-- CREATE BASE TABLES ---
-----------------------------------
-- PA_ATTS ------------------------
DROP TABLE IF EXISTS :v_rest.atts_country CASCADE;CREATE TABLE :v_rest.att_country AS
SELECT * FROM :v_rcep_in.atts_country_last;
GRANT SELECT ON :v_rest.att_country TO h05ibexro;

DROP TABLE IF EXISTS :v_rest.att_ecoregion CASCADE;CREATE TABLE :v_rest.att_ecoregion AS
SELECT * FROM :v_rcep_in.atts_ecoregion_last;
GRANT SELECT ON :v_rest.att_ecoregion TO h05ibexro;

DROP TABLE IF EXISTS :v_rest.att_pa CASCADE;CREATE TABLE :v_rest.att_pa AS
SELECT * FROM :v_rcep_in.atts_pa_last;
GRANT SELECT ON :v_rest.att_pa TO h05ibexro;

-- REGION ------------------------
DROP TABLE IF EXISTS :v_rest.dopa_regions CASCADE;CREATE TABLE  :v_rest.dopa_regions AS
SELECT * FROM administrative_units.dopa_regions;
GRANT SELECT ON :v_rest.dopa_regions TO h05ibexro;

-- THEMES ------------------------
DROP TABLE IF EXISTS :v_rest.class_mspa CASCADE; CREATE TABLE  :v_rest.class_mspa AS
SELECT * FROM themes.class_mspa;
GRANT SELECT ON :v_rest.class_mspa TO h05ibexro;

DROP TABLE IF EXISTS :v_rest.class_lpd CASCADE; CREATE TABLE  :v_rest.class_lpd AS
SELECT * FROM themes.class_lpd;
GRANT SELECT ON :v_rest.class_lpd TO h05ibexro;

DROP TABLE IF EXISTS :v_rest.class_lc_copernicus CASCADE; CREATE TABLE  :v_rest.class_lc_copernicus AS
SELECT * FROM themes.class_lc_copernicus;
GRANT SELECT ON :v_rest.class_lc_copernicus TO h05ibexro;

DROP TABLE IF EXISTS :v_rest.class_lc_esa CASCADE; CREATE TABLE  :v_rest.class_lc_esa AS
SELECT * FROM themes.class_lc_esa;
GRANT SELECT ON :v_rest.class_lc_esa TO h05ibexro; 

-- COUNTRY ------------------------
DROP TABLE IF EXISTS :v_rest.dopa_country_all_inds CASCADE;
CREATE TABLE :v_rest.dopa_country_all_inds AS
SELECT *
FROM :v_rcep_out.country_conservation_coverage
LEFT JOIN :v_r_non_cep.country_conservation_connectivity USING(country_id)
LEFT JOIN :v_r_non_cep.country_conservation_kba USING(country_id)
LEFT JOIN :v_rcep_out.country_conservation_mta USING(country_id)
LEFT JOIN :v_rcep_out.country_conservation_pa_list USING(country_id)
LEFT JOIN :v_rcep_out.country_carbon_above_ground USING(country_id)
LEFT JOIN :v_rcep_out.country_carbon_below_ground USING(country_id)
LEFT JOIN :v_rcep_out.country_carbon_soil_organic USING(country_id)
LEFT JOIN :v_rcep_out.country_carbon_dead_wood USING(country_id)
LEFT JOIN :v_rcep_out.country_carbon_litter USING(country_id)
LEFT JOIN :v_rcep_out.country_carbon_total USING(country_id)
LEFT JOIN :v_rcep_out.country_elevation_profile USING(country_id)
LEFT JOIN :v_rcep_out.country_global_forest_cover_gain USING(country_id)
LEFT JOIN :v_rcep_out.country_global_forest_cover_loss USING(country_id)
LEFT JOIN :v_rcep_out.country_global_forest_cover_treecover USING(country_id)
LEFT JOIN :v_rcep_out.country_water_surface_inland USING(country_id)
LEFT JOIN :v_rcep_out.country_lpd USING(country_id)
LEFT JOIN :v_rcep_out.country_mspa USING(country_id)
LEFT JOIN :v_rcep_out.country_lcc_esa USING(country_id)						
LEFT JOIN :v_rcep_out.country_lc_copernicus USING(country_id)

--LEFT JOIN :v_r_non_cep.country_iucn_species USING(country_id)
;
GRANT SELECT ON TABLE :v_rest.dopa_country_all_inds TO h05ibexro;


-- ECOREGION IN COUNTRY ------------------------
DROP TABLE IF EXISTS :v_rest.dopa_country_ecoregion_all_inds;
CREATE TABLE :v_rest.dopa_country_ecoregion_all_inds AS
SELECT * FROM :v_rcep_out.country_ecoregion_conservation_coverage;

GRANT SELECT ON TABLE :v_rest.dopa_country_ecoregion_all_inds TO h05ibexro;

-- ECOREGION ------------------------
DROP TABLE IF EXISTS :v_rest.dopa_ecoregion_all_inds CASCADE;
CREATE TABLE :v_rest.dopa_ecoregion_all_inds AS
SELECT * FROM :v_rcep_out.ecoregion_conservation_coverage
LEFT JOIN :v_r_non_cep.ecoregion_conservation_connectivity USING(eco_id)
LEFT JOIN :v_r_non_cep.ecoregion_conservation_kba USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_conservation_pa_list USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_carbon_above_ground USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_carbon_below_ground USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_carbon_soil_organic USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_carbon_dead_wood USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_carbon_litter USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_carbon_total USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_elevation_profile USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_global_forest_cover_gain USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_global_forest_cover_loss USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_global_forest_cover_treecover USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_water_surface_inland USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_lpd USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_mspa USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_lcc_esa USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_lc_copernicus USING(eco_id)
-- LEFT JOIN :v_rcep_out.ecoregion_pressure_livestock USING(eco_id)						-- DA FARE PER 202101 (results_202009_on_hold.r_univar_cep_glw3_*_with_qid)
;
GRANT SELECT ON TABLE :v_rest.dopa_ecoregion_all_inds TO h05ibexro;

-- PA ------------------------
DROP TABLE IF EXISTS :v_rest.dopa_wdpa_all_inds CASCADE;
CREATE TABLE :v_rest.dopa_wdpa_all_inds AS
SELECT * FROM :v_rcep_out.wdpa_conservation_coverage
LEFT JOIN :v_rcep_out.wdpa_r_tot USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_carbon_above_ground USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_carbon_below_ground USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_carbon_soil_organic USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_carbon_dead_wood USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_carbon_litter USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_carbon_total USING(wdpaid)
LEFT JOIN :v_r_non_cep.wdpa_climate USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_elevation_profile USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_global_forest_cover_gain USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_global_forest_cover_loss USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_global_forest_cover_treecover USING(wdpaid)
LEFT JOIN :v_r_non_cep.wdpa_habitat_diversity_profile_thdi USING(wdpaid)
LEFT JOIN :v_r_non_cep.wdpa_habitat_diversity_profile_mhdi USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_water_surface_inland USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_lpd USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_mspa USING(wdpaid)						-- DA FARE PER 202101 (results_202009.r_stats_cep_mspa_lc_****) 
LEFT JOIN :v_rcep_out.wdpa_pressure_agriculture_pa USING(wdpaid) 					
LEFT JOIN :v_rcep_out.wdpa_pressure_agriculture_bu USING(wdpaid)
--LEFT JOIN :v_rcep_out.wdpa_pressure_builtup_pa USING(wdpaid) 						
--LEFT JOIN :v_rcep_out.wdpa_pressure_builtup_bu USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_pressure_population_pa USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_pressure_population_bu USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_pressure_roads_pa USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_pressure_roads_bu USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_lc_esa USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_lcc_esa USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_lc_copernicus USING(wdpaid)
-- LEFT JOIN :v_rcep_out.wdpa_pressure_livestock_pa USING(wdpaid)					-- DA FARE PER 202101	
-- LEFT JOIN :v_r_non_cep.wdpa_pressure_livestock_bu USING(wdpaid)					-- DA FARE PER 202101	
;
GRANT SELECT ON TABLE :v_rest.dopa_wdpa_all_inds TO h05ibexro;
*/
 --SPECIES
DROP TABLE IF EXISTS
:v_rest.dopa_species,
:v_rest.class_species_category,
:v_rest.class_species_conservation_needed,
:v_rest.class_species_country,
:v_rest.class_species_habitat,
:v_rest.class_species_research_needed,
:v_rest.class_species_stress,
:v_rest.class_species_threat,
:v_rest.class_species_usetrade
CASCADE; 
 
SELECT * INTO :v_rest.dopa_species FROM species.dopa_species;
ALTER TABLE :v_rest.dopa_species ADD PRIMARY KEY(id_no);
CREATE INDEX ON :v_rest.dopa_species(class);
SELECT * INTO :v_rest.class_species_category FROM species.class_species_category;
SELECT * INTO :v_rest.class_species_conservation_needed FROM species.class_species_conservation_needed;
SELECT * INTO :v_rest.class_species_country FROM species.class_species_country;
SELECT * INTO :v_rest.class_species_habitat FROM species.class_species_habitat;
SELECT * INTO :v_rest.class_species_research_needed FROM species.class_species_research_needed;
SELECT * INTO :v_rest.class_species_stress FROM species.class_species_stress;
SELECT * INTO :v_rest.class_species_threat FROM species.class_species_threat;
SELECT * INTO :v_rest.class_species_usetrade FROM species.class_species_usetrade;
 
--COUNTRY
DROP TABLE IF EXISTS :v_rest.dopa_country_species_counts;
CREATE TABLE :v_rest.dopa_country_species_counts AS
SELECT *
FROM (SELECT country country_id,country_name,iso3,iso2,un_m49,status FROM :v_rcep_in.atts_country_last) a
LEFT JOIN :v_rcep_out.country_species_corals USING(country_id)
LEFT JOIN :v_rcep_out.country_species_sharks USING(country_id)
LEFT JOIN :v_rcep_out.country_species_amphibians USING(country_id)
LEFT JOIN :v_rcep_out.country_species_reptiles USING(country_id)
LEFT JOIN :v_rcep_out.country_species_birds USING(country_id)
LEFT JOIN :v_rcep_out.country_species_mammals USING(country_id)
ORDER BY country_id;
GRANT SELECT ON :v_rest.dopa_country_species_counts  TO h05ibexro;

--ecoregion
DROP TABLE IF EXISTS :v_rest.dopa_ecoregion_species_counts;
CREATE TABLE :v_rest.dopa_ecoregion_species_counts AS
SELECT *
FROM (SELECT ecoregion eco_id,ecoregion_name eco_name,second_level_code biome_id,second_level biome,third_level_code realm_id,third_level realm_name,source,is_marine FROM :v_rcep_in.atts_ecoregion_last) a
LEFT JOIN :v_rcep_out.ecoregion_species_corals USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_species_sharks USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_species_amphibians USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_species_reptiles USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_species_birds USING(eco_id)
LEFT JOIN :v_rcep_out.ecoregion_species_mammals USING(eco_id)
ORDER BY eco_id;
GRANT SELECT ON :v_rest.dopa_ecoregion_species_counts  TO h05ibexro;

--pa
DROP TABLE IF EXISTS :v_rest.dopa_wdpa_species_counts;
CREATE TABLE :v_rest.dopa_wdpa_species_counts AS
SELECT *
FROM (SELECT pa wdpaid,pa_name,desig_eng,iucn_cat,marine,is_n2k,iso3,type FROM :v_rcep_in.atts_pa_last) a
LEFT JOIN :v_rcep_out.wdpa_species_corals USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_species_sharks USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_species_amphibians USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_species_reptiles USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_species_birds USING(wdpaid)
LEFT JOIN :v_rcep_out.wdpa_species_mammals USING(wdpaid)
ORDER BY wdpaid;
GRANT SELECT ON :v_rest.dopa_wdpa_species_counts TO h05ibexro;

DROP TABLE IF EXISTS :v_rest.dopa_wdpa_species;
CREATE TABLE :v_rest.dopa_wdpa_species AS
SELECT * FROM :v_rcep_out.wdpa_species ORDER BY wdpaid,id_no;
GRANT SELECT ON :v_rest.dopa_wdpa_species TO h05ibexro; 

GRANT SELECT ON ALL TABLES IN SCHEMA :v_rest TO h05ibexro;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA :v_rest TO h05ibexro;