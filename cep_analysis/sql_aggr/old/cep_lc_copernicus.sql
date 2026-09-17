-- in 247p
--CREATE TABLE results_202501_cep_in.index_cep AS SELECT * FROM cep_out.index_cep;

DROP TABLE IF EXISTS country_cid;CREATE TEMPORARY TABLE country_cid AS
SELECT DISTINCT cid,country_id,is_protected FROM results_202501_cep_in.index_cep
WHERE is_marine IS NULL AND country_id NOT IN (305,306) ORDER BY cid,country_id;

DROP TABLE IF EXISTS pa_cid;CREATE TEMPORARY TABLE pa_cid AS
SELECT DISTINCT cid,pa,is_protected FROM results_202501_cep_in.index_cep
WHERE is_protected IS TRUE ORDER BY cid,pa;

------------------------------------------------------------------
-- COUNTRY
DROP TABLE IF EXISTS lccop11_country;CREATE TEMPORARY TABLE lccop11_country AS
SELECT * FROM results_202501_cep_in.r_stats_cep_copernicus_lc_2019_202501 JOIN country_cid USING(cid) WHERE cat != 0;

DROP TABLE IF EXISTS lccop12_country;CREATE TEMPORARY TABLE lccop12_country AS --tot
SELECT country_id,cat,SUM(area_m2)/1000000 theme_tot_sqkm FROM lccop11_country GROUP BY country_id,cat ORDER BY country_id,cat;

DROP TABLE IF EXISTS lccop13_country;CREATE TEMPORARY TABLE lccop13_country AS --prot
SELECT country_id,cat,SUM(area_m2)/1000000 theme_prot_sqkm FROM lccop11_country WHERE is_protected IS TRUE GROUP BY country_id,cat ORDER BY country_id,cat;

DROP TABLE IF EXISTS lccop14_country;CREATE TEMPORARY TABLE lccop14_country AS --tot-prot
SELECT * FROM lccop12_country LEFT JOIN lccop13_country USING (country_id,cat);

-- PA
DROP TABLE IF EXISTS lccop11_pa;CREATE TEMPORARY TABLE lccop11_pa AS
SELECT * FROM results_202501_cep_in.r_stats_cep_copernicus_lc_2019_202501 JOIN pa_cid USING(cid) WHERE cat != 0;

DROP TABLE IF EXISTS lccop12_pa;CREATE TEMPORARY TABLE lccop12_pa AS --tot
SELECT pa,cat,SUM(area_m2)/1000000 theme_tot_sqkm FROM lccop11_pa GROUP BY pa,cat ORDER BY pa,cat;

------------------------------------------------------------------
-- GLOBAL
DROP TABLE IF EXISTS global_lccop;CREATE TEMPORARY TABLE global_lccop AS
SELECT *,ROUND((COALESCE(global_theme_prot_sqkm,0)/global_theme_tot_sqkm*100)::numeric,2) global_theme_prot_perc_tot FROM
(SELECT cat,SUM(theme_tot_sqkm) global_theme_tot_sqkm,SUM(theme_prot_sqkm) global_theme_prot_sqkm FROM lccop14_country GROUP BY cat) a
ORDER BY cat;
-- COUNTRY
DROP TABLE IF EXISTS country_lccop;CREATE TEMPORARY TABLE country_lccop AS
SELECT *,ROUND((COALESCE(country_theme_prot_sqkm,0)/country_theme_tot_sqkm*100)::numeric,2) country_theme_prot_perc_tot FROM
(SELECT country_id,cat,SUM(theme_tot_sqkm) country_theme_tot_sqkm,SUM(theme_prot_sqkm) country_theme_prot_sqkm FROM lccop14_country GROUP BY country_id,cat) a
ORDER BY country_id,cat;
-- PA
DROP TABLE IF EXISTS pa_lccop;CREATE TEMPORARY TABLE pa_lccop AS
SELECT * FROM
(SELECT pa,cat,SUM(theme_tot_sqkm) pa_theme_tot_sqkm FROM lccop12_pa GROUP BY pa,cat) a
ORDER BY pa,cat;

-- WRITE RESULTS
-- GLOBAL
DROP TABLE IF EXISTS results_202501_cep_out.global_lc_copernicus;CREATE  TABLE results_202501_cep_out.global_lc_copernicus AS
SELECT cat lc_code,global_theme_tot_sqkm global_lc_code_tot_sqkm,global_theme_prot_sqkm global_lc_code_prot_sqkm, global_theme_prot_perc_tot global_lc_code_prot_perc_tot
FROM global_lccop ORDER BY cat;
--SELECT * FROM results_202501_cep_out.global_lc_copernicus;
-- COUNTRY
DROP TABLE IF EXISTS results_202501_cep_out.country_lc_copernicus;CREATE  TABLE results_202501_cep_out.country_lc_copernicus AS
SELECT country_id,cat lc_code,country_theme_tot_sqkm country_lc_code_tot_sqkm,country_theme_prot_sqkm country_lc_code_prot_sqkm, country_theme_prot_perc_tot country_lc_code_prot_perc_tot
FROM country_lccop ORDER BY cat;
--SELECT * FROM results_202501_cep_out.country_lc_copernicus;
-- PA
DROP TABLE IF EXISTS results_202501_cep_out.wdpa_lc_copernicus;CREATE  TABLE results_202501_cep_out.wdpa_lc_copernicus AS
SELECT pa,cat lc_code,pa_theme_tot_sqkm pa_lc_code_tot_sqkm
FROM pa_lccop ORDER BY pa,cat;
--SELECT * FROM results_202501_cep_out.wdpa_lc_copernicus;
