DROP TABLE IF EXISTS results_202601_cep_out.country_conservation_mta_17; CREATE TABLE results_202601_cep_out.country_conservation_mta_17 AS
WITH 
country_eco_data AS (
					SELECT country_id,eco_id,country_eco_sqkm,country_eco_prot_sqkm FROM ecoregions_2017_export.results_country_ecoregion 
                    WHERE eco_id!=0 ORDER BY country_eco_sqkm
					 
					 ),
country_land AS (SELECT DISTINCT country_id, country_pid,country_name, sqkm country_sqkm FROM cep_data_202601.atts_country 
				WHERE source='land'),
eco_is_marine AS (SELECT country_id,eco_id FROM ecoregions_2017_export.results_country_ecoregion 
				WHERE country_id IN (SELECT country_id FROM country_land)
				),
input_data AS (SELECT a.country_id, a.eco_id,
			   country_eco_sqkm,
			   COALESCE(a.country_eco_prot_sqkm,0) country_eco_prot_sqkm,
			   CAST(1 AS integer) one
			   FROM country_eco_data a JOIN eco_is_marine b USING(country_id,eco_id) 
			   ORDER BY b.country_id),
count_eco AS (SELECT DISTINCT country_id,COUNT(eco_id) n_eco FROM input_data GROUP BY country_id),
temp1 AS (SELECT DISTINCT country_id, eco_id,
		  LEAST(((country_eco_prot_sqkm/country_eco_sqkm)/0.17),one) ratio_on_target
		  FROM input_data)
 
SELECT DISTINCT c.country_name,c.country_id,ROUND((SUM(a.ratio_on_target::numeric/b.n_eco::numeric)*100),2) mta_perc_n_ecoregions_in_country
FROM country_land c
LEFT JOIN  temp1 a USING (country_id) LEFT JOIN count_eco b USING (country_id)
WHERE c.country_name IS NOT NULL
GROUP BY c.country_id,c.country_name ORDER BY c.country_id;

