DROP TABLE IF EXISTS :v_rcep_out.country_conservation_mta; CREATE TABLE :v_rcep_out.country_conservation_mta AS
WITH 
country_eco_data AS (SELECT country_id,eco_id,country_eco_sqkm,country_eco_prot_sqkm FROM :v_rcep_out.country_ecoregion_conservation_coverage),
eco_is_marine AS (SELECT country_id,eco_id,is_marine FROM :v_rcep_out.country_ecoregion_conservation_coverage),
input_data AS (SELECT a.country_id, a.eco_id,
			   country_eco_sqkm,
			   COALESCE(a.country_eco_prot_sqkm,0) country_eco_prot_sqkm,
			   CAST(1 AS integer) one
			   FROM country_eco_data a JOIN eco_is_marine b USING(country_id,eco_id) 
			   WHERE b.is_marine IS FALSE ORDER BY b.country_id),
count_eco AS (SELECT DISTINCT country_id country,COUNT(eco_id) n_eco FROM input_data GROUP BY country_id),
temp1 AS (SELECT DISTINCT country_id country, eco_id,
		  LEAST(((country_eco_prot_sqkm/country_eco_sqkm)/:v_target),one) ratio_on_target
		  FROM input_data)
SELECT DISTINCT c.country country_id,ROUND((SUM(a.ratio_on_target::numeric/b.n_eco::numeric)*100),2) mta_perc_n_ecoregions_in_country
FROM :v_rcep_in.atts_country_last c
LEFT JOIN  temp1 a USING (country) LEFT JOIN count_eco b USING (country)
GROUP BY c.country ORDER BY c.country;