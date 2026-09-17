-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_univar_pabu_builtup2020_202601;
------------------------------------------------------------
DROP TABLE IF EXISTS country_index; CREATE TEMPORARY TABLE country_index AS SELECT * FROM cep_data_202601.cep_index;
--DROP TABLE IF EXISTS ecoregion_index; CREATE TEMPORARY TABLE ecoregion_index AS SELECT * FROM cep_data_202601.cep_index;
DROP TABLE IF EXISTS bu_index; CREATE TEMPORARY TABLE bu_index AS SELECT * FROM cep_data_202601.index_pa_buffers;

 
-- PROTECTION
--\set vtab 'pa'
DROP TABLE IF EXISTS pa;CREATE TEMPORARY TABLE pa AS
WITH qqq AS (SELECT qid,cid,sum/1000000 built_sqkm FROM theme)
SELECT a.pa wdpaid,SUM(a.sqkm) bu_area_sqkm, SUM(b.built_sqkm) built_sqkm
FROM (SELECT DISTINCT pa,qid,cid,sqkm FROM bu_index)a
JOIN qqq b USING(qid,cid)
GROUP BY pa ORDER BY pa;

DROP TABLE IF EXISTS results_202601_cep_out.wdpa_pressure_builtup_bu;CREATE TABLE results_202601_cep_out.wdpa_pressure_builtup_bu AS
SELECT wdpaid, built_sqkm p_builtup_bu_sqkm, built_sqkm/bu_area_sqkm*100 p_builtup_bu_perc_land 
