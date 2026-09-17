--COUNTRY
DROP TABLE IF EXISTS :v_rcep_out.country_lpd;CREATE TABLE :v_rcep_out.country_lpd AS 
WITH
finput AS (SELECT country country_id,country_name,iso3,iso2,un_m49,status FROM :v_rcep_in.atts_country_last ORDER BY country),
tot_ext AS(SELECT DISTINCT country_id,land_sqkm FROM :v_rcep_out.country_intermediate_lpd),
prot_ext AS(SELECT DISTINCT country_id,land_prot_sqkm FROM :v_rcep_out.country_intermediate_lpd),
cat0 AS (SELECT country_id,theme_land_sqkm cat0 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=0), --lpd_null_sqkm
cat1 AS (SELECT country_id,theme_land_sqkm cat1 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=1), --lpd_severe_sqkm,
cat2 AS (SELECT country_id,theme_land_sqkm cat2 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=2), --lpd_moderate_sqkm,
cat3 AS (SELECT country_id,theme_land_sqkm cat3 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=3), --lpd_stable_stressed_sqkm
cat4 AS (SELECT country_id,theme_land_sqkm cat4 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=4), --lpd_stable_sqkm
cat5 AS (SELECT country_id,theme_land_sqkm cat5 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=5),
pcat0 AS (SELECT country_id,theme_land_prot_sqkm pcat0 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=0), --lpd_null_sqkm
pcat1 AS (SELECT country_id,theme_land_prot_sqkm pcat1 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=1), --lpd_severe_sqkm,
pcat2 AS (SELECT country_id,theme_land_prot_sqkm pcat2 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=2), --lpd_moderate_sqkm,
pcat3 AS (SELECT country_id,theme_land_prot_sqkm pcat3 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=3), --lpd_stable_stressed_sqkm
pcat4 AS (SELECT country_id,theme_land_prot_sqkm pcat4 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=4), --lpd_stable_sqkm
pcat5 AS (SELECT country_id,theme_land_prot_sqkm pcat5 FROM :v_rcep_out.country_intermediate_lpd WHERE cat=5),
--lpd_increased_sqkm
all_cats AS (SELECT * FROM finput
LEFT JOIN tot_ext USING(country_id)
LEFT JOIN prot_ext USING(country_id)
LEFT JOIN cat0 USING(country_id)
LEFT JOIN cat1 USING(country_id)
LEFT JOIN cat2 USING(country_id)
LEFT JOIN cat3 USING(country_id)
LEFT JOIN cat4 USING(country_id)
LEFT JOIN cat5 USING(country_id)
LEFT JOIN pcat0 USING(country_id)
LEFT JOIN pcat1 USING(country_id)
LEFT JOIN pcat2 USING(country_id)
LEFT JOIN pcat3 USING(country_id)
LEFT JOIN pcat4 USING(country_id)
LEFT JOIN pcat5 USING(country_id)		 			 
ORDER BY country_id)
SELECT country_id,
land_sqkm,
land_prot_sqkm,
--country_name,iso3,status,land_sqkm,
cat0 lpd_null_sqkm,ROUND((cat0/land_sqkm*100)::numeric,2) lpd_null_perc_land_sqkm,
cat1 lpd_severe_sqkm,ROUND((cat1/land_sqkm*100)::numeric,2) lpd_severe_perc_land_sqkm,
cat2 lpd_moderate_sqkm,ROUND((cat2/land_sqkm*100)::numeric,2) lpd_moderate_perc_land_sqkm,
cat3 lpd_stable_stressed_sqkm,ROUND((cat3/land_sqkm*100)::numeric,2) lpd_stable_perc_land_sqkm,
cat4 lpd_stable_sqkm,ROUND((cat4/land_sqkm*100)::numeric,2) lpd_stable_stressed_perc_land_sqkm,
cat5 lpd_increased_sqkm,ROUND((cat5/land_sqkm*100)::numeric,2) lpd_increased_perc_land_sqkm,
pcat0 lpd_prot_null_sqkm,ROUND((pcat0/land_prot_sqkm*100)::numeric,2) lpd_prot_null_perc_land_prot_sqkm,
pcat1 lpd_prot_severe_sqkm,ROUND((pcat1/land_prot_sqkm*100)::numeric,2) lpd_prot_severe_perc_land_prot_sqkm,
pcat2 lpd_prot_moderate_sqkm,ROUND((pcat2/land_prot_sqkm*100)::numeric,2) lpd_prot_moderate_perc_land_prot_sqkm,
pcat3 lpd_prot_stable_stressed_sqkm,ROUND((pcat3/land_prot_sqkm*100)::numeric,2) lpd_prot_stable_perc_land_prot_sqkm,
pcat4 lpd_prot_stable_sqkm,ROUND((pcat4/land_prot_sqkm*100)::numeric,2) lpd_prot_stable_stressed_perc_land_prot_sqkm,
pcat5 lpd_prot_increased_sqkm,ROUND((pcat5/land_prot_sqkm*100)::numeric,2) lpd_prot_increased_perc_land_prot_sqkm
FROM all_cats ORDER BY country_id;
--ECO
DROP TABLE IF EXISTS :v_rcep_out.ecoregion_lpd; CREATE TABLE :v_rcep_out.ecoregion_lpd AS 
WITH
finput AS (SELECT ecoregion eco_id,ecoregion_name,source,is_marine FROM :v_rcep_in.atts_ecoregion_last WHERE is_marine IS FALSE ORDER BY eco_id),
tot_ext AS(SELECT DISTINCT eco_id,land_sqkm FROM :v_rcep_out.ecoregion_intermediate_lpd),
prot_ext AS(SELECT DISTINCT eco_id,land_prot_sqkm FROM :v_rcep_out.ecoregion_intermediate_lpd),
cat0 AS (SELECT eco_id,theme_land_sqkm cat0 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=0), --lpd_null_sqkm
cat1 AS (SELECT eco_id,theme_land_sqkm cat1 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=1), --lpd_severe_sqkm,
cat2 AS (SELECT eco_id,theme_land_sqkm cat2 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=2), --lpd_moderate_sqkm,
cat3 AS (SELECT eco_id,theme_land_sqkm cat3 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=3), --lpd_stable_stressed_sqkm
cat4 AS (SELECT eco_id,theme_land_sqkm cat4 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=4), --lpd_stable_sqkm
cat5 AS (SELECT eco_id,theme_land_sqkm cat5 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=5),
pcat0 AS (SELECT eco_id,theme_land_prot_sqkm pcat0 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=0), --lpd_null_sqkm
pcat1 AS (SELECT eco_id,theme_land_prot_sqkm pcat1 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=1), --lpd_severe_sqkm,
pcat2 AS (SELECT eco_id,theme_land_prot_sqkm pcat2 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=2), --lpd_moderate_sqkm,
pcat3 AS (SELECT eco_id,theme_land_prot_sqkm pcat3 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=3), --lpd_stable_stressed_sqkm
pcat4 AS (SELECT eco_id,theme_land_prot_sqkm pcat4 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=4), --lpd_stable_sqkm
pcat5 AS (SELECT eco_id,theme_land_prot_sqkm pcat5 FROM :v_rcep_out.ecoregion_intermediate_lpd WHERE cat=5),
--lpd_increased_sqkm
all_cats AS (SELECT * FROM finput
LEFT JOIN tot_ext USING(eco_id)
LEFT JOIN prot_ext USING(eco_id)
LEFT JOIN cat0 USING(eco_id)
LEFT JOIN cat1 USING(eco_id)
LEFT JOIN cat2 USING(eco_id)
LEFT JOIN cat3 USING(eco_id)
LEFT JOIN cat4 USING(eco_id)
LEFT JOIN cat5 USING(eco_id)
LEFT JOIN pcat0 USING(eco_id)
LEFT JOIN pcat1 USING(eco_id)
LEFT JOIN pcat2 USING(eco_id)
LEFT JOIN pcat3 USING(eco_id)
LEFT JOIN pcat4 USING(eco_id)
LEFT JOIN pcat5 USING(eco_id)		 			 
ORDER BY eco_id)
SELECT eco_id,
land_sqkm,
land_prot_sqkm,
--ecoregion_name,iso3,status,land_sqkm,
cat0 lpd_null_sqkm,ROUND((cat0/land_sqkm*100)::numeric,2) lpd_null_perc_land_sqkm,
cat1 lpd_severe_sqkm,ROUND((cat1/land_sqkm*100)::numeric,2) lpd_severe_perc_land_sqkm,
cat2 lpd_moderate_sqkm,ROUND((cat2/land_sqkm*100)::numeric,2) lpd_moderate_perc_land_sqkm,
cat3 lpd_stable_stressed_sqkm,ROUND((cat3/land_sqkm*100)::numeric,2) lpd_stable_perc_land_sqkm,
cat4 lpd_stable_sqkm,ROUND((cat4/land_sqkm*100)::numeric,2) lpd_stable_stressed_perc_land_sqkm,
cat5 lpd_increased_sqkm,ROUND((cat5/land_sqkm*100)::numeric,2) lpd_increased_perc_land_sqkm,
pcat0 lpd_prot_null_sqkm,ROUND((pcat0/land_prot_sqkm*100)::numeric,2) lpd_prot_null_perc_land_prot_sqkm,
pcat1 lpd_prot_severe_sqkm,ROUND((pcat1/land_prot_sqkm*100)::numeric,2) lpd_prot_severe_perc_land_prot_sqkm,
pcat2 lpd_prot_moderate_sqkm,ROUND((pcat2/land_prot_sqkm*100)::numeric,2) lpd_prot_moderate_perc_land_prot_sqkm,
pcat3 lpd_prot_stable_stressed_sqkm,ROUND((pcat3/land_prot_sqkm*100)::numeric,2) lpd_prot_stable_perc_land_prot_sqkm,
pcat4 lpd_prot_stable_sqkm,ROUND((pcat4/land_prot_sqkm*100)::numeric,2) lpd_prot_stable_stressed_perc_land_prot_sqkm,
pcat5 lpd_prot_increased_sqkm,ROUND((pcat5/land_prot_sqkm*100)::numeric,2) lpd_prot_increased_perc_land_prot_sqkm
FROM all_cats ORDER BY eco_id;
--PA
DROP TABLE IF EXISTS :v_rcep_out.wdpa_lpd; CREATE TABLE :v_rcep_out.wdpa_lpd AS 
WITH
finput AS (SELECT pa wdpaid,pa_name,desig_eng,iucn_cat,marine,iso3,type FROM :v_rcep_in.atts_pa_last WHERE marine IN (0,1) ORDER BY wdpaid),
tot_ext AS(SELECT DISTINCT wdpaid,tot_sqkm FROM :v_rcep_out.wdpa_intermediate_lpd),
cat0 AS (SELECT wdpaid,theme_sqkm cat0 FROM :v_rcep_out.wdpa_intermediate_lpd WHERE cat=0), --lpd_null_sqkm
cat1 AS (SELECT wdpaid,theme_sqkm cat1 FROM :v_rcep_out.wdpa_intermediate_lpd WHERE cat=1), --lpd_severe_sqkm,
cat2 AS (SELECT wdpaid,theme_sqkm cat2 FROM :v_rcep_out.wdpa_intermediate_lpd WHERE cat=2), --lpd_moderate_sqkm,
cat3 AS (SELECT wdpaid,theme_sqkm cat3 FROM :v_rcep_out.wdpa_intermediate_lpd WHERE cat=3), --lpd_stable_stressed_sqkm
cat4 AS (SELECT wdpaid,theme_sqkm cat4 FROM :v_rcep_out.wdpa_intermediate_lpd WHERE cat=4), --lpd_stable_sqkm
cat5 AS (SELECT wdpaid,theme_sqkm cat5 FROM :v_rcep_out.wdpa_intermediate_lpd WHERE cat=5), --lpd_increased_sqkm
all_cats AS (SELECT * FROM finput
LEFT JOIN tot_ext USING(wdpaid)
LEFT JOIN cat0 USING(wdpaid)
LEFT JOIN cat1 USING(wdpaid)
LEFT JOIN cat2 USING(wdpaid)
LEFT JOIN cat3 USING(wdpaid)
LEFT JOIN cat4 USING(wdpaid)
LEFT JOIN cat5 USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,
--pa_name,desig_eng,iucn_cat,marine,iso3,type,
cat0 lpd_null_sqkm,ROUND((cat0/tot_sqkm*100)::numeric,2) lpd_null_perc_tot_sqkm,
cat1 lpd_severe_sqkm,ROUND((cat1/tot_sqkm*100)::numeric,2) lpd_severe_perc_tot_sqkm,
cat2 lpd_moderate_sqkm,ROUND((cat2/tot_sqkm*100)::numeric,2) lpd_moderate_perc_tot_sqkm,
cat3 lpd_stable_stressed_sqkm,ROUND((cat3/tot_sqkm*100)::numeric,2) lpd_stable_perc_tot_sqkm,
cat4 lpd_stable_sqkm,ROUND((cat4/tot_sqkm*100)::numeric,2) lpd_stable_stressed_perc_tot_sqkm,
cat5 lpd_increased_sqkm,ROUND((cat5/tot_sqkm*100)::numeric,2) lpd_increased_perc_tot_sqkm
FROM all_cats ORDER BY wdpaid;

--DROP TABLE IF EXISTS :v_rcep_out.country_intermediate_lpd;
--DROP TABLE IF EXISTS :v_rcep_out.ecoregion_intermediate_lpd;
--DROP TABLE IF EXISTS :v_rcep_out.wdpa_intermediate_lpd;