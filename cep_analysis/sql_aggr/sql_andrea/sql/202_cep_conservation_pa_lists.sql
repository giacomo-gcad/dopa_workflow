--country_pa
DROP TABLE IF EXISTS :v_rcep_out.country_conservation_pa_list; CREATE TABLE :v_rcep_out.country_conservation_pa_list AS
SELECT *,CARDINALITY(pa_list) pa_count FROM (SELECT country country_id,ARRAY_AGG(DISTINCT pa ORDER BY pa) pa_list FROM :v_rcep_in.index_cep_last WHERE is_protected IS TRUE GROUP BY country ORDER BY country) a;

--ecoregion_pa
DROP TABLE IF EXISTS :v_rcep_out.ecoregion_conservation_pa_list;CREATE TABLE :v_rcep_out.ecoregion_conservation_pa_list AS
WITH
a AS (SELECT DISTINCT qid,cid,eco eco_id,pa,sqkm FROM :v_rcep_in.index_cep_last WHERE is_protected IS TRUE),
b AS (SELECT eco_id,pa,SUM(sqkm) sqkm FROM a GROUP BY eco_id,pa ORDER BY eco_id,pa),
c AS (SELECT eco_id,ARRAY_AGG(pa) pa_list,ARRAY_AGG(sqkm) pa_sqkm FROM b GROUP BY eco_id ORDER BY eco_id)
SELECT *,CARDINALITY(pa_list) pa_count FROM c ORDER BY eco_id;

