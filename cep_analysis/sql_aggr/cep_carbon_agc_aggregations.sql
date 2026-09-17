-- reports by land only
-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_univar_cep_agc2022_100m_202601;
-- SELECT THE GRID;
DROP TABLE IF EXISTS grid_index; CREATE TEMPORARY TABLE grid_index AS SELECT qid,eid FROM results_202601_cep_in.grid_vector ORDER BY qid,eid;
-- SELECT THE AREA;
DROP TABLE IF EXISTS area_index; CREATE TEMPORARY TABLE area_index AS SELECT eid,qid,cid,area_m2 FROM results_202601_cep_in.cid_area_by_tile ORDER BY eid,qid,cid;

------------------------------------------------------------
DROP TABLE IF EXISTS country_index; CREATE TEMPORARY TABLE country_index AS 
SELECT DISTINCT country_id,country_uri iso3,country_name name_eng,eid,qid,cid,is_marine,is_protected,sqkm FROM cep_data_202601.cep_index JOIN grid_index USING (qid)
WHERE is_marine IS NOT TRUE  GROUP BY country_id,country_uri,country_name,eid,qid,cid,is_marine,is_protected,sqkm;

-- DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM results_202601_cep_in.index_ecoregion_cep_last JOIN grid_index USING (qid);

DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS 
SELECT a.pa,a.pa_name,a.country_uri iso3,a.qid,a.cid,b.marine,SUM(a.sqkm) sqkm 
FROM cep_data_202601.cep_index a RIGHT JOIN protected_sites.wdpa_wdoecm_202601 b ON a.pa=b.wdpaid JOIN grid_index USING (qid) 
GROUP BY a.pa,a.pa_name,a.country_uri,a.qid,a.cid,b.marine;

------------------------------------------------------------------
-- COUNTRY
DROP TABLE IF EXISTS country_land; CREATE TEMPORARY TABLE country_land AS
WITH
a AS (SELECT DISTINCT country_id,name_eng,iso3,eid,cid FROM country_index WHERE is_marine IS NOT TRUE),
b AS (SELECT eid,cid,min,max,mean,sum FROM theme),
c AS (SELECT eid,cid,area_m2 FROM area_index)
SELECT country_id,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(eid,cid) JOIN c USING(eid,cid) GROUP BY country_id ORDER BY country_id;

DROP TABLE IF EXISTS country_land_prot; CREATE TEMPORARY TABLE country_land_prot AS
WITH
a AS (SELECT DISTINCT country_id,name_eng,iso3,eid,cid FROM country_index WHERE is_marine IS NOT TRUE AND is_protected IS TRUE),
b AS (SELECT eid,cid,min,max,mean,sum FROM theme),
c AS (SELECT eid,cid,area_m2 FROM area_index)
SELECT country_id,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(eid,cid) JOIN c USING(eid,cid) GROUP BY country_id ORDER BY country_id;

DROP TABLE IF EXISTS country_land_unprot; CREATE TEMPORARY TABLE country_land_unprot AS
WITH
a AS (SELECT DISTINCT country_id,name_eng,iso3,eid,cid FROM country_index WHERE is_marine IS NOT TRUE AND is_protected IS FALSE),
b AS (SELECT eid,cid,min,max,mean,sum FROM theme),
c AS (SELECT eid,cid,area_m2 FROM area_index)
SELECT country_id,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(eid,cid) JOIN c USING(eid,cid) GROUP BY country_id ORDER BY country_id;

/* ----------------------------------------
-- ECOREGION
DROP TABLE IF EXISTS eco_land; CREATE TEMPORARY TABLE eco_land AS
WITH
a AS (SELECT DISTINCT ecoregion,ecoregion_name,qid,cid FROM ecoregion_index WHERE is_marine IS FALSE),
b AS (SELECT qid,cid,min,max,mean,sum FROM theme),
c AS (SELECT qid,cid,area_m2 FROM area_index)
SELECT ecoregion,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(qid,cid) JOIN c USING(qid,cid) GROUP BY ecoregion ORDER BY ecoregion;

DROP TABLE IF EXISTS eco_land_prot; CREATE TEMPORARY TABLE eco_land_prot AS
WITH
a AS (SELECT DISTINCT ecoregion,ecoregion_name,qid,cid FROM ecoregion_index WHERE is_marine IS NOT TRUE AND is_protected IS TRUE),
b AS (SELECT qid,cid,min,max,mean,sum FROM theme),
c AS (SELECT qid,cid,area_m2 FROM area_index)
SELECT ecoregion,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(qid,cid) JOIN c USING(qid,cid) GROUP BY ecoregion ORDER BY ecoregion;

DROP TABLE IF EXISTS eco_land_unprot; CREATE TEMPORARY TABLE eco_land_unprot AS
WITH
a AS (SELECT DISTINCT ecoregion,ecoregion_name,qid,cid FROM ecoregion_index WHERE is_marine IS NOT TRUE AND is_protected IS FALSE),
b AS (SELECT qid,cid,min,max,mean,sum FROM theme),
c AS (SELECT qid,cid,area_m2 FROM area_index)
SELECT ecoregion,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(qid,cid) JOIN c USING(qid,cid) GROUP BY ecoregion ORDER BY ecoregion;
 */
----------------------------------------
-- PROTECTION
DROP TABLE IF EXISTS pa_land; CREATE TEMPORARY TABLE pa_land AS
WITH
a AS (SELECT DISTINCT pa,pa_name,iso3,qid,cid FROM pa_index WHERE marine IN (0,1)),
b AS (SELECT qid,cid,min,max,mean,sum FROM theme),
c AS (SELECT qid,cid,area_m2 FROM area_index)
SELECT pa,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,SUM(sum) sum FROM a JOIN b USING(qid,cid) JOIN c USING(qid,cid) GROUP BY pa ORDER BY pa;

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
-- country
DROP TABLE IF EXISTS results_202601_cep_out.country_carbon_above_ground;
CREATE TABLE results_202601_cep_out.country_carbon_above_ground AS
SELECT
a.country_id,a.min agb_min_c_mg_total,a.max agb_max_c_mg_total,a.mean agb_mean_c_mg_total,a.sum/1000000000 agb_tot_c_pg_total,
b.min agb_min_c_mg_prot,b.max agb_max_c_mg_prot,b.mean agb_mean_c_mg_prot,b.sum/1000000000 agb_tot_c_pg_prot,
c.min agb_min_c_mg_unprot,c.max agb_max_c_mg_unprot,c.mean agb_mean_c_mg_unprot,c.sum/1000000000 agb_tot_c_pg_unprot
FROM country_land a 
LEFT JOIN country_land_prot b USING(country_id)
LEFT JOIN country_land_unprot c USING(country_id);
/* -- ecoregion
DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_carbon_above_ground;
CREATE TABLE results_202601_cep_out.ecoregion_carbon_above_ground AS
SELECT
a.ecoregion eco_id,a.min agb_min_c_mg_total,a.max agb_max_c_mg_total,a.mean agb_mean_c_mg_total,a.sum/1000000000 agb_tot_c_pg_total,
b.min agb_min_c_mg_prot,b.max agb_max_c_mg_prot,b.mean agb_mean_c_mg_prot,b.sum/1000000000 agb_tot_c_pg_prot,
c.min agb_min_c_mg_unprot,c.max agb_max_c_mg_unprot,c.mean agb_mean_c_mg_unprot,c.sum/1000000000 agb_tot_c_pg_unprot
FROM eco_land a 
LEFT JOIN eco_land_prot b USING(ecoregion)
LEFT JOIN eco_land_unprot c USING(ecoregion); */
-- pa
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_carbon_above_ground;
CREATE TABLE results_202601_cep_out.wdpa_carbon_above_ground AS
SELECT pa wdpaid,min agb_min_c_mg,max agb_max_c_mg,mean agb_mean_c_mg,sum agb_tot_c_mg FROM pa_land;
