-- MAKES PAs STATISTICS TABLE
DROP TABLE IF EXISTS results_202601_cep_out.country_conservation_pa_list; CREATE TABLE results_202601_cep_out.country_conservation_pa_list AS
SELECT *,CARDINALITY(pa_list) pa_count
FROM (SELECT country_id,ARRAY_AGG(DISTINCT pa ORDER BY pa) pa_list FROM cep_data_202601.cep_index 
WHERE is_protected IS TRUE GROUP BY country_id ORDER BY country_id) a ORDER BY country_id;

