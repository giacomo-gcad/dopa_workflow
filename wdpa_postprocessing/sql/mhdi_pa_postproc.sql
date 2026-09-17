DROP TABLE IF EXISTS :SCHEMA_RESULTS.wdpa_habitat_diversity_profile_mhdi;
CREATE TABLE :SCHEMA_RESULTS.wdpa_habitat_diversity_profile_mhdi AS
WITH a AS 	(SELECT wdpaid,
			CASE WHEN stddev=0 THEN 0 ELSE log(stddev) END AS mhdi
			FROM :SCHEMA_MHDI.pa_marine_gebco)

SELECT wdpaid,ROUND(mhdi::numeric,4) mhdi FROM a 
ORDER BY wdpaid;
