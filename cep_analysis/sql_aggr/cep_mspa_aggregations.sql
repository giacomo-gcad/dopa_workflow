-- EPOCH 1995
--COUNTRY
DROP TABLE IF EXISTS country_mspa_1995;CREATE TEMPORARY TABLE country_mspa_1995 AS 
WITH
finput AS (SELECT DISTINCT country_id FROM cep_data_202601.cep_index  ORDER BY country_id),
cat1 AS (SELECT country_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.country_intermediate_mspa_1995 WHERE cat IN (17) GROUP BY country_id),
cat2 AS (SELECT country_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.country_intermediate_mspa_1995 WHERE cat IN (0,129) GROUP BY country_id),
cat3 AS (SELECT country_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.country_intermediate_mspa_1995 WHERE cat IN (3,5) GROUP BY country_id),
cat4 AS (SELECT country_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.country_intermediate_mspa_1995 WHERE cat IN (100) GROUP BY country_id),
cat5 AS (SELECT country_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.country_intermediate_mspa_1995 WHERE cat IN (9) GROUP BY country_id),
cat6 AS (SELECT country_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.country_intermediate_mspa_1995 WHERE cat IN (1) GROUP BY country_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(country_id)
LEFT JOIN cat2 USING(country_id)
LEFT JOIN cat3 USING(country_id)
LEFT JOIN cat4 USING(country_id)
LEFT JOIN cat5 USING(country_id)
LEFT JOIN cat6 USING(country_id)
ORDER BY country_id)
SELECT country_id,cat1 mspa_core_1995_sqkm,cat2 mspa_non_natural_1995_sqkm,cat3 mspa_edge_1995_sqkm,cat4 mspa_core_perforation_1995_sqkm,cat5 mspa_islet_1995_sqkm,cat6 mspa_linear_1995_sqkm
FROM all_cats ORDER BY country_id;
/* --ECO
DROP TABLE IF EXISTS ecoregion_mspa_1995;CREATE TEMPORARY TABLE ecoregion_mspa_1995 AS 
WITH
finput AS (SELECT ecoregion eco_id,ecoregion_name,source,is_marine FROM results_202601_cep_in.atts_ecoregion_last ORDER BY ecoregion),
cat1 AS (SELECT eco_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.ecoregion_intermediate_mspa_1995 WHERE cat IN (17) GROUP BY eco_id),
cat2 AS (SELECT eco_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.ecoregion_intermediate_mspa_1995 WHERE cat IN (0,129) GROUP BY eco_id),
cat3 AS (SELECT eco_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.ecoregion_intermediate_mspa_1995 WHERE cat IN (3,5) GROUP BY eco_id),
cat4 AS (SELECT eco_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.ecoregion_intermediate_mspa_1995 WHERE cat IN (100) GROUP BY eco_id),
cat5 AS (SELECT eco_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.ecoregion_intermediate_mspa_1995 WHERE cat IN (9) GROUP BY eco_id),
cat6 AS (SELECT eco_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.ecoregion_intermediate_mspa_1995 WHERE cat IN (1) GROUP BY eco_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(eco_id)
LEFT JOIN cat2 USING(eco_id)
LEFT JOIN cat3 USING(eco_id)
LEFT JOIN cat4 USING(eco_id)
LEFT JOIN cat5 USING(eco_id)
LEFT JOIN cat6 USING(eco_id)
ORDER BY eco_id)
SELECT eco_id,cat1 mspa_core_1995_sqkm,cat2 mspa_non_natural_1995_sqkm,cat3 mspa_edge_1995_sqkm,cat4 mspa_core_perforation_1995_sqkm,cat5 mspa_islet_1995_sqkm,cat6 mspa_linear_1995_sqkm
FROM all_cats ORDER BY eco_id;
 */--PA
DROP TABLE IF EXISTS wdpa_mspa_1995;CREATE TEMPORARY TABLE wdpa_mspa_1995 AS 
WITH
finput AS (SELECT wdpaid FROM protected_sites.wdpa_wdoecm_202601 ORDER BY wdpaid),
cat1 AS (SELECT wdpaid,SUM(theme_sqkm) cat1 FROM results_202601_cep_out.wdpa_intermediate_mspa_1995 WHERE cat IN (17) GROUP BY wdpaid),
cat2 AS (SELECT wdpaid,SUM(theme_sqkm) cat2 FROM results_202601_cep_out.wdpa_intermediate_mspa_1995 WHERE cat IN (0,129) GROUP BY wdpaid),
cat3 AS (SELECT wdpaid,SUM(theme_sqkm) cat3 FROM results_202601_cep_out.wdpa_intermediate_mspa_1995 WHERE cat IN (3,5) GROUP BY wdpaid),
cat4 AS (SELECT wdpaid,SUM(theme_sqkm) cat4 FROM results_202601_cep_out.wdpa_intermediate_mspa_1995 WHERE cat IN (100) GROUP BY wdpaid),
cat5 AS (SELECT wdpaid,SUM(theme_sqkm) cat5 FROM results_202601_cep_out.wdpa_intermediate_mspa_1995 WHERE cat IN (9) GROUP BY wdpaid),
cat6 AS (SELECT wdpaid,SUM(theme_sqkm) cat6 FROM results_202601_cep_out.wdpa_intermediate_mspa_1995 WHERE cat IN (1) GROUP BY wdpaid),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(wdpaid)
LEFT JOIN cat2 USING(wdpaid)
LEFT JOIN cat3 USING(wdpaid)
LEFT JOIN cat4 USING(wdpaid)
LEFT JOIN cat5 USING(wdpaid)
LEFT JOIN cat6 USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,cat1 mspa_core_1995_sqkm,cat2 mspa_non_natural_1995_sqkm,cat3 mspa_edge_1995_sqkm,cat4 mspa_core_perforation_1995_sqkm,cat5 mspa_islet_1995_sqkm,cat6 mspa_linear_1995_sqkm
FROM all_cats ORDER BY wdpaid;
-- EPOCH 2000
--COUNTRY
DROP TABLE IF EXISTS country_mspa_2000;CREATE TEMPORARY TABLE country_mspa_2000 AS 
WITH
finput AS (SELECT DISTINCT country_id FROM cep_data_202601.cep_index  ORDER BY country_id),
cat1 AS (SELECT country_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.country_intermediate_mspa_2000 WHERE cat IN (17) GROUP BY country_id),
cat2 AS (SELECT country_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.country_intermediate_mspa_2000 WHERE cat IN (0,129) GROUP BY country_id),
cat3 AS (SELECT country_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.country_intermediate_mspa_2000 WHERE cat IN (3,5) GROUP BY country_id),
cat4 AS (SELECT country_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.country_intermediate_mspa_2000 WHERE cat IN (100) GROUP BY country_id),
cat5 AS (SELECT country_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.country_intermediate_mspa_2000 WHERE cat IN (9) GROUP BY country_id),
cat6 AS (SELECT country_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.country_intermediate_mspa_2000 WHERE cat IN (1) GROUP BY country_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(country_id)
LEFT JOIN cat2 USING(country_id)
LEFT JOIN cat3 USING(country_id)
LEFT JOIN cat4 USING(country_id)
LEFT JOIN cat5 USING(country_id)
LEFT JOIN cat6 USING(country_id)
ORDER BY country_id)
SELECT country_id,cat1 mspa_core_2000_sqkm,cat2 mspa_non_natural_2000_sqkm,cat3 mspa_edge_2000_sqkm,cat4 mspa_core_perforation_2000_sqkm,cat5 mspa_islet_2000_sqkm,cat6 mspa_linear_2000_sqkm
FROM all_cats ORDER BY country_id;
/* --ECO
DROP TABLE IF EXISTS ecoregion_mspa_2000;CREATE TEMPORARY TABLE ecoregion_mspa_2000 AS 
WITH
finput AS (SELECT ecoregion eco_id,ecoregion_name,source,is_marine FROM results_202601_cep_in.atts_ecoregion_last ORDER BY ecoregion),
cat1 AS (SELECT eco_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2000 WHERE cat IN (17) GROUP BY eco_id),
cat2 AS (SELECT eco_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2000 WHERE cat IN (0,129) GROUP BY eco_id),
cat3 AS (SELECT eco_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2000 WHERE cat IN (3,5) GROUP BY eco_id),
cat4 AS (SELECT eco_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2000 WHERE cat IN (100) GROUP BY eco_id),
cat5 AS (SELECT eco_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2000 WHERE cat IN (9) GROUP BY eco_id),
cat6 AS (SELECT eco_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2000 WHERE cat IN (1) GROUP BY eco_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(eco_id)
LEFT JOIN cat2 USING(eco_id)
LEFT JOIN cat3 USING(eco_id)
LEFT JOIN cat4 USING(eco_id)
LEFT JOIN cat5 USING(eco_id)
LEFT JOIN cat6 USING(eco_id)
ORDER BY eco_id)
SELECT eco_id,cat1 mspa_core_2000_sqkm,cat2 mspa_non_natural_2000_sqkm,cat3 mspa_edge_2000_sqkm,cat4 mspa_core_perforation_2000_sqkm,cat5 mspa_islet_2000_sqkm,cat6 mspa_linear_2000_sqkm
FROM all_cats ORDER BY eco_id; */
--PA
DROP TABLE IF EXISTS wdpa_mspa_2000;CREATE TEMPORARY TABLE wdpa_mspa_2000 AS 
WITH
finput AS (SELECT wdpaid FROM protected_sites.wdpa_wdoecm_202601 ORDER BY wdpaid),
cat1 AS (SELECT wdpaid,SUM(theme_sqkm) cat1 FROM results_202601_cep_out.wdpa_intermediate_mspa_2000 WHERE cat IN (17) GROUP BY wdpaid),
cat2 AS (SELECT wdpaid,SUM(theme_sqkm) cat2 FROM results_202601_cep_out.wdpa_intermediate_mspa_2000 WHERE cat IN (0,129) GROUP BY wdpaid),
cat3 AS (SELECT wdpaid,SUM(theme_sqkm) cat3 FROM results_202601_cep_out.wdpa_intermediate_mspa_2000 WHERE cat IN (3,5) GROUP BY wdpaid),
cat4 AS (SELECT wdpaid,SUM(theme_sqkm) cat4 FROM results_202601_cep_out.wdpa_intermediate_mspa_2000 WHERE cat IN (100) GROUP BY wdpaid),
cat5 AS (SELECT wdpaid,SUM(theme_sqkm) cat5 FROM results_202601_cep_out.wdpa_intermediate_mspa_2000 WHERE cat IN (9) GROUP BY wdpaid),
cat6 AS (SELECT wdpaid,SUM(theme_sqkm) cat6 FROM results_202601_cep_out.wdpa_intermediate_mspa_2000 WHERE cat IN (1) GROUP BY wdpaid),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(wdpaid)
LEFT JOIN cat2 USING(wdpaid)
LEFT JOIN cat3 USING(wdpaid)
LEFT JOIN cat4 USING(wdpaid)
LEFT JOIN cat5 USING(wdpaid)
LEFT JOIN cat6 USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,cat1 mspa_core_2000_sqkm,cat2 mspa_non_natural_2000_sqkm,cat3 mspa_edge_2000_sqkm,cat4 mspa_core_perforation_2000_sqkm,cat5 mspa_islet_2000_sqkm,cat6 mspa_linear_2000_sqkm
FROM all_cats ORDER BY wdpaid;
-- EPOCH 2005
--COUNTRY
DROP TABLE IF EXISTS country_mspa_2005;CREATE TEMPORARY TABLE country_mspa_2005 AS 
WITH
finput AS (SELECT DISTINCT country_id FROM cep_data_202601.cep_index ORDER BY country_id),
cat1 AS (SELECT country_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.country_intermediate_mspa_2005 WHERE cat IN (17) GROUP BY country_id),
cat2 AS (SELECT country_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.country_intermediate_mspa_2005 WHERE cat IN (0,129) GROUP BY country_id),
cat3 AS (SELECT country_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.country_intermediate_mspa_2005 WHERE cat IN (3,5) GROUP BY country_id),
cat4 AS (SELECT country_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.country_intermediate_mspa_2005 WHERE cat IN (100) GROUP BY country_id),
cat5 AS (SELECT country_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.country_intermediate_mspa_2005 WHERE cat IN (9) GROUP BY country_id),
cat6 AS (SELECT country_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.country_intermediate_mspa_2005 WHERE cat IN (1) GROUP BY country_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(country_id)
LEFT JOIN cat2 USING(country_id)
LEFT JOIN cat3 USING(country_id)
LEFT JOIN cat4 USING(country_id)
LEFT JOIN cat5 USING(country_id)
LEFT JOIN cat6 USING(country_id)
ORDER BY country_id)
SELECT country_id,cat1 mspa_core_2005_sqkm,cat2 mspa_non_natural_2005_sqkm,cat3 mspa_edge_2005_sqkm,cat4 mspa_core_perforation_2005_sqkm,cat5 mspa_islet_2005_sqkm,cat6 mspa_linear_2005_sqkm
FROM all_cats ORDER BY country_id;
/* --ECO
DROP TABLE IF EXISTS ecoregion_mspa_2005;CREATE TEMPORARY TABLE ecoregion_mspa_2005 AS 
WITH
finput AS (SELECT ecoregion eco_id,ecoregion_name,source,is_marine FROM results_202601_cep_in.atts_ecoregion_last ORDER BY ecoregion),
cat1 AS (SELECT eco_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2005 WHERE cat IN (17) GROUP BY eco_id),
cat2 AS (SELECT eco_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2005 WHERE cat IN (0,129) GROUP BY eco_id),
cat3 AS (SELECT eco_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2005 WHERE cat IN (3,5) GROUP BY eco_id),
cat4 AS (SELECT eco_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2005 WHERE cat IN (100) GROUP BY eco_id),
cat5 AS (SELECT eco_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2005 WHERE cat IN (9) GROUP BY eco_id),
cat6 AS (SELECT eco_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2005 WHERE cat IN (1) GROUP BY eco_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(eco_id)
LEFT JOIN cat2 USING(eco_id)
LEFT JOIN cat3 USING(eco_id)
LEFT JOIN cat4 USING(eco_id)
LEFT JOIN cat5 USING(eco_id)
LEFT JOIN cat6 USING(eco_id)
ORDER BY eco_id)
SELECT eco_id,cat1 mspa_core_2005_sqkm,cat2 mspa_non_natural_2005_sqkm,cat3 mspa_edge_2005_sqkm,cat4 mspa_core_perforation_2005_sqkm,cat5 mspa_islet_2005_sqkm,cat6 mspa_linear_2005_sqkm
FROM all_cats ORDER BY eco_id; */
--PA
DROP TABLE IF EXISTS wdpa_mspa_2005;CREATE TEMPORARY TABLE wdpa_mspa_2005 AS 
WITH
finput AS (SELECT wdpaid FROM protected_sites.wdpa_wdoecm_202601 ORDER BY wdpaid),
cat1 AS (SELECT wdpaid,SUM(theme_sqkm) cat1 FROM results_202601_cep_out.wdpa_intermediate_mspa_2005 WHERE cat IN (17) GROUP BY wdpaid),
cat2 AS (SELECT wdpaid,SUM(theme_sqkm) cat2 FROM results_202601_cep_out.wdpa_intermediate_mspa_2005 WHERE cat IN (0,129) GROUP BY wdpaid),
cat3 AS (SELECT wdpaid,SUM(theme_sqkm) cat3 FROM results_202601_cep_out.wdpa_intermediate_mspa_2005 WHERE cat IN (3,5) GROUP BY wdpaid),
cat4 AS (SELECT wdpaid,SUM(theme_sqkm) cat4 FROM results_202601_cep_out.wdpa_intermediate_mspa_2005 WHERE cat IN (100) GROUP BY wdpaid),
cat5 AS (SELECT wdpaid,SUM(theme_sqkm) cat5 FROM results_202601_cep_out.wdpa_intermediate_mspa_2005 WHERE cat IN (9) GROUP BY wdpaid),
cat6 AS (SELECT wdpaid,SUM(theme_sqkm) cat6 FROM results_202601_cep_out.wdpa_intermediate_mspa_2005 WHERE cat IN (1) GROUP BY wdpaid),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(wdpaid)
LEFT JOIN cat2 USING(wdpaid)
LEFT JOIN cat3 USING(wdpaid)
LEFT JOIN cat4 USING(wdpaid)
LEFT JOIN cat5 USING(wdpaid)
LEFT JOIN cat6 USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,cat1 mspa_core_2005_sqkm,cat2 mspa_non_natural_2005_sqkm,cat3 mspa_edge_2005_sqkm,cat4 mspa_core_perforation_2005_sqkm,cat5 mspa_islet_2005_sqkm,cat6 mspa_linear_2005_sqkm
FROM all_cats ORDER BY wdpaid;
-- EPOCH 2010
--COUNTRY
DROP TABLE IF EXISTS country_mspa_2010;CREATE TEMPORARY TABLE country_mspa_2010 AS 
WITH
finput AS (SELECT DISTINCT country_id FROM cep_data_202601.cep_index ORDER BY country_id),
cat1 AS (SELECT country_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.country_intermediate_mspa_2010 WHERE cat IN (17) GROUP BY country_id),
cat2 AS (SELECT country_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.country_intermediate_mspa_2010 WHERE cat IN (0,129) GROUP BY country_id),
cat3 AS (SELECT country_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.country_intermediate_mspa_2010 WHERE cat IN (3,5) GROUP BY country_id),
cat4 AS (SELECT country_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.country_intermediate_mspa_2010 WHERE cat IN (100) GROUP BY country_id),
cat5 AS (SELECT country_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.country_intermediate_mspa_2010 WHERE cat IN (9) GROUP BY country_id),
cat6 AS (SELECT country_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.country_intermediate_mspa_2010 WHERE cat IN (1) GROUP BY country_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(country_id)
LEFT JOIN cat2 USING(country_id)
LEFT JOIN cat3 USING(country_id)
LEFT JOIN cat4 USING(country_id)
LEFT JOIN cat5 USING(country_id)
LEFT JOIN cat6 USING(country_id)
ORDER BY country_id)
SELECT country_id,cat1 mspa_core_2010_sqkm,cat2 mspa_non_natural_2010_sqkm,cat3 mspa_edge_2010_sqkm,cat4 mspa_core_perforation_2010_sqkm,cat5 mspa_islet_2010_sqkm,cat6 mspa_linear_2010_sqkm
FROM all_cats ORDER BY country_id;
/* --ECO
DROP TABLE IF EXISTS ecoregion_mspa_2010;CREATE TEMPORARY TABLE ecoregion_mspa_2010 AS 
WITH
finput AS (SELECT ecoregion eco_id,ecoregion_name,source,is_marine FROM results_202601_cep_in.atts_ecoregion_last ORDER BY ecoregion),
cat1 AS (SELECT eco_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2010 WHERE cat IN (17) GROUP BY eco_id),
cat2 AS (SELECT eco_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2010 WHERE cat IN (0,129) GROUP BY eco_id),
cat3 AS (SELECT eco_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2010 WHERE cat IN (3,5) GROUP BY eco_id),
cat4 AS (SELECT eco_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2010 WHERE cat IN (100) GROUP BY eco_id),
cat5 AS (SELECT eco_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2010 WHERE cat IN (9) GROUP BY eco_id),
cat6 AS (SELECT eco_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2010 WHERE cat IN (1) GROUP BY eco_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(eco_id)
LEFT JOIN cat2 USING(eco_id)
LEFT JOIN cat3 USING(eco_id)
LEFT JOIN cat4 USING(eco_id)
LEFT JOIN cat5 USING(eco_id)
LEFT JOIN cat6 USING(eco_id)
ORDER BY eco_id)
SELECT eco_id,cat1 mspa_core_2010_sqkm,cat2 mspa_non_natural_2010_sqkm,cat3 mspa_edge_2010_sqkm,cat4 mspa_core_perforation_2010_sqkm,cat5 mspa_islet_2010_sqkm,cat6 mspa_linear_2010_sqkm
FROM all_cats ORDER BY eco_id; */
--PA
DROP TABLE IF EXISTS wdpa_mspa_2010;CREATE TEMPORARY TABLE wdpa_mspa_2010 AS 
WITH
finput AS (SELECT wdpaid FROM protected_sites.wdpa_wdoecm_202601 ORDER BY wdpaid),
cat1 AS (SELECT wdpaid,SUM(theme_sqkm) cat1 FROM results_202601_cep_out.wdpa_intermediate_mspa_2010 WHERE cat IN (17) GROUP BY wdpaid),
cat2 AS (SELECT wdpaid,SUM(theme_sqkm) cat2 FROM results_202601_cep_out.wdpa_intermediate_mspa_2010 WHERE cat IN (0,129) GROUP BY wdpaid),
cat3 AS (SELECT wdpaid,SUM(theme_sqkm) cat3 FROM results_202601_cep_out.wdpa_intermediate_mspa_2010 WHERE cat IN (3,5) GROUP BY wdpaid),
cat4 AS (SELECT wdpaid,SUM(theme_sqkm) cat4 FROM results_202601_cep_out.wdpa_intermediate_mspa_2010 WHERE cat IN (100) GROUP BY wdpaid),
cat5 AS (SELECT wdpaid,SUM(theme_sqkm) cat5 FROM results_202601_cep_out.wdpa_intermediate_mspa_2010 WHERE cat IN (9) GROUP BY wdpaid),
cat6 AS (SELECT wdpaid,SUM(theme_sqkm) cat6 FROM results_202601_cep_out.wdpa_intermediate_mspa_2010 WHERE cat IN (1) GROUP BY wdpaid),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(wdpaid)
LEFT JOIN cat2 USING(wdpaid)
LEFT JOIN cat3 USING(wdpaid)
LEFT JOIN cat4 USING(wdpaid)
LEFT JOIN cat5 USING(wdpaid)
LEFT JOIN cat6 USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,cat1 mspa_core_2010_sqkm,cat2 mspa_non_natural_2010_sqkm,cat3 mspa_edge_2010_sqkm,cat4 mspa_core_perforation_2010_sqkm,cat5 mspa_islet_2010_sqkm,cat6 mspa_linear_2010_sqkm
FROM all_cats ORDER BY wdpaid;
-- EPOCH 2015
--COUNTRY
DROP TABLE IF EXISTS country_mspa_2015;CREATE TEMPORARY TABLE country_mspa_2015 AS 
WITH
finput AS (SELECT DISTINCT country_id FROM cep_data_202601.cep_index ORDER BY country_id),
cat1 AS (SELECT country_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.country_intermediate_mspa_2015 WHERE cat IN (17) GROUP BY country_id),
cat2 AS (SELECT country_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.country_intermediate_mspa_2015 WHERE cat IN (0,129) GROUP BY country_id),
cat3 AS (SELECT country_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.country_intermediate_mspa_2015 WHERE cat IN (3,5) GROUP BY country_id),
cat4 AS (SELECT country_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.country_intermediate_mspa_2015 WHERE cat IN (100) GROUP BY country_id),
cat5 AS (SELECT country_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.country_intermediate_mspa_2015 WHERE cat IN (9) GROUP BY country_id),
cat6 AS (SELECT country_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.country_intermediate_mspa_2015 WHERE cat IN (1) GROUP BY country_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(country_id)
LEFT JOIN cat2 USING(country_id)
LEFT JOIN cat3 USING(country_id)
LEFT JOIN cat4 USING(country_id)
LEFT JOIN cat5 USING(country_id)
LEFT JOIN cat6 USING(country_id)
ORDER BY country_id)
SELECT country_id,cat1 mspa_core_2015_sqkm,cat2 mspa_non_natural_2015_sqkm,cat3 mspa_edge_2015_sqkm,cat4 mspa_core_perforation_2015_sqkm,cat5 mspa_islet_2015_sqkm,cat6 mspa_linear_2015_sqkm
FROM all_cats ORDER BY country_id;
/* --ECO
DROP TABLE IF EXISTS ecoregion_mspa_2015;CREATE TEMPORARY TABLE ecoregion_mspa_2015 AS 
WITH
finput AS (SELECT ecoregion eco_id,ecoregion_name,source,is_marine FROM results_202601_cep_in.atts_ecoregion_last ORDER BY ecoregion),
cat1 AS (SELECT eco_id,SUM(theme_land_sqkm) cat1 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2015 WHERE cat IN (17) GROUP BY eco_id),
cat2 AS (SELECT eco_id,SUM(theme_land_sqkm) cat2 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2015 WHERE cat IN (0,129) GROUP BY eco_id),
cat3 AS (SELECT eco_id,SUM(theme_land_sqkm) cat3 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2015 WHERE cat IN (3,5) GROUP BY eco_id),
cat4 AS (SELECT eco_id,SUM(theme_land_sqkm) cat4 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2015 WHERE cat IN (100) GROUP BY eco_id),
cat5 AS (SELECT eco_id,SUM(theme_land_sqkm) cat5 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2015 WHERE cat IN (9) GROUP BY eco_id),
cat6 AS (SELECT eco_id,SUM(theme_land_sqkm) cat6 FROM results_202601_cep_out.ecoregion_intermediate_mspa_2015 WHERE cat IN (1) GROUP BY eco_id),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(eco_id)
LEFT JOIN cat2 USING(eco_id)
LEFT JOIN cat3 USING(eco_id)
LEFT JOIN cat4 USING(eco_id)
LEFT JOIN cat5 USING(eco_id)
LEFT JOIN cat6 USING(eco_id)
ORDER BY eco_id)
SELECT eco_id,cat1 mspa_core_2015_sqkm,cat2 mspa_non_natural_2015_sqkm,cat3 mspa_edge_2015_sqkm,cat4 mspa_core_perforation_2015_sqkm,cat5 mspa_islet_2015_sqkm,cat6 mspa_linear_2015_sqkm
FROM all_cats ORDER BY eco_id; */
--PA
DROP TABLE IF EXISTS wdpa_mspa_2015;CREATE TEMPORARY TABLE wdpa_mspa_2015 AS 
WITH
finput AS (SELECT wdpaid FROM protected_sites.wdpa_wdoecm_202601 ORDER BY wdpaid),
cat1 AS (SELECT wdpaid,SUM(theme_sqkm) cat1 FROM results_202601_cep_out.wdpa_intermediate_mspa_2015 WHERE cat IN (17) GROUP BY wdpaid),
cat2 AS (SELECT wdpaid,SUM(theme_sqkm) cat2 FROM results_202601_cep_out.wdpa_intermediate_mspa_2015 WHERE cat IN (0,129) GROUP BY wdpaid),
cat3 AS (SELECT wdpaid,SUM(theme_sqkm) cat3 FROM results_202601_cep_out.wdpa_intermediate_mspa_2015 WHERE cat IN (3,5) GROUP BY wdpaid),
cat4 AS (SELECT wdpaid,SUM(theme_sqkm) cat4 FROM results_202601_cep_out.wdpa_intermediate_mspa_2015 WHERE cat IN (100) GROUP BY wdpaid),
cat5 AS (SELECT wdpaid,SUM(theme_sqkm) cat5 FROM results_202601_cep_out.wdpa_intermediate_mspa_2015 WHERE cat IN (9) GROUP BY wdpaid),
cat6 AS (SELECT wdpaid,SUM(theme_sqkm) cat6 FROM results_202601_cep_out.wdpa_intermediate_mspa_2015 WHERE cat IN (1) GROUP BY wdpaid),
all_cats AS (SELECT * FROM finput
LEFT JOIN cat1 USING(wdpaid)
LEFT JOIN cat2 USING(wdpaid)
LEFT JOIN cat3 USING(wdpaid)
LEFT JOIN cat4 USING(wdpaid)
LEFT JOIN cat5 USING(wdpaid)
LEFT JOIN cat6 USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,cat1 mspa_core_2015_sqkm,cat2 mspa_non_natural_2015_sqkm,cat3 mspa_edge_2015_sqkm,cat4 mspa_core_perforation_2015_sqkm,cat5 mspa_islet_2015_sqkm,cat6 mspa_linear_2015_sqkm
FROM all_cats ORDER BY wdpaid;

--FINAL COUNTRY
DROP TABLE IF EXISTS results_202601_cep_out.country_mspa;CREATE TABLE results_202601_cep_out.country_mspa AS 
SELECT *
FROM country_mspa_1995 a
LEFT JOIN country_mspa_2000 b USING (country_id)
LEFT JOIN country_mspa_2005 c USING (country_id)
LEFT JOIN country_mspa_2010 d USING (country_id)
LEFT JOIN country_mspa_2015 e USING (country_id);

/* --FINAL ECOREGION
DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_mspa;CREATE TABLE results_202601_cep_out.ecoregion_mspa AS 
SELECT *
FROM ecoregion_mspa_1995 a
LEFT JOIN ecoregion_mspa_2000 b USING (eco_id)
LEFT JOIN ecoregion_mspa_2005 c USING (eco_id)
LEFT JOIN ecoregion_mspa_2010 d USING (eco_id)
LEFT JOIN ecoregion_mspa_2015 e USING (eco_id); */

--FINAL WDPA
DROP TABLE IF EXISTS results_202601_cep_out.wdpa_mspa;CREATE TABLE results_202601_cep_out.wdpa_mspa AS 
SELECT *
FROM wdpa_mspa_1995 a
LEFT JOIN wdpa_mspa_2000 b USING (wdpaid)
LEFT JOIN wdpa_mspa_2005 c USING (wdpaid)
LEFT JOIN wdpa_mspa_2010 d USING (wdpaid)
LEFT JOIN wdpa_mspa_2015 e USING (wdpaid);

--DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_mspa_1995;
--DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_mspa_2000;
--DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_mspa_2005;
--DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_mspa_2010;
--DROP TABLE IF EXISTS results_202601_cep_out.country_intermediate_mspa_2015;
--DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_intermediate_mspa_1995;
--DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_intermediate_mspa_2000;
--DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_intermediate_mspa_2005;
--DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_intermediate_mspa_2010;
--DROP TABLE IF EXISTS results_202601_cep_out.ecoregion_intermediate_mspa_2015;
--DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_mspa_1995;
--DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_mspa_2000;
--DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_mspa_2005;
--DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_mspa_2010;
--DROP TABLE IF EXISTS results_202601_cep_out.wdpa_intermediate_mspa_2015;
