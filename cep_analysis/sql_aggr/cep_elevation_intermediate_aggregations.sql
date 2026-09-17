-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_univar_cep_gebco2026_202601;
------------------------------------------------------------
DROP TABLE IF EXISTS country_index; CREATE TEMPORARY TABLE country_index AS SELECT * FROM cep_data_202601.cep_index;
--DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM cep_data_202601.cep_index;
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS SELECT * FROM cep_data_202601.cep_index;
------------------------------------------------------------------
/* \set vmin '_'elevation_profile_intermediate'_min'
\set vmax '_'elevation_profile_intermediate'_max'
\set vmean '_'elevation_profile_intermediate'_mean'
\set vsum '_'elevation_profile_intermediate'_sum'
\set vtot '_tot'
\set vprot '_prot'
\set vunprot '_unprot'
\set vland '_land'
\set vmar '_marine' */

-- COUNTRY
--\set vtab 'country'
-- COUNTRY TOT
DROP TABLE IF EXISTS country_tot;CREATE TEMPORARY TABLE country_tot AS
SELECT  country_id,MIN(min) country_tot_elevation_profile_intermediate_min,MAX(max) country_tot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_tot_elevation_profile_intermediate_mean,SUM(sum) country_tot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
-- COUNTRY TOT PROT
DROP TABLE IF EXISTS country_tot_prot;CREATE TEMPORARY TABLE country_tot_prot AS
SELECT  country_id,MIN(min) country_tot_prot_elevation_profile_intermediate_min,MAX(max) country_tot_prot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_tot_prot_elevation_profile_intermediate_mean,SUM(sum) country_tot_prot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_protected IS TRUE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
-- COUNTRY TOT UNPROT
DROP TABLE IF EXISTS country_tot_unprot;CREATE TEMPORARY TABLE country_tot_unprot AS
SELECT country_id,MIN(min) country_tot_unprot_elevation_profile_intermediate_min,MAX(max) country_tot_unprot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_tot_unprot_elevation_profile_intermediate_mean,SUM(sum) country_tot_unprot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_protected IS FALSE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
--COUNTRY LAND
DROP TABLE IF EXISTS country_land;CREATE TEMPORARY TABLE country_land AS
SELECT  country_id,MIN(min) country_land_elevation_profile_intermediate_min,MAX(max) country_land_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_land_elevation_profile_intermediate_mean,SUM(sum) country_land_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_marine IS FALSE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
--COUNTRY LAND PROT
DROP TABLE IF EXISTS country_land_prot;CREATE TEMPORARY TABLE country_land_prot AS
SELECT country_id,MIN(min) country_land_prot_elevation_profile_intermediate_min,MAX(max) country_land_prot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_land_prot_elevation_profile_intermediate_mean,SUM(sum) country_land_prot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_marine IS FALSE AND is_protected IS TRUE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
--COUNTRY LAND UNPROT
DROP TABLE IF EXISTS country_land_unprot;CREATE TEMPORARY TABLE country_land_unprot AS
SELECT country_id,MIN(min) country_land_unprot_elevation_profile_intermediate_min,MAX(max) country_land_unprot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_land_unprot_elevation_profile_intermediate_mean,SUM(sum) country_land_unprot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_marine IS FALSE AND is_protected IS FALSE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
--COUNTRY MARINE
DROP TABLE IF EXISTS country_marine;CREATE TEMPORARY TABLE country_marine AS
SELECT country_id,MIN(min) country_marine_elevation_profile_intermediate_min,MAX(max) country_marine_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_marine_elevation_profile_intermediate_mean,SUM(sum) country_marine_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_marine IS TRUE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
--COUNTRY MARINE PROT
DROP TABLE IF EXISTS country_marine_prot;CREATE TEMPORARY TABLE country_marine_prot AS
SELECT country_id,MIN(min) country_marine_prot_elevation_profile_intermediate_min,MAX(max) country_marine_prot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_marine_prot_elevation_profile_intermediate_mean,SUM(sum) country_marine_prot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_marine IS TRUE AND is_protected IS TRUE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;
--COUNTRY MARINE UNPROT
DROP TABLE IF EXISTS country_marine_unprot;CREATE TEMPORARY TABLE country_marine_unprot AS
SELECT country_id,MIN(min) country_marine_unprot_elevation_profile_intermediate_min,MAX(max) country_marine_unprot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) country_marine_unprot_elevation_profile_intermediate_mean,SUM(sum) country_marine_unprot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT country_id,qid,cid,(sqkm*1000000) area_m2 FROM country_index WHERE is_marine IS TRUE AND is_protected IS FALSE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY country_id ORDER BY country_id;

/* ----------------------------------------
-- ECOREGION
\set vtab 'ecoregion'
-- ECOREGION TOT
DROP TABLE IF EXISTS :vtab_tot;CREATE TEMPORARY TABLE :vtab_tot AS
SELECT ecoregion eco_id,MIN(min) :vtab_tot_elevation_profile_intermediate_min,MAX(max) :vtab_tot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) :vtab_tot_elevation_profile_intermediate_mean,SUM(sum) :vtab_tot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT ecoregion,qid,cid,(sqkm*1000000) area_m2 FROM ecoregion_index)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY ecoregion ORDER BY ecoregion;
-- ECOREGION PROT
DROP TABLE IF EXISTS :vtab_tot_prot;CREATE TEMPORARY TABLE :vtab_tot_prot AS
SELECT ecoregion eco_id,MIN(min) :vtab_tot_prot_elevation_profile_intermediate_min,MAX(max) :vtab_tot_prot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) :vtab_tot_prot_elevation_profile_intermediate_mean,SUM(sum) :vtab_tot_prot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT ecoregion,qid,cid,(sqkm*1000000) area_m2 FROM ecoregion_index WHERE is_protected IS TRUE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY ecoregion ORDER BY ecoregion;
-- ECOREGION UNPROT
DROP TABLE IF EXISTS :vtab_tot_unprot;CREATE TEMPORARY TABLE :vtab_tot_unprot AS
SELECT ecoregion eco_id,MIN(min) :vtab_tot_unprot_elevation_profile_intermediate_min,MAX(max) :vtab_tot_unprot_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) :vtab_tot_unprot_elevation_profile_intermediate_mean,SUM(sum) :vtab_tot_unprot_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT ecoregion,qid,cid,(sqkm*1000000) area_m2 FROM ecoregion_index WHERE is_protected IS FALSE)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY ecoregion ORDER BY ecoregion;
 */----------------------------------------
 
-- PROTECTION
--\set vtab 'pa'
DROP TABLE IF EXISTS pa;CREATE TEMPORARY TABLE pa AS
SELECT pa wdpaid,MIN(min) pa_elevation_profile_intermediate_min,MAX(max) pa_elevation_profile_intermediate_max,SUM(mean*area_m2)/SUM(area_m2) pa_elevation_profile_intermediate_mean,SUM(sum) pa_elevation_profile_intermediate_sum
FROM (SELECT DISTINCT pa,qid,cid,(sqkm*1000000) area_m2  FROM pa_index)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY pa ORDER BY pa;

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
-- country
DROP TABLE IF EXISTS results_202601_cep_out.country_elevation_profile_intermediate;
CREATE TABLE results_202601_cep_out.country_elevation_profile_intermediate AS
SELECT * FROM country_tot a 
LEFT JOIN country_tot_prot b USING(country_id)
LEFT JOIN country_tot_unprot c USING(country_id)
LEFT JOIN country_land d USING(country_id)
LEFT JOIN country_land_prot e USING(country_id)
LEFT JOIN country_land_unprot f USING(country_id)
LEFT JOIN country_marine g USING(country_id)
LEFT JOIN country_marine_prot h USING(country_id)
LEFT JOIN country_marine_unprot i USING(country_id);
/* -- ecoregion
DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_elevation_profile_intermediate;
CREATE TABLE results_202601_cep_out.ecoregion_elevation_profile_intermediate AS
SELECT * FROM ecoregion_tot a
LEFT JOIN ecoregion_tot_prot b USING(eco_id)
LEFT JOIN ecoregion_tot_unprot c USING(eco_id); */
-- pa
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_elevation_profile_intermediate;
CREATE TABLE results_202601_cep_out.wdpa_elevation_profile_intermediate AS
SELECT * FROM pa;
