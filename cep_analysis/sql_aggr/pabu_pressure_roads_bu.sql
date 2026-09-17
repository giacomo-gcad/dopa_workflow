-----------------------------------------------------------------------------------------------------------------------------
-- INPUTS
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_stats_pabu_groads_202601;
--DROP TABLE IF EXISTS country_index;CREATE TEMPORARY TABLE country_index AS SELECT * FROM cep_data_202601.cep_index;
--DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM cep_data_202601.cep_index;
DROP TABLE IF EXISTS bu_index; CREATE TEMPORARY TABLE bu_index AS SELECT * FROM cep_data_202601.index_pa_buffers;

-----------------------------------------------------------------------------------------------------------------------------
-- PRE-PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme_sqkm; CREATE TABLE theme_sqkm AS SELECT qid,cid,cat,area_m2/1000000 sqkm FROM theme;
-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS wdpa_intermediate_bu_roads; CREATE TEMPORARY TABLE wdpa_intermediate_bu_roads AS
WITH
a AS (SELECT wdpaid ,cat,SUM(sqkm) theme_sqkm FROM (SELECT pa wdpaid,qid,cid FROM bu_index) a NATURAL JOIN theme_sqkm GROUP BY wdpaid,cat),
b AS (SELECT wdpaid,SUM(theme_sqkm) tot_sqkm FROM a GROUP BY wdpaid)
SELECT * FROM a JOIN b USING(wdpaid) ORDER BY wdpaid,theme_sqkm; 

-----------------------------------------------------------------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------------------------------------------------------------
-- PA 

DROP TABLE IF EXISTS results_202601_cep_out.wdpa_pressure_roads_bu;CREATE TABLE results_202601_cep_out.wdpa_pressure_roads_bu AS
WITH
finput AS (SELECT DISTINCT pa wdpaid FROM bu_index WHERE pa !=0 ORDER BY pa),
land_ext AS(SELECT wdpaid,SUM(theme_sqkm) land_sqkm FROM wdpa_intermediate_bu_roads GROUP BY wdpaid ORDER BY wdpaid),
cats AS (SELECT wdpaid,SUM(theme_sqkm) theme_sqkm FROM wdpa_intermediate_bu_roads WHERE cat IN (100) GROUP BY wdpaid ORDER BY wdpaid),
all_cats AS (SELECT * FROM finput LEFT JOIN land_ext USING(wdpaid) LEFT JOIN cats USING(wdpaid) ORDER BY wdpaid)

SELECT wdpaid,
COALESCE(ROUND((theme_sqkm/land_sqkm*100)::numeric,2),0) p_road_pa_perc_tot
FROM all_cats ORDER BY wdpaid;
