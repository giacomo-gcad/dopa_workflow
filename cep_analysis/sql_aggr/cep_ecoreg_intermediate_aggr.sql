-----------------------------------------------------------------------------------------------------------------------------
-- INPUTS
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.r_stats_cep_ecoreg_202601;
DROP TABLE IF EXISTS country_index;CREATE TEMPORARY TABLE country_index AS SELECT * FROM cep_data_202601.cep_index;
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS SELECT * FROM cep_data_202601.cep_index;

-----------------------------------------------------------------------------------------------------------------------------
-- PRE-PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS theme_sqkm; CREATE TABLE theme_sqkm AS SELECT qid,cid,cat,area_m2/1000000 sqkm FROM theme;
-----------------------------------------------------------------------------------------------------------------------------
-- PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- COUNTRY PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS country_theme;CREATE TEMPORARY TABLE country_theme AS
WITH
a AS (SELECT * FROM (SELECT country_id,is_marine,is_protected,qid,cid FROM country_index) a NATURAL JOIN theme_sqkm),
--theme_stats
t_tot AS (SELECT country_id,cat,SUM(sqkm) theme_tot_sqkm FROM a GROUP BY country_id,cat),
t_tot_prot AS (SELECT country_id,cat,SUM(sqkm) theme_prot_sqkm FROM a WHERE is_protected IS TRUE GROUP BY country_id,cat),
t_land AS (SELECT country_id,cat,SUM(sqkm) theme_land_sqkm FROM a WHERE is_marine IS FALSE GROUP BY country_id,cat),
t_land_prot AS (SELECT country_id,cat,SUM(sqkm) theme_land_prot_sqkm FROM a WHERE is_marine IS FALSE AND is_protected IS TRUE GROUP BY country_id,cat),
t_marine AS (SELECT country_id,cat,SUM(sqkm) theme_marine_sqkm FROM a WHERE is_marine IS TRUE GROUP BY country_id,cat),
t_marine_prot AS (SELECT country_id,cat,SUM(sqkm) theme_marine_prot_sqkm FROM a WHERE is_marine IS TRUE AND is_protected IS TRUE GROUP BY country_id,cat),
feature_theme_stats AS (SELECT * FROM t_tot LEFT JOIN t_tot_prot USING(country_id,cat) LEFT JOIN t_land USING(country_id,cat) LEFT JOIN t_land_prot USING(country_id,cat) LEFT JOIN t_marine USING(country_id,cat) LEFT JOIN t_marine_prot USING(country_id,cat)  ORDER BY country_id,cat),
--country_stats
tot AS (SELECT country_id,SUM(sqkm) tot_sqkm FROM a GROUP BY country_id),
tot_prot AS (SELECT country_id,SUM(sqkm) prot_sqkm FROM a WHERE is_protected IS TRUE GROUP BY country_id),
land AS (SELECT country_id,SUM(sqkm) land_sqkm FROM a WHERE is_marine IS FALSE GROUP BY country_id),
land_prot AS (SELECT country_id,SUM(sqkm) land_prot_sqkm FROM a WHERE is_marine IS FALSE AND is_protected IS TRUE GROUP BY country_id),
marine AS (SELECT country_id,SUM(sqkm) marine_sqkm FROM a WHERE is_marine IS TRUE GROUP BY country_id),
marine_prot AS (SELECT country_id,SUM(sqkm) marine_prot_sqkm FROM a WHERE is_marine IS TRUE AND is_protected IS TRUE GROUP BY country_id),
feature_stats AS (SELECT * FROM tot LEFT JOIN tot_prot USING(country_id) LEFT JOIN land USING(country_id) LEFT JOIN land_prot USING(country_id) LEFT JOIN marine USING(country_id) LEFT JOIN marine_prot USING(country_id))
SELECT * FROM feature_theme_stats JOIN feature_stats USING(country_id);

-----------------------------------------------------------------------------------------------------------------------------
-- PA PROCESSING
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pa_theme;CREATE TEMPORARY TABLE pa_theme AS
WITH
a AS (SELECT wdpaid ,cat,SUM(sqkm) theme_sqkm FROM (SELECT pa wdpaid,qid,cid FROM pa_index) a NATURAL JOIN theme_sqkm GROUP BY wdpaid,cat),
b AS (SELECT wdpaid,SUM(theme_sqkm) tot_sqkm FROM a GROUP BY wdpaid)
SELECT * FROM a JOIN b USING(wdpaid) ORDER BY wdpaid,theme_sqkm;
-----------------------------------------------------------------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- COUNTRY OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_ecoreg;
CREATE TABLE results_202601_cep_out.country_intermediate_ecoreg AS
SELECT * FROM country_theme;
-----------------------------------------------------------------------------------------------------------------------------
-- PA OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_ecoreg;
CREATE TABLE results_202601_cep_out.wdpa_intermediate_ecoreg AS
SELECT * FROM pa_theme;
