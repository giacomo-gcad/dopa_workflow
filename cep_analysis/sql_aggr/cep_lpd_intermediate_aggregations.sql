-----------------------------------------------------------------------------------------------------------------------------
-- INPUTS
-----------------------------------------------------------------------------------------------------------------------------
-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_stats_cep_lpd_v2_202601;
-- SELECT THE GRID;
DROP TABLE IF EXISTS grid_index; CREATE TEMPORARY TABLE grid_index AS SELECT qid,eid FROM results_202601_cep_in.grid_vector ORDER BY qid,eid;

------------------------------------------------------------
DROP TABLE IF EXISTS country_index; CREATE TEMPORARY TABLE country_index AS 
SELECT DISTINCT country_id,country_uri iso3,country_name name_eng,eid,qid,cid,is_marine,is_protected,sqkm, SUM(sqkm) country_land_sqkm FROM cep_data_202601.cep_index JOIN grid_index USING (qid)
WHERE is_marine IS NOT TRUE GROUP BY country_id,country_uri,country_name,eid,qid,cid,is_marine,is_protected,sqkm;

-- DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM results_202601_cep_in.index_ecoregion_cep_last JOIN grid_index USING (qid);

DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS 
SELECT a.pa,a.pa_name,a.country_uri iso3,a.qid,a.cid,b.marine,SUM(a.sqkm) sqkm 
FROM cep_data_202601.cep_index a RIGHT JOIN protected_sites.wdpa_wdoecm_202601 b ON a.pa=b.wdpaid JOIN grid_index USING (qid) 
GROUP BY a.pa,a.pa_name,a.country_uri,a.qid,a.cid,b.marine;

-----------------------------------------------------------------------------------------------------------------------------
-- PRE-PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme_sqkm; CREATE TEMPORARY TABLE theme_sqkm AS SELECT qid,cid,cat,area_m2/1000000 sqkm FROM theme;
-----------------------------------------------------------------------------------------------------------------------------
-- PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- COUNTRY PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS country_theme;CREATE TEMPORARY TABLE country_theme AS
WITH
a AS (SELECT * FROM (SELECT DISTINCT country_id,is_marine,is_protected,qid,cid FROM country_index) a NATURAL JOIN theme_sqkm),
--theme_stats
t_tot AS (SELECT country_id,cat,ROUND(SUM(sqkm::numeric),2) theme_tot_sqkm FROM a GROUP BY country_id,cat),
t_tot_prot AS (SELECT country_id,cat,ROUND(SUM(sqkm::numeric),2) theme_prot_sqkm FROM a WHERE is_protected IS TRUE GROUP BY country_id,cat),
t_land AS (SELECT country_id,cat,ROUND(SUM(sqkm::numeric),2) theme_land_sqkm FROM a WHERE is_marine IS NOT TRUE GROUP BY country_id,cat),
t_land_prot AS (SELECT country_id,cat,ROUND(SUM(sqkm::numeric),2) theme_land_prot_sqkm FROM a WHERE is_marine IS NOT TRUE AND is_protected IS TRUE GROUP BY country_id,cat),
t_marine AS (SELECT country_id,cat,ROUND(SUM(sqkm::numeric),2) theme_marine_sqkm FROM a WHERE is_marine IS TRUE GROUP BY country_id,cat),
t_marine_prot AS (SELECT country_id,cat,ROUND(SUM(sqkm::numeric),2) theme_marine_prot_sqkm FROM a WHERE is_marine IS TRUE AND is_protected IS TRUE GROUP BY country_id,cat),
feature_theme_stats AS (SELECT * FROM t_tot LEFT JOIN t_tot_prot USING(country_id,cat) LEFT JOIN t_land USING(country_id,cat) LEFT JOIN t_land_prot USING(country_id,cat) LEFT JOIN t_marine USING(country_id,cat) LEFT JOIN t_marine_prot USING(country_id,cat)  ORDER BY country_id,cat),
--country_stats
tot AS (SELECT country_id,ROUND(SUM(sqkm::numeric),2) tot_sqkm FROM a GROUP BY country_id),
tot_prot AS (SELECT country_id,ROUND(SUM(sqkm::numeric),2) prot_sqkm FROM a WHERE is_protected IS TRUE GROUP BY country_id),
land AS (SELECT country_id,ROUND(SUM(sqkm::numeric),2) land_sqkm FROM a WHERE is_marine IS NOT TRUE GROUP BY country_id),
land_prot AS (SELECT country_id,ROUND(SUM(sqkm::numeric),2) land_prot_sqkm FROM a WHERE is_marine IS NOT TRUE AND is_protected IS TRUE GROUP BY country_id),
marine AS (SELECT country_id,ROUND(SUM(sqkm::numeric),2) marine_sqkm FROM a WHERE is_marine IS TRUE GROUP BY country_id),
marine_prot AS (SELECT country_id,ROUND(SUM(sqkm::numeric),2) marine_prot_sqkm FROM a WHERE is_marine IS TRUE AND is_protected IS TRUE GROUP BY country_id),
feature_stats AS (SELECT * FROM tot LEFT JOIN tot_prot USING(country_id) LEFT JOIN land USING(country_id) LEFT JOIN land_prot USING(country_id) LEFT JOIN marine USING(country_id) LEFT JOIN marine_prot USING(country_id))
SELECT * FROM feature_theme_stats JOIN feature_stats USING(country_id);
/* -----------------------------------------------------------------------------------------------------------------------------
-- ECOREGION PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ecoregion_theme;CREATE TEMPORARY TABLE ecoregion_theme AS
WITH
--theme_stats
a AS (SELECT * FROM (SELECT ecoregion eco_id,is_marine,is_protected,qid,cid FROM ecoregion_index) a NATURAL JOIN theme_sqkm),
t_tot AS (SELECT eco_id,cat,ROUND(SUM(sqkm::numeric),2) theme_tot_sqkm FROM a GROUP BY eco_id,cat),
t_tot_prot AS (SELECT eco_id,cat,ROUND(SUM(sqkm::numeric),2) theme_prot_sqkm FROM a WHERE is_protected IS TRUE GROUP BY eco_id,cat),
t_land AS (SELECT eco_id,cat,ROUND(SUM(sqkm::numeric),2) theme_land_sqkm FROM a WHERE is_marine IS NOT TRUE GROUP BY eco_id,cat),
t_land_prot AS (SELECT eco_id,cat,ROUND(SUM(sqkm::numeric),2) theme_land_prot_sqkm FROM a WHERE is_marine IS NOT TRUE AND is_protected IS TRUE GROUP BY eco_id,cat),
t_marine AS (SELECT eco_id,cat,ROUND(SUM(sqkm::numeric),2) theme_marine_sqkm FROM a WHERE is_marine IS TRUE GROUP BY eco_id,cat),
t_marine_prot AS (SELECT eco_id,cat,ROUND(SUM(sqkm::numeric),2) theme_marine_prot_sqkm FROM a WHERE is_marine IS TRUE AND is_protected IS TRUE GROUP BY eco_id,cat),
feature_theme_stats AS (SELECT * FROM t_tot LEFT JOIN t_tot_prot USING(eco_id,cat) LEFT JOIN t_land USING(eco_id,cat) LEFT JOIN t_land_prot USING(eco_id,cat) LEFT JOIN t_marine USING(eco_id,cat) LEFT JOIN t_marine_prot USING(eco_id,cat)  ORDER BY eco_id,cat),
--ecoregion_stats
tot AS (SELECT eco_id,ROUND(SUM(sqkm::numeric),2) tot_sqkm FROM a GROUP BY eco_id),
tot_prot AS (SELECT eco_id,ROUND(SUM(sqkm::numeric),2) prot_sqkm FROM a WHERE is_protected IS TRUE GROUP BY eco_id),
land AS (SELECT eco_id,ROUND(SUM(sqkm::numeric),2) land_sqkm FROM a WHERE is_marine IS NOT TRUE GROUP BY eco_id),
land_prot AS (SELECT eco_id,ROUND(SUM(sqkm::numeric),2) land_prot_sqkm FROM a WHERE is_marine IS NOT TRUE AND is_protected IS TRUE GROUP BY eco_id),
marine AS (SELECT eco_id,ROUND(SUM(sqkm::numeric),2) marine_sqkm FROM a WHERE is_marine IS TRUE GROUP BY eco_id),
marine_prot AS (SELECT eco_id,ROUND(SUM(sqkm::numeric),2) marine_prot_sqkm FROM a WHERE is_marine IS TRUE AND is_protected IS TRUE GROUP BY eco_id),
feature_stats AS (SELECT * FROM tot LEFT JOIN tot_prot USING(eco_id) LEFT JOIN land USING(eco_id) LEFT JOIN land_prot USING(eco_id) LEFT JOIN marine USING(eco_id) LEFT JOIN marine_prot USING(eco_id))
SELECT * FROM feature_theme_stats JOIN feature_stats USING(eco_id); */
-----------------------------------------------------------------------------------------------------------------------------
-- PA PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pa_theme;CREATE TEMPORARY TABLE pa_theme AS
WITH
a AS (SELECT wdpaid ,cat,ROUND(SUM(sqkm::numeric),2) theme_sqkm FROM (SELECT pa wdpaid,qid,cid FROM pa_index) a NATURAL JOIN theme_sqkm GROUP BY wdpaid,cat),
b AS (SELECT wdpaid,ROUND(SUM(theme_sqkm::numeric),2) tot_sqkm FROM a GROUP BY wdpaid)
SELECT * FROM a JOIN b USING(wdpaid) ORDER BY wdpaid,theme_sqkm;
-----------------------------------------------------------------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- COUNTRY OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_lpd;
CREATE TABLE results_202601_cep_out.country_intermediate_lpd AS
SELECT * FROM country_theme;
/* -----------------------------------------------------------------------------------------------------------------------------
-- ECOREGION OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS :v_rcep_out.ecoregion_intermediate_:v_name;
CREATE TABLE :v_rcep_out.ecoregion_intermediate_:v_name AS
SELECT * FROM ecoregion_theme; */
-----------------------------------------------------------------------------------------------------------------------------
-- PA OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_lpd;
CREATE TABLE results_202601_cep_out.wdpa_intermediate_lpd AS
SELECT * FROM pa_theme;
