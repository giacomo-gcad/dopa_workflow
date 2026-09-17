-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS
SELECT * FROM results_202601_cep_in.r_stats_cep_gfc_lossyear_over30_202601;

--------------------------------------------------------------
-- PREPARE INDEXES FOR CURRENT VERSION;
DROP TABLE IF EXISTS country_index; CREATE TEMPORARY TABLE country_index AS
SELECT DISTINCT country_id,is_marine,is_protected,cid,SUM(sqkm) sqkm FROM cep_data_202601.cep_index 
WHERE country_id NOT IN (305,306) GROUP BY country_id,is_marine,is_protected,cid;
/* DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS
SELECT ecoregion,is_marine,is_protected,cid,SUM(sqkm) sqkm FROM results_202601_cep_in.index_ecoregion_cep_last GROUP BY ecoregion,is_marine,is_protected,cid;
 */
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS
SELECT a.pa,a.cid,b.marine,SUM(a.sqkm) sqkm 
FROM cep_data_202601.cep_index a RIGHT JOIN protected_sites.wdpa_wdoecm_202601 b ON a.pa=b.wdpaid
GROUP BY a.pa,a.cid,b.marine;
--AGGREGATE CIDS IN THEMATIC LAYER
DROP TABLE IF EXISTS cep_theme;CREATE TEMPORARY TABLE cep_theme AS
SELECT cid,cat,SUM(area_m2)/1000000 cat_sqkm
FROM theme GROUP BY cid,cat ORDER BY cid,cat;
--------------------------------------------
-- COUNTRY
--------------------------------------------
-- country_theme_aggregations
DROP TABLE IF EXISTS country_theme;CREATE TEMPORARY TABLE country_theme AS
WITH
country_cid_land AS (SELECT country_id,cid,sqkm FROM country_index WHERE is_marine IS NOT TRUE),
country_cid_land_prot AS (SELECT country_id,cid,sqkm FROM country_index WHERE is_marine IS NOT TRUE AND is_protected IS TRUE),
country_land AS (SELECT country_id,SUM(sqkm) tot_sqkm FROM country_cid_land GROUP BY country_id),
country_land_prot AS (SELECT country_id,SUM(sqkm) tot_prot_sqkm FROM country_cid_land_prot GROUP BY country_id),
country_land_tot_theme AS (SELECT country_id,cat,SUM(cat_sqkm) cat_sqkm FROM country_cid_land JOIN cep_theme USING(cid) GROUP BY country_id,cat),
country_land_prot_theme AS (SELECT country_id,cat,SUM(cat_sqkm) cat_prot_sqkm FROM country_cid_land_prot JOIN cep_theme USING(cid) GROUP BY country_id,cat),
country_land_tot_prot_theme AS (SELECT * FROM country_land_tot_theme LEFT JOIN country_land_prot_theme USING(country_id,cat))
SELECT *
FROM country_land 
LEFT JOIN country_land_prot USING(country_id)
LEFT JOIN country_land_tot_prot_theme USING(country_id)
ORDER BY country_id,cat;
--------------------------------------------------------------------------------------
-- country_change_in_forest_cover_loss
--------------------------------------------------------------------------------------
DROP TABLE IF EXISTS country_change_in_forest_cover_loss; CREATE TEMPORARY TABLE country_change_in_forest_cover_loss AS
WITH
a AS (SELECT country_id,tot_sqkm,tot_prot_sqkm,SUM(cat_sqkm) cat_sqkm,SUM(cat_prot_sqkm) cat_prot_sqkm FROM country_theme WHERE cat > 0 GROUP BY country_id,tot_sqkm,tot_prot_sqkm)
SELECT
country_id,
cat_sqkm gfc_loss_sqkm,
cat_prot_sqkm gfc_loss_prot_sqkm,
cat_sqkm/tot_sqkm*100 gfc_loss_perc_tot,
cat_prot_sqkm/tot_sqkm*100 gfc_loss_prot_perc_tot
FROM a;
/* --------------------------------------------
-- ECOREGION
--------------------------------------------
-- ecoregion_theme_aggregations
DROP TABLE IF EXISTS ecoregion_theme;CREATE TEMPORARY TABLE ecoregion_theme AS
WITH
ecoregion_cid_land AS (SELECT ecoregion,cid,sqkm FROM ecoregion_index WHERE is_marine IS NOT TRUE),
ecoregion_cid_land_prot AS (SELECT ecoregion,cid,sqkm FROM ecoregion_index WHERE is_marine IS NOT TRUE AND is_protected IS TRUE),
ecoregion_land AS (SELECT ecoregion,SUM(sqkm) tot_sqkm FROM ecoregion_cid_land GROUP BY ecoregion),
ecoregion_land_prot AS (SELECT ecoregion,SUM(sqkm) tot_prot_sqkm FROM ecoregion_cid_land_prot GROUP BY ecoregion),
ecoregion_land_tot_theme AS (SELECT ecoregion,cat,SUM(cat_sqkm) cat_sqkm FROM ecoregion_cid_land JOIN cep_theme USING(cid) GROUP BY ecoregion,cat),
ecoregion_land_prot_theme AS (SELECT ecoregion,cat,SUM(cat_sqkm) cat_prot_sqkm FROM ecoregion_cid_land_prot JOIN cep_theme USING(cid) GROUP BY ecoregion,cat),
ecoregion_land_tot_prot_theme AS (SELECT * FROM ecoregion_land_tot_theme LEFT JOIN ecoregion_land_prot_theme USING(ecoregion,cat))
SELECT *
FROM ecoregion_land 
LEFT JOIN ecoregion_land_prot USING(ecoregion)
LEFT JOIN ecoregion_land_tot_prot_theme USING(ecoregion)
ORDER BY ecoregion,cat;
--------------------------------------------------------------------------------------
-- ecoregion_change_in_forest_cover_loss
--------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ecoregion_change_in_forest_cover_loss; CREATE TEMPORARY TABLE ecoregion_change_in_forest_cover_loss AS
WITH
a AS (SELECT ecoregion,tot_sqkm,tot_prot_sqkm,SUM(cat_sqkm) cat_sqkm,SUM(cat_prot_sqkm) cat_prot_sqkm FROM ecoregion_theme WHERE cat > 0 GROUP BY ecoregion,tot_sqkm,tot_prot_sqkm)
SELECT
ecoregion eco_id,
cat_sqkm gfc_loss_sqkm,
cat_prot_sqkm gfc_loss_prot_sqkm,
cat_sqkm/tot_sqkm*100 gfc_loss_perc_tot,
cat_prot_sqkm/tot_sqkm*100 gfc_loss_prot_perc_tot
FROM a; */
--------------------------------------------
-- PROTECTION
--------------------------------------------
-- protection_theme_aggregations
DROP TABLE IF EXISTS protection_theme;CREATE TEMPORARY TABLE protection_theme AS
WITH
protection_cid_land AS (SELECT pa,cid,sqkm FROM pa_index WHERE marine IN (0,1)),
protection_land AS (SELECT pa,SUM(sqkm) tot_sqkm FROM protection_cid_land GROUP BY pa),
protection_land_theme AS (SELECT pa,cat,SUM(cat_sqkm) cat_sqkm FROM protection_cid_land JOIN cep_theme USING(cid) GROUP BY pa,cat)
SELECT *
FROM protection_land 
LEFT JOIN protection_land_theme USING(pa)
ORDER BY pa,cat;
--------------------------------------------------------------------------------------
-- protection_change_in_forest_cover_loss
--------------------------------------------------------------------------------------
DROP TABLE IF EXISTS protection_change_in_forest_cover_loss; CREATE TEMPORARY TABLE protection_change_in_forest_cover_loss AS
WITH
a AS (SELECT pa,tot_sqkm,SUM(cat_sqkm) cat_sqkm FROM protection_theme WHERE cat > 0 GROUP BY pa,tot_sqkm)
SELECT
pa wdpaid,
cat_sqkm gfc_loss_sqkm,
cat_sqkm/tot_sqkm*100 gfc_loss_perc_tot
FROM a;
--------------------------------------------
-- OUTPUT
--------------------------------------------
-- country
DROP TABLE IF EXISTS results_202601_cep_out.country_global_forest_cover_loss; CREATE TABLE results_202601_cep_out.country_global_forest_cover_loss AS
SELECT * FROM country_change_in_forest_cover_loss;
/* -- ecoregion
DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_global_forest_cover_loss; CREATE TABLE results_202601_cep_out.ecoregion_global_forest_cover_loss AS
SELECT * FROM ecoregion_change_in_forest_cover_loss;
 */-- protection
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_global_forest_cover_loss; CREATE TABLE results_202601_cep_out.wdpa_global_forest_cover_loss AS
SELECT * FROM protection_change_in_forest_cover_loss;

