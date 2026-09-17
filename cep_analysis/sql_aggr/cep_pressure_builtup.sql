-- reports by land only
-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_univar_cep_builtup2020_202601;
-- SELECT THE GRID;
DROP TABLE IF EXISTS grid_index; CREATE TEMPORARY TABLE grid_index AS SELECT qid,eid FROM results_202601_cep_in.grid_vector ORDER BY qid,eid;
-- SELECT THE AREA;
DROP TABLE IF EXISTS area_index; CREATE TEMPORARY TABLE area_index AS SELECT qid,cid,area_m2 FROM results_202601_cep_in.cid_area_cep_built2020_202601 ORDER BY qid,cid;

DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS 
SELECT a.pa,a.pa_name,a.country_uri iso3,a.qid,a.cid,b.marine,SUM(a.sqkm) sqkm 
FROM cep_data_202601.cep_index a RIGHT JOIN protected_sites.wdpa_wdoecm_202601 b ON a.pa=b.wdpaid JOIN grid_index USING (qid) 
GROUP BY a.pa,a.pa_name,a.country_uri,a.qid,a.cid,b.marine;


-- PROTECTION
DROP TABLE IF EXISTS pa_land; CREATE TEMPORARY TABLE pa_land AS
WITH
a AS (SELECT DISTINCT pa,pa_name,iso3,qid,cid FROM pa_index WHERE marine IN (0,1)),
b AS (SELECT qid,cid,min,max,mean,sum FROM theme),
c AS (SELECT qid,cid,area_m2 FROM area_index)
SELECT pa,MIN(min),MAX(max),SUM(mean*area_m2)/SUM(area_m2) mean,(SUM(sum))/1000000 sum, SUM(sum)/SUM(c.area_m2)*100 perc
FROM a JOIN b USING(qid,cid) JOIN c USING(qid,cid) GROUP BY pa ORDER BY pa;

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------

-- pa
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_pressure_builtup_pa
CREATE TABLE results_202601_cep_out.wdpa_pressure_builtup_pa AS
SELECT pa wdpaid,sum p_builtup_pa_sqkm, perc p_builtup_pa_perc_land
FROM pa_land;
