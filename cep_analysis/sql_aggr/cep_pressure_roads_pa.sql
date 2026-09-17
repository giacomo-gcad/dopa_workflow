-----------------------------------------------------------------------------------------------------------------------------
-- INPUTS
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_stats_cep_groads_202601;
--DROP TABLE IF EXISTS country_index;CREATE TEMPORARY TABLE country_index AS SELECT * FROM cep_data_202601.cep_index;
--DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM cep_data_202601.cep_index;
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS SELECT * FROM cep_data_202601.cep_index;

-----------------------------------------------------------------------------------------------------------------------------
-- PRE-PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme_sqkm; CREATE TABLE theme_sqkm AS SELECT qid,cid,cat,area_m2/1000000 sqkm FROM theme;
-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS pa_theme;CREATE TEMPORARY TABLE pa_theme AS
WITH
a AS (SELECT wdpaid ,cat,SUM(sqkm) theme_sqkm FROM (SELECT pa wdpaid,qid,cid FROM pa_index) a NATURAL JOIN theme_sqkm GROUP BY wdpaid,cat),
b AS (SELECT wdpaid,SUM(theme_sqkm) tot_sqkm FROM a GROUP BY wdpaid)
SELECT * FROM a JOIN b USING(wdpaid) ORDER BY wdpaid,theme_sqkm;


-----------------------------------------------------------------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------------------------------------------------------------
-- PA 

DROP TABLE IF EXISTS results_202601_cep_out.wdpa_pressure_roads_pa;CREATE TABLE results_202601_cep_out.wdpa_pressure_roads_pa AS
WITH
finput AS (SELECT DISTINCT pa wdpaid FROM cep_data_202601.cep_index WHERE is_marine IS FALSE AND pa !=0 ORDER BY pa),
land_ext AS(SELECT wdpaid,SUM(theme_sqkm) land_sqkm FROM results_202601_cep_out.wdpa_intermediate_p_roads GROUP BY wdpaid ORDER BY wdpaid),
cats AS (SELECT wdpaid,SUM(theme_sqkm) theme_sqkm FROM results_202601_cep_out.wdpa_intermediate_p_roads WHERE cat IN (100) GROUP BY wdpaid ORDER BY wdpaid),
all_cats AS (SELECT * FROM finput LEFT JOIN land_ext USING(wdpaid) LEFT JOIN cats USING(wdpaid) ORDER BY wdpaid)

SELECT wdpaid,
COALESCE(ROUND((theme_sqkm/land_sqkm*100)::numeric,2),0) p_road_pa_perc_tot
FROM all_cats ORDER BY wdpaid;
