-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_univar_cep_gfc_treecover_over30_202601;
-- SELECT THE GRID;
DROP TABLE IF EXISTS grid_index; CREATE TEMPORARY TABLE grid_index AS SELECT qid,eid FROM results_202601_cep_in.grid_vector ORDER BY qid,eid;
------------------------------------------------------------
DROP TABLE IF EXISTS country_index; CREATE TEMPORARY TABLE country_index AS 
SELECT DISTINCT country_id,qid,cid,is_marine,is_protected,sqkm FROM cep_data_202601.cep_index JOIN grid_index USING (qid)
WHERE is_marine IS NOT TRUE AND country_id NOT IN (305,306)
GROUP BY country_id,qid,cid,is_marine,is_protected,sqkm;

-- DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM results_202601_cep_in.index_ecoregion_cep_last JOIN grid_index USING (qid);

DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS 
SELECT a.pa,a.qid,a.cid,b.marine,SUM(a.sqkm) sqkm 
FROM cep_data_202601.cep_index a RIGHT JOIN protected_sites.wdpa_wdoecm_202601 b ON a.pa=b.wdpaid JOIN grid_index USING (qid) 
GROUP BY a.pa,a.qid,a.cid,b.marine;

------------------------------------------------------------------
-- COUNTRY
DROP TABLE IF EXISTS country_land; CREATE TEMPORARY TABLE country_land AS
WITH
a AS (SELECT country_id,qid,cid,SUM(sqkm) country_land_sqkm FROM country_index WHERE is_marine IS NOT TRUE GROUP BY country_id,qid,cid),
b AS (SELECT country_id,a.qid,a.cid,a.country_land_sqkm,b.mean FROM a JOIN theme b USING(qid,cid))
SELECT country_id,SUM(country_land_sqkm)country_land_sqkm,SUM(country_land_sqkm*mean/100) theme_land_sqkm FROM b GROUP BY country_id ORDER BY country_id;

DROP TABLE IF EXISTS country_land_prot; CREATE TEMPORARY TABLE country_land_prot AS
WITH
a AS (SELECT country_id,qid,cid,SUM(sqkm) country_land_prot_sqkm FROM country_index WHERE is_marine IS NOT TRUE AND is_protected IS TRUE GROUP BY country_id,qid,cid),
b AS (SELECT country_id,a.qid,a.cid,a.country_land_prot_sqkm,b.mean FROM a JOIN theme b USING(qid,cid))
SELECT country_id,SUM(country_land_prot_sqkm)country_land_prot_sqkm,SUM(country_land_prot_sqkm*mean/100) theme_land_prot_sqkm FROM b GROUP BY country_id ORDER BY country_id;

DROP TABLE IF EXISTS country_indicator; CREATE TEMPORARY TABLE country_indicator AS
SELECT
country_id,
theme_land_sqkm,
(theme_land_sqkm/country_land_sqkm*100) theme_land_perc_country_land,
theme_land_prot_sqkm,
(theme_land_prot_sqkm/country_land_sqkm*100) theme_land_prot_perc_country_land,
(theme_land_prot_sqkm/country_land_prot_sqkm*100) theme_land_prot_perc_country_land_prot,
(theme_land_prot_sqkm/NULLIF(theme_land_sqkm,0)*100) theme_land_prot_perc_theme_land
FROM country_land LEFT JOIN country_land_prot USING(country_id) ORDER BY country_id;

/* ----------------------------------------
-- ECOREGION
DROP TABLE IF EXISTS eco_land; CREATE TEMPORARY TABLE eco_land AS
WITH
a AS (SELECT ecoregion,qid,cid,SUM(sqkm) ecoregion_land_sqkm FROM ecoregion_index WHERE is_marine IS FALSE GROUP BY ecoregion,qid,cid),
b AS (SELECT ecoregion,a.qid,a.cid,a.ecoregion_land_sqkm,b.mean FROM a JOIN theme b USING(qid,cid))
SELECT ecoregion,SUM(ecoregion_land_sqkm)ecoregion_land_sqkm,SUM(ecoregion_land_sqkm*mean/100) theme_land_sqkm FROM b GROUP BY ecoregion ORDER BY ecoregion;

DROP TABLE IF EXISTS eco_land_prot; CREATE TEMPORARY TABLE eco_land_prot AS
WITH
a AS (SELECT ecoregion,qid,cid,SUM(sqkm) ecoregion_land_sqkm FROM ecoregion_index WHERE is_marine IS FALSE AND is_protected = TRUE GROUP BY ecoregion,qid,cid),
b AS (SELECT ecoregion,a.qid,a.cid,a.ecoregion_land_sqkm,b.mean FROM a JOIN theme b USING(qid,cid))
SELECT ecoregion,SUM(ecoregion_land_sqkm)ecoregion_land_prot_sqkm,SUM(ecoregion_land_sqkm*mean/100) theme_land_prot_sqkm FROM b GROUP BY ecoregion ORDER BY ecoregion;

DROP TABLE IF EXISTS ecoregion_indicator; CREATE TEMPORARY TABLE ecoregion_indicator AS
SELECT
ecoregion,
theme_land_sqkm,
(theme_land_sqkm/ecoregion_land_sqkm*100) theme_land_perc_ecoregion_land,
theme_land_prot_sqkm,
(theme_land_prot_sqkm/ecoregion_land_sqkm*100) theme_land_prot_perc_ecoregion_land,
(theme_land_prot_sqkm/ecoregion_land_prot_sqkm*100) theme_land_prot_perc_ecoregion_land_prot,
(theme_land_prot_sqkm/NULLIF(theme_land_sqkm,0)*100) theme_land_prot_perc_theme_land
FROM eco_land LEFT JOIN eco_land_prot USING(ecoregion) ORDER BY ecoregion;

 */----------------------------------------
-- PROTECTION
DROP TABLE IF EXISTS pa_land; CREATE TEMPORARY TABLE pa_land AS
WITH
a AS (SELECT pa,qid,cid,SUM(sqkm) pa_land_sqkm FROM pa_index WHERE marine IN (0,1) GROUP BY pa,qid,cid),
b AS (SELECT pa,a.qid,a.cid,a.pa_land_sqkm,b.mean FROM a JOIN theme b USING(qid,cid)),
c AS (SELECT pa,SUM(pa_land_sqkm)pa_land_sqkm,SUM(pa_land_sqkm*mean/100) theme_land_sqkm FROM b GROUP BY pa ORDER BY pa)
SELECT pa,theme_land_sqkm,(theme_land_sqkm/pa_land_sqkm*100) theme_land_perc_pa_land FROM c;

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
-- country
DROP TABLE IF EXISTS results_202601_cep_out.country_global_forest_cover_treecover;
CREATE TABLE results_202601_cep_out.country_global_forest_cover_treecover AS
SELECT
country_id,
theme_land_sqkm gfc_treecover_land_sqkm,
theme_land_perc_country_land gfc_treecover_land_perc_country_land,
theme_land_prot_sqkm gfc_treecover_land_prot_sqkm,
theme_land_prot_perc_country_land gfc_treecover_land_prot_perc_country_land,
theme_land_prot_perc_country_land_prot gfc_treecover_land_prot_perc_country_land_prot,
theme_land_prot_perc_theme_land gfc_treecover_land_prot_perc_gfc_treecover_land
FROM country_indicator a;
/* -- ecoregion
DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_global_forest_cover_treecover;
CREATE TABLE results_202601_cep_out.ecoregion_global_forest_cover_treecover AS
SELECT
ecoregion eco_id,
theme_land_sqkm gfc_treecover_land_sqkm,
theme_land_perc_ecoregion_land gfc_treecover_land_perc_ecoregion_land,
theme_land_prot_sqkm gfc_treecover_land_prot_sqkm,
theme_land_prot_perc_ecoregion_land gfc_treecover_land_prot_perc_ecoregion_land,
theme_land_prot_perc_ecoregion_land_prot gfc_treecover_land_prot_perc_ecoregion_land_prot,
theme_land_prot_perc_theme_land gfc_treecover_land_prot_perc_gfc_treecover_land
FROM ecoregion_indicator a; */
-- pa
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_global_forest_cover_treecover;
CREATE TABLE results_202601_cep_out.wdpa_global_forest_cover_treecover AS
SELECT
pa wdpaid,
theme_land_sqkm gfc_treecover_land_sqkm,
theme_land_perc_pa_land gfc_treecover_land_perc_pa_land
FROM pa_land;



