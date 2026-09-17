---- COUNTRY
DROP FUNCTION IF EXISTS delli.get_dopa_country_all_inds(text, text);
DROP MATERIALIZED VIEW IF EXISTS delli.dopa_country_all_inds_template;

DROP TABLE IF EXISTS delli.dopa_country_all_inds;CREATE TABLE delli.dopa_country_all_inds AS 
WITH 
country_coverage AS (SELECT * FROM results_202601_cep_out.country_conservation_coverage)

SELECT 
a.country_id,a.country_name,a.iso3,a.iso2,a.status,
a.country_tot_v_sqkm,a.country_tot_sqkm,a.country_tot_prot_sqkm,a.country_prot_perc_country_tot,
a.country_land_sqkm,a.country_land_perc_country_tot,a.country_land_prot_sqkm,a.country_land_prot_perc_country_land,
a.country_marine_sqkm,a.country_marine_perc_country_tot,a.country_marine_prot_sqkm,a.country_marine_prot_perc_country_marine,
--PROTCONN
pr.protconn,
--KBA
p.kba_n_tot,p.kba_n_fully_prot,p.kba_n_partially_prot,p.kba_n_not_protected,p.kba_avg_prot_perc_tot,

-- ---------------------------------------------------------------------
--MTA
--mt.mta_perc_n_ecoregions_in_country, --MISSING, TO BE COMPUTED
NULL AS mta_perc_n_ecoregions_in_country,
-- ---------------------------------------------------------------------

-- PAs stats
pp.pa_list,pp.pa_count,

--carbon
b.agb_min_c_mg_total,b.agb_max_c_mg_total,b.agb_mean_c_mg_total,b.agb_tot_c_pg_total,b.agb_min_c_mg_prot,b.agb_max_c_mg_prot,b.agb_mean_c_mg_prot,b.agb_tot_c_pg_prot,b.agb_min_c_mg_unprot,b.agb_max_c_mg_unprot,b.agb_mean_c_mg_unprot,b.agb_tot_c_pg_unprot,
c.bgb_min_c_mg_total,c.bgb_max_c_mg_total,c.bgb_mean_c_mg_total,c.bgb_tot_c_pg_total,c.bgb_min_c_mg_prot,c.bgb_max_c_mg_prot,c.bgb_mean_c_mg_prot,c.bgb_tot_c_pg_prot,c.bgb_min_c_mg_unprot,c.bgb_max_c_mg_unprot,c.bgb_mean_c_mg_unprot,c.bgb_tot_c_pg_unprot,
d.dwc_min_c_mg_total,d.dwc_max_c_mg_total,d.dwc_mean_c_mg_total,d.dwc_tot_c_pg_total,d.dwc_min_c_mg_prot,d.dwc_max_c_mg_prot,d.dwc_mean_c_mg_prot,d.dwc_tot_c_pg_prot,d.dwc_min_c_mg_unprot,d.dwc_max_c_mg_unprot,d.dwc_mean_c_mg_unprot,d.dwc_tot_c_pg_unprot,
e.ltc_min_c_mg_total,e.ltc_max_c_mg_total,e.ltc_mean_c_mg_total,e.ltc_tot_c_pg_total,e.ltc_min_c_mg_prot,e.ltc_max_c_mg_prot,e.ltc_mean_c_mg_prot,e.ltc_tot_c_pg_prot,e.ltc_min_c_mg_unprot,e.ltc_max_c_mg_unprot,e.ltc_mean_c_mg_unprot,e.ltc_tot_c_pg_unprot,	
f.gsoc_min_c_mg_total,f.gsoc_max_c_mg_total,f.gsoc_mean_c_mg_total,f.gsoc_tot_c_pg_total,f.gsoc_min_c_mg_prot,f.gsoc_max_c_mg_prot,f.gsoc_mean_c_mg_prot,f.gsoc_tot_c_pg_prot,f.gsoc_min_c_mg_unprot,f.gsoc_max_c_mg_unprot,f.gsoc_mean_c_mg_unprot,f.gsoc_tot_c_pg_unprot,
g.carbon_min_c_mg_total,g.carbon_max_c_mg_total,g.carbon_mean_c_mg_total,g.carbon_tot_c_pg_total,g.carbon_min_c_mg_prot,g.carbon_max_c_mg_prot,g.carbon_mean_c_mg_prot,g.carbon_tot_c_pg_prot,g.carbon_min_c_mg_unprot,g.carbon_max_c_mg_unprot,g.carbon_mean_c_mg_unprot,g.carbon_tot_c_pg_unprot,
--elevation 
el.elev_min,el.elev_max,el.elev_mean,
--GFC
i.gfc_gain_sqkm,i.gfc_gain_prot_sqkm,i.gfc_gain_perc_tot,i.gfc_gain_prot_perc_tot,
l.gfc_loss_sqkm,l.gfc_loss_prot_sqkm,l.gfc_loss_perc_tot,l.gfc_loss_prot_perc_tot,
h.gfc_treecover_land_sqkm,h.gfc_treecover_land_perc_country_land,h.gfc_treecover_land_prot_sqkm,h.gfc_treecover_land_prot_perc_country_land,h.gfc_treecover_land_prot_perc_country_land_prot,h.gfc_treecover_land_prot_perc_gfc_treecover_land,
--GSW
m.water_p_now_sqkm,m.water_p_1985_sqkm,m.water_p_netchange_sqkm,m.water_p_netchange_perc_first_epoch,m.water_p_prot_now_sqkm,m.water_p_prot_1985_sqkm,m.water_p_prot_netchange_sqkm,
m.water_p_prot_netchange_perc_first_epoch,m.water_s_now_sqkm,m.water_s_1985_sqkm,m.water_s_netchange_sqkm,m.water_s_netchange_perc_first_epoch,m.water_s_prot_now_sqkm,
m.water_s_prot_1985_sqkm,m.water_s_prot_netchange_sqkm,m.water_s_prot_netchange_perc_first_epoch,
--LPD
n.land_sqkm,n.land_prot_sqkm,n.lpd_null_sqkm,n.lpd_null_perc_land_sqkm,n.lpd_severe_sqkm,n.lpd_severe_perc_land_sqkm,n.lpd_moderate_sqkm,n.lpd_moderate_perc_land_sqkm,
n.lpd_stable_stressed_sqkm,n.lpd_stable_perc_land_sqkm,n.lpd_stable_sqkm,n.lpd_stable_stressed_perc_land_sqkm,n.lpd_increased_sqkm,n.lpd_increased_perc_land_sqkm,
n.lpd_prot_null_sqkm,n.lpd_prot_null_perc_land_prot_sqkm,n.lpd_prot_severe_sqkm,n.lpd_prot_severe_perc_land_prot_sqkm,n.lpd_prot_moderate_sqkm,n.lpd_prot_moderate_perc_land_prot_sqkm,
n.lpd_prot_stable_stressed_sqkm,n.lpd_prot_stable_perc_land_prot_sqkm,n.lpd_prot_stable_sqkm,n.lpd_prot_stable_stressed_perc_land_prot_sqkm,n.lpd_prot_increased_sqkm,n.lpd_prot_increased_perc_land_prot_sqkm,

--MSPA
fr.mspa_core_1995_sqkm,fr.mspa_non_natural_1995_sqkm,fr.mspa_edge_1995_sqkm,fr.mspa_core_perforation_1995_sqkm,fr.mspa_islet_1995_sqkm,
fr.mspa_linear_1995_sqkm,fr.mspa_core_2000_sqkm,fr.mspa_non_natural_2000_sqkm,fr.mspa_edge_2000_sqkm,fr.mspa_core_perforation_2000_sqkm,
fr.mspa_islet_2000_sqkm,fr.mspa_linear_2000_sqkm,fr.mspa_core_2005_sqkm,fr.mspa_non_natural_2005_sqkm,fr.mspa_edge_2005_sqkm,
fr.mspa_core_perforation_2005_sqkm,fr.mspa_islet_2005_sqkm,fr.mspa_linear_2005_sqkm,fr.mspa_core_2010_sqkm,fr.mspa_non_natural_2010_sqkm,
fr.mspa_edge_2010_sqkm,fr.mspa_core_perforation_2010_sqkm,fr.mspa_islet_2010_sqkm,fr.mspa_linear_2010_sqkm,fr.mspa_core_2015_sqkm,
fr.mspa_non_natural_2015_sqkm,fr.mspa_edge_2015_sqkm,fr.mspa_core_perforation_2015_sqkm,fr.mspa_islet_2015_sqkm,fr.mspa_linear_2015_sqkm,

-- LAND COVER CHANGE
lc.lcc_esa_country_land_sqkm,lc.lcc_esa_country_land_prot_sqkm,lc.lcc_esa_lc1_1995,lc.lcc_esa_lc1_2020,lc.lcc_esa_land_sqkm,lc.lcc_esa_land_prot_sqkm,

-- LC COPERNICUS
cop.lc_copernicus_code,cop.lc_copernicus_tot_sqkm,cop.lc_copernicus_prot_sqkm,cop.lc_copernicus_land_sqkm,
cop.lc_copernicus_land_prot_sqkm,cop.lc_copernicus_marine_sqkm,cop.lc_copernicus_marine_prot_sqkm,
cop.lc_copernicus_land_natural_sqkm,cop.lc_copernicus_land_natural_prot_sqkm,cop.lc_copernicus_land_forest_sqkm,
cop.lc_copernicus_land_forest_prot_sqkm,cop.lc_copernicus_land_water_sqkm,cop.lc_copernicus_land_water_prot_sqkm

--SPECIES
--,iu.iucn_plants_total,iu.iucn_animals_total,iu.iucn_amphibians_threatened,iu.iucn_birds_threatened,iu.iucn_mammals_threatened,
--iu.iucn_sharks_rays_chimaeras_endemic,iu.iucn_sharks_rays_chimaeras_endemic_threatened,iu.iucn_amphibians_endemic,iu.iucn_amphibians_endemic_threatened,
--iu.iucn_birds_endemic,iu.iucn_birds_endemic_threatened,iu.iucn_mammals_endemic,iu.iucn_mammals_endemic_threatened


FROM country_coverage a
LEFT JOIN results_202601_non_cep.country_conservation_connectivity pr USING(country_id)
LEFT JOIN results_202601_non_cep.country_conservation_kba p USING(country_id)
LEFT JOIN results_202601_cep_out.country_conservation_pa_list pp USING(country_id)
LEFT JOIN results_202601_cep_out.country_carbon_above_ground b USING(country_id)
LEFT JOIN results_202601_cep_out.country_carbon_below_ground c USING(country_id)
LEFT JOIN results_202601_cep_out.country_carbon_dead_wood d USING(country_id)
LEFT JOIN results_202601_cep_out.country_carbon_litter e USING(country_id)
LEFT JOIN results_202601_cep_out.country_carbon_soil_organic f USING(country_id)
LEFT JOIN results_202601_cep_out.country_carbon_total g USING(country_id)
LEFT JOIN results_202601_cep_out.country_elevation_profile el USING(country_id)
LEFT JOIN results_202601_cep_out.country_global_forest_cover_treecover h USING(country_id)
LEFT JOIN results_202601_cep_out.country_global_forest_cover_gain i USING(country_id)
LEFT JOIN results_202601_cep_out.country_global_forest_cover_loss l USING(country_id)
LEFT JOIN results_202601_cep_out.country_water_surface_inland m USING(country_id)
LEFT JOIN results_202601_cep_out.country_lpd n USING(country_id)
LEFT JOIN results_202601_cep_out.country_mspa fr USING(country_id)
LEFT JOIN results_202601_cep_out.country_lcc_esa lc USING(country_id)
LEFT JOIN results_202601_cep_out.country_lc_copernicus_array cop USING(country_id)

-- LEFT JOIN SPECIES STATS ....   iu  USING(country_id) SPECIES STATS... TO BE ADDED
ORDER BY country_id;


