--COUNTRY
--everything has been calculated
--BUT REPORTING AT THE MOMENT ONLY FOR LAND COUNTRY
--OR cutivated fields would show up in the sea

DROP TABLE IF EXISTS :v_rcep_out.country_lcc_esa;CREATE TABLE :v_rcep_out.country_lcc_esa AS
WITH
a AS (SELECT DISTINCT cat,lc1_1995,lc1_2020 FROM :v_rcep_in.:v_theme ORDER BY cat),
b AS (SELECT
country_id,cat,lc1_1995,lc1_2020,
--tot_sqkm,prot_sqkm,
land_sqkm,land_prot_sqkm,
--marine_sqkm,marine_prot_sqkm,theme_tot_sqkm lcc_esa_tot_sqkm,theme_prot_sqkm lcc_esa_prot_sqkm,
theme_land_sqkm lcc_esa_land_sqkm,
theme_land_prot_sqkm lcc_esa_land_prot_sqkm
--,theme_marine_sqkm lcc_esa_marine_sqkm,theme_marine_prot_sqkm lcc_esa_marine_prot_sqkm
FROM a JOIN :v_rcep_out.country_intermediate_lcc_esa USING (cat) ORDER BY country_id,cat),
c AS (SELECT DISTINCT country_id,
--	  tot_sqkm lcc_esa_country_tot_sqkm,prot_sqkm lcc_esa_country_prot_sqkm,
	  land_sqkm lcc_esa_country_land_sqkm,
	  land_prot_sqkm lcc_esa_country_land_prot_sqkm
--,marine_sqkm lcc_esa_country_marine_sqkm,marine_prot_sqkm lcc_esa_country_marine_prot_sqkm	  
	  FROM b ORDER BY country_id),
d AS (SELECT country_id,
	  ARRAY_AGG(lc1_1995)lcc_esa_lc1_1995,
	  ARRAY_AGG(lc1_2020)lcc_esa_lc1_2020,
--	  ARRAY_AGG(lcc_esa_tot_sqkm)lcc_esa_tot_sqkm,ARRAY_AGG(lcc_esa_prot_sqkm)lcc_esa_prot_sqkm,
	  ARRAY_AGG(lcc_esa_land_sqkm)lcc_esa_land_sqkm,
	  ARRAY_AGG(lcc_esa_land_prot_sqkm)lcc_esa_land_prot_sqkm
--	  ,ARRAY_AGG(lcc_esa_marine_sqkm)lcc_esa_marine_sqkm,ARRAY_AGG(lcc_esa_marine_prot_sqkm)lcc_esa_marine_prot_sqkm
	  FROM b
	  GROUP BY country_id ORDER BY country_id
)
SELECT * FROM c JOIN d USING(country_id)
WHERE lcc_esa_country_land_sqkm IS NOT NULL
ORDER BY country_id;

--ECOREGION
DROP TABLE IF EXISTS :v_rcep_out.ecoregion_lcc_esa;CREATE TABLE :v_rcep_out.ecoregion_lcc_esa AS 
WITH
a AS (SELECT DISTINCT cat,lc1_1995,lc1_2020 FROM :v_rcep_in.:v_theme ORDER BY cat),
b AS (SELECT
	  eco_id,cat,lc1_1995,lc1_2020,tot_sqkm,prot_sqkm,
--	  theme_land_sqkm esa_lcc_sqkm,theme_land_prot_sqkm esa_lcc_prot_sqkm	  
	  theme_tot_sqkm esa_lcc_sqkm,theme_prot_sqkm esa_lcc_prot_sqkm
	  FROM a
	  JOIN :v_rcep_out.ecoregion_intermediate_lcc_esa USING (cat)
	  ORDER BY eco_id,cat
),
c AS (SELECT DISTINCT eco_id,tot_sqkm lcc_esa_eco_tot_sqkm,prot_sqkm lcc_esa_eco_prot_sqkm FROM b ORDER BY eco_id),
d AS (SELECT eco_id,
	  ARRAY_AGG(lc1_1995)lcc_esa_lc1_1995,ARRAY_AGG(lc1_2020)lcc_esa_lc1_2020,
	  ARRAY_AGG(esa_lcc_sqkm)lcc_esa_sqkm,ARRAY_AGG(esa_lcc_prot_sqkm)lcc_esa_prot_sqkm
	  FROM b
	  GROUP BY eco_id ORDER BY eco_id
)
SELECT * FROM c JOIN d USING(eco_id)
WHERE lcc_esa_eco_tot_sqkm IS NOT NULL
--AND lcc_esa_eco_prot_sqkm IS NOT NULL
ORDER BY eco_id;

--PA
DROP TABLE IF EXISTS :v_rcep_out.wdpa_lcc_esa; CREATE TABLE :v_rcep_out.wdpa_lcc_esa AS 
WITH
a AS (SELECT DISTINCT cat,lc1_1995,lc1_2020 FROM :v_rcep_in.:v_theme ORDER BY cat),
b AS (SELECT
	  wdpaid,cat,lc1_1995,lc1_2020,tot_sqkm lcc_esa_pa_tot_sqkm,theme_sqkm lcc_esa_sqkm
	  FROM a JOIN :v_rcep_out.wdpa_intermediate_lcc_esa USING (cat) ORDER BY wdpaid,cat),
c AS (SELECT
	wdpaid,
	ARRAY_AGG(lc1_1995)lcc_esa_lc1_1995,
	ARRAY_AGG(lc1_2020)lcc_esa_lc1_2020,
	ARRAY_AGG(lcc_esa_sqkm)lcc_esa_sqkm
	FROM b GROUP BY wdpaid),
d AS (SELECT DISTINCT wdpaid,lcc_esa_pa_tot_sqkm FROM b),
e AS (SELECT d.wdpaid,d.lcc_esa_pa_tot_sqkm,c.lcc_esa_lc1_1995,c.lcc_esa_lc1_2020,c.lcc_esa_sqkm FROM d LEFT JOIN c USING(wdpaid) ORDER BY wdpaid)
SELECT * FROM e ORDER BY wdpaid;