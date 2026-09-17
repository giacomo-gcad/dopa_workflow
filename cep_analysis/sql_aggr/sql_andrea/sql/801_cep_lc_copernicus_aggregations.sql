--COUNTRY
DROP TABLE IF EXISTS :v_rcep_out.country_lc_copernicus;CREATE TABLE :v_rcep_out.country_lc_copernicus AS 
WITH
i AS (SELECT * FROM :v_rcep_out.country_intermediate_lc_copernicus ORDER BY country_id,cat),
tot_ext AS(
SELECT
country_id,
ARRAY_AGG(cat) lc_copernicus_code,
ARRAY_AGG(theme_tot_sqkm) lc_copernicus_tot_sqkm,
ARRAY_AGG(theme_prot_sqkm) lc_copernicus_prot_sqkm,
ARRAY_AGG(theme_land_sqkm) lc_copernicus_land_sqkm,
ARRAY_AGG(theme_land_prot_sqkm) lc_copernicus_land_prot_sqkm,
ARRAY_AGG(theme_marine_sqkm) lc_copernicus_marine_sqkm,
ARRAY_AGG(theme_marine_prot_sqkm) lc_copernicus_marine_prot_sqkm
FROM i GROUP BY country_id ORDER BY country_id
),
natural_c AS (
SELECT
country_id,
SUM(theme_land_sqkm) lc_copernicus_land_natural_sqkm,
SUM(theme_land_prot_sqkm) lc_copernicus_land_natural_prot_sqkm
FROM i WHERE cat NOT IN (0,40,50) GROUP BY country_id),
forest_c AS (
SELECT
country_id,
SUM(theme_land_sqkm) lc_copernicus_land_forest_sqkm,
SUM(theme_land_prot_sqkm) lc_copernicus_land_forest_prot_sqkm
FROM i WHERE cat IN (111,112,113,114,115,116,121,122,123,124,125,126) GROUP BY country_id),
water_c AS (SELECT country_id,
SUM(theme_land_sqkm) lc_copernicus_land_water_sqkm,
SUM(theme_land_prot_sqkm) lc_copernicus_land_water_prot_sqkm
FROM i WHERE cat IN (80) GROUP BY country_id)
SELECT * FROM tot_ext
LEFT JOIN natural_c c USING(country_id)
LEFT JOIN forest_c d USING(country_id)
LEFT JOIN water_c e USING(country_id)
ORDER BY country_id;

--ECO
DROP TABLE IF EXISTS :v_rcep_out.ecoregion_lc_copernicus;CREATE TABLE :v_rcep_out.ecoregion_lc_copernicus AS 
WITH
i AS (SELECT * FROM :v_rcep_out.ecoregion_intermediate_lc_copernicus ORDER BY eco_id,cat),
tot_ext AS(
SELECT
eco_id,
ARRAY_AGG(cat) lc_copernicus_code,
ARRAY_AGG(theme_tot_sqkm) lc_copernicus_tot_sqkm,
ARRAY_AGG(theme_prot_sqkm) lc_copernicus_prot_sqkm
FROM i GROUP BY eco_id ORDER BY eco_id
)
SELECT * FROM tot_ext;


--PA
DROP TABLE IF EXISTS :v_rcep_out.wdpa_lc_copernicus;CREATE TABLE :v_rcep_out.wdpa_lc_copernicus AS 
WITH
i AS (SELECT * FROM :v_rcep_out.wdpa_intermediate_lc_copernicus ORDER BY wdpaid,cat),
tot_ext AS(
SELECT
wdpaid,
ARRAY_AGG(cat) lc_copernicus_code,
ARRAY_AGG(theme_sqkm) lc_copernicus_tot_sqkm
FROM i GROUP BY wdpaid ORDER BY wdpaid
)
SELECT * FROM tot_ext;
