-----------------------------------------------------------------------------------------------------------------------------
-- INPUTS
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_stats_pabu_copernicus_lc_2019_202601;
DROP TABLE IF EXISTS bu_index; CREATE TEMPORARY TABLE bu_index AS SELECT * FROM cep_data_202601.index_pa_buffers;

-----------------------------------------------------------------------------------------------------------------------------
-- PRE-PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme_sqkm; CREATE TEMPORARY TABLE theme_sqkm AS SELECT qid,cid,cat,area_m2/1000000 sqkm FROM theme;

-----------------------------------------------------------------------------------------------------------------------------
-- PA PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS bu_theme;CREATE TEMPORARY TABLE bu_theme AS
WITH
a AS (SELECT wdpaid ,cat,SUM(sqkm) theme_sqkm FROM (SELECT pa wdpaid,qid,cid FROM bu_index) a NATURAL JOIN theme_sqkm GROUP BY wdpaid,cat),
b AS (SELECT wdpaid,SUM(theme_sqkm) tot_sqkm FROM a GROUP BY wdpaid)
SELECT * FROM a JOIN b USING(wdpaid) ORDER BY wdpaid,theme_sqkm;

-----------------------------------------------------------------------------------------------------------------------------
-- PA OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_pressure_agriculture_bu;CREATE TABLE results_202601_cep_out.wdpa_pressure_agriculture_bu AS
SELECT wdpaid,(theme_sqkm/tot_sqkm*100) p_agriculture_bu_perc_tot
FROM bu_theme WHERE cat=40;






