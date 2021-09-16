DROP TABLE IF EXISTS cep_202003;
CREATE TEMPORARY TABLE cep_202003 AS
SELECT cid,country,ecoregion eco,wdpa pa,SUM(sqkm) sqkm FROM cep202003_delli_raster.h_flat GROUP BY cid,country,eco,pa ORDER BY cid;

DROP TABLE IF EXISTS cep_202003_lc_2018;
CREATE TEMPORARY TABLE cep_202003_lc_2018 AS
SELECT cid,cat,SUM(area_m2)/1000000 sqkm
FROM results_202003.r_stats_cep_esalc_2018_temp
GROUP BY cid,cat
ORDER BY cid,cat;

DROP TABLE IF EXISTS cep_202003_country;
CREATE TEMPORARY TABLE cep_202003_country AS
SELECT DISTINCT cid,country FROM cep_202003 ORDER BY cid,country;

DROP TABLE IF EXISTS cep_202003_country_prot;
CREATE TEMPORARY TABLE cep_202003_country_prot AS
SELECT DISTINCT cid,country FROM cep_202003 WHERE 0 != ANY(pa) ORDER BY cid,country;

DROP TABLE IF EXISTS cep_202003_country_lc_2018;
CREATE TEMPORARY TABLE cep_202003_country_lc_2018 AS
WITH
a as  (SELECT * FROM cep_202003_country a JOIN cep_202003_lc_2018 b USING(cid)),
b AS (SELECT UNNEST(country) country,cat,sqkm FROM a ORDER BY country,cat),
c AS (SELECT country,cat,SUM(sqkm) sqkm FROM b GROUP BY country,cat)
SELECT * FROM c  ORDER BY country,cat;

DROP TABLE IF EXISTS cep_202003_country_lc_2018_prot;
CREATE TEMPORARY TABLE cep_202003_country_lc_2018_prot AS
WITH
a as  (SELECT * FROM cep_202003_country_prot a JOIN cep_202003_lc_2018 b USING(cid)),
b AS (SELECT UNNEST(country) country,cat,sqkm FROM a ORDER BY country,cat),
c AS (SELECT country,cat,SUM(sqkm) prot_sqkm FROM b GROUP BY country,cat)
SELECT * FROM c  ORDER BY country,cat;

WITH
a AS (SELECT * FROM cep_202003_country_lc_2018 a LEFT JOIN cep_202003_country_lc_2018_prot b USING(country,cat)),
b AS (SELECT *,ROUND(((prot_sqkm/sqkm)*100)::numeric,2) perc_prot FROM a  ORDER BY country,cat),
c AS(SELECT country_id country,country_name,iso3,sqkm tot_sqkm FROM administrative_units.gaul_eez_dissolved_201912 WHERE country_id IN (21,127,233,251)),
d AS (SELECT country,SUM(sqkm) lc_sqkm,SUM(prot_sqkm) lc_prot_sqkm FROM b GROUP BY country)
SELECT * FROM c NATURAL JOIN d


