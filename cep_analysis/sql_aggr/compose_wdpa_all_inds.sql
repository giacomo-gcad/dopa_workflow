-- COMPUTE PA AREA at raster CEP resolution
DROP TABLE IF EXISTS pa_rtot_sqkm1;CREATE TEMPORARY TABLE pa_rtot_sqkm1 AS
SELECT DISTINCT pa,qid,cid FROM cep_data_202601.cep_index WHERE is_protected IS TRUE ORDER BY pa,qid,cid;
DROP TABLE IF EXISTS pa_rtot_sqkm2;CREATE TEMPORARY TABLE pa_rtot_sqkm2 AS
SELECT a.*,b.sqkm FROM pa_rtot_sqkm1 a JOIN (SELECT qid,cid,sqkm FROM cep_data_202601.cep_index) b USING(qid,cid) ORDER BY a.pa;
DROP TABLE IF EXISTS pa_rtot_sqkm3;CREATE TEMPORARY TABLE pa_rtot_sqkm3 AS
SELECT pa wdpaid,SUM(sqkm) pa_rtot_sqkm FROM pa_rtot_sqkm2 GROUP BY pa ORDER BY pa;

---- PA
DROP FUNCTION IF EXISTS delli.get_dopa_wdpa_all_inds(integer);
DROP MATERIALIZED VIEW IF EXISTS delli.dopa_wdpa_all_inds_template;

DROP TABLE IF EXISTS delli.dopa_wdpa_all_inds;CREATE TABLE delli.dopa_wdpa_all_inds AS
SELECT a.wdpaid,a.name::text pa_name,a.desig_eng::text,a.iucn_cat::text,a.marine,
CASE a.metadataid WHEN 1832 THEN true ELSE NULL END is_n2k,a.iso3::text,a.type::text,a.area_geo,ra.pa_rtot_sqkm,

b.agb_min_c_mg,b.agb_max_c_mg,b.agb_mean_c_mg,b.agb_tot_c_mg,
c.bgb_min_c_mg,c.bgb_max_c_mg,c.bgb_mean_c_mg,c.bgb_tot_c_mg,
d.dwc_min_c_mg,d.dwc_max_c_mg,d.dwc_mean_c_mg,d.dwc_tot_c_mg,
e.ltc_min_c_mg,e.ltc_max_c_mg,e.ltc_mean_c_mg,e.ltc_tot_c_mg,
f.gsoc_min_c_mg,f.gsoc_max_c_mg,f.gsoc_mean_c_mg,f.gsoc_tot_c_mg,
g.carbon_min_c_mg,g.carbon_max_c_mg,g.carbon_mean_c_mg,g.carbon_tot_c_mg,

--CLIMATE
cl.cli_tmax_01,cl.cli_tmax_02,cl.cli_tmax_03,cl.cli_tmax_04,cl.cli_tmax_05,cl.cli_tmax_06,
cl.cli_tmax_07,cl.cli_tmax_08,cl.cli_tmax_09,cl.cli_tmax_10,cl.cli_tmax_11,cl.cli_tmax_12,
cl.cli_tmean_01,cl.cli_tmean_02,cl.cli_tmean_03,cl.cli_tmean_04,cl.cli_tmean_05,cl.cli_tmean_06,
cl.cli_tmean_07,cl.cli_tmean_08,cl.cli_tmean_09,cl.cli_tmean_10,cl.cli_tmean_11,cl.cli_tmean_12,
cl.cli_tmin_01,cl.cli_tmin_02,cl.cli_tmin_03,cl.cli_tmin_04,cl.cli_tmin_05,cl.cli_tmin_06,
cl.cli_tmin_07,cl.cli_tmin_08,cl.cli_tmin_09,cl.cli_tmin_10,cl.cli_tmin_11,cl.cli_tmin_12,
cl.cli_prec_01,cl.cli_prec_02,cl.cli_prec_03,cl.cli_prec_04,cl.cli_prec_05,cl.cli_prec_06,
cl.cli_prec_07,cl.cli_prec_08,cl.cli_prec_09,cl.cli_prec_10,cl.cli_prec_11,cl.cli_prec_12,

-- ELEVATION PROFILE
el.elev_min,el.elev_max,el.elev_mean,

-- GFC FOREST
l.gfc_gain_sqkm,l.gfc_gain_perc_tot,
i.gfc_loss_sqkm,i.gfc_loss_perc_tot,
h.gfc_treecover_land_sqkm,h.gfc_treecover_land_perc_pa_land,

--HABITAT DIVERSITY
--THDI MISSING, TO BE COMPUTED
NULL AS hdi_freq,
NULL AS hdi_awhd,
--th.hdi_freq,th.hdi_awhd,
mh.mhdi,

--GLOBAL SURFACE WATER
n.water_p_now_sqkm,n.water_p_1985_sqkm,
n.water_p_netchange_sqkm,n.water_p_netchange_perc_first_epoch,
n.water_s_now_sqkm,n.water_s_1985_sqkm,
n.water_s_netchange_sqkm,n.water_s_netchange_perc_first_epoch,

--LPD
m.lpd_null_sqkm,m.lpd_null_perc_tot_sqkm,
m.lpd_severe_sqkm,m.lpd_severe_perc_tot_sqkm,
m.lpd_moderate_sqkm,m.lpd_moderate_perc_tot_sqkm,
m.lpd_stable_stressed_sqkm,m.lpd_stable_perc_tot_sqkm,
m.lpd_stable_sqkm,m.lpd_stable_stressed_perc_tot_sqkm,
m.lpd_increased_sqkm,m.lpd_increased_perc_tot_sqkm,

--LAND FRAGMENTATION
ms.mspa_core_1995_sqkm,ms.mspa_non_natural_1995_sqkm,ms.mspa_edge_1995_sqkm,ms.mspa_core_perforation_1995_sqkm,ms.mspa_islet_1995_sqkm,ms.mspa_linear_1995_sqkm,
ms.mspa_core_2000_sqkm,ms.mspa_non_natural_2000_sqkm,ms.mspa_edge_2000_sqkm,ms.mspa_core_perforation_2000_sqkm,ms.mspa_islet_2000_sqkm,ms.mspa_linear_2000_sqkm,
ms.mspa_core_2005_sqkm,ms.mspa_non_natural_2005_sqkm,ms.mspa_edge_2005_sqkm,ms.mspa_core_perforation_2005_sqkm,ms.mspa_islet_2005_sqkm,ms.mspa_linear_2005_sqkm,
ms.mspa_core_2010_sqkm,ms.mspa_non_natural_2010_sqkm,ms.mspa_edge_2010_sqkm,ms.mspa_core_perforation_2010_sqkm,ms.mspa_islet_2010_sqkm,ms.mspa_linear_2010_sqkm,
ms.mspa_core_2015_sqkm,ms.mspa_non_natural_2015_sqkm,ms.mspa_edge_2015_sqkm,ms.mspa_core_perforation_2015_sqkm,ms.mspa_islet_2015_sqkm,ms.mspa_linear_2015_sqkm,

--PRESSURES PA
ag.p_agriculture_pa_perc_tot,
blt.p_builtup_pa_sqkm,blt.p_builtup_pa_perc_land,
pop.p_population_pa_last_epoch_sum,pop.p_population_pa_last_epoch_density,pop.p_population_pa_density_change,pop.p_population_pa_change_perc_first_epoch,
ro.p_road_pa_perc_tot,

--PRESSURES BUFFERS
agbu.p_agriculture_bu_perc_tot,
bltbu.p_builtup_bu_sqkm,bltbu.p_builtup_bu_perc_land,
popbu.p_population_bu_last_epoch_sum,popbu.p_population_bu_last_epoch_density,popbu.p_population_bu_density_change,popbu.p_population_bu_change_perc_first_epoch,
robu.p_road_bu_perc_tot,


--LC ESA
es.lc_esa_code,es.lc_esa_1995_sqkm,es.lc_esa_2000_sqkm,es.lc_esa_2005_sqkm,es.lc_esa_2010_sqkm,es.lc_esa_2015_sqkm,es.lc_esa_2020_sqkm,
--LCC_ESA
cc.lcc_esa_pa_tot_sqkm,cc.lcc_esa_lc1_1995,cc.lcc_esa_lc1_2020,cc.lcc_esa_sqkm,
--LC_COPERNICUS
co.lc_copernicus_code,co.lc_copernicus_tot_sqkm

FROM protected_sites.wdpa_wdoecm_202601 a	
LEFT JOIN pa_rtot_sqkm3 ra USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_carbon_above_ground b USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_carbon_below_ground c USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_carbon_dead_wood d USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_carbon_litter e USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_carbon_soil_organic f USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_carbon_total g USING(wdpaid)
LEFT JOIN results_202601_non_cep.wdpa_climate cl USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_elevation_profile el USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_global_forest_cover_treecover h USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_global_forest_cover_loss i USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_global_forest_cover_gain l USING(wdpaid)
--LEFT JOIN results_202601_non_cep.wdpa_habitat_diversity_profile_thdi th USING(wdpaid)
LEFT JOIN results_202601_non_cep.wdpa_habitat_diversity_profile_mhdi mh USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_lpd m USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_water_surface_inland n USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_mspa ms USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_agriculture_pa ag USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_builtup_pa blt USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_population_pa pop USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_roads_pa ro USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_agriculture_bu agbu USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_builtup_bu bltbu USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_population_bu popbu USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_pressure_roads_bu robu USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_lc_esa es USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_lcc_esa cc USING(wdpaid)
LEFT JOIN results_202601_cep_out.wdpa_lc_copernicus co USING(wdpaid)
ORDER BY wdpaid;

