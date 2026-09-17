-- PROCESS GROADS
DROP TABLE IF EXISTS :SCHEMA_RESULTS.wdpa_pressure_roads_pa; 
CREATE TABLE :SCHEMA_RESULTS.wdpa_pressure_roads_pa AS

WITH pas AS 
(
SELECT 
LTRIM(gname,'pa_')::integer wdpaid
FROM :PA_SCHEMA.list_pa
)

SELECT
a.wdpaid,
b.mean p_road_pa_perc_tot
FROM pas a
LEFT JOIN :SCHEMA_PRESSURES.pa_groads b ON a.wdpaid=b.wdpaid
ORDER BY a.wdpaid;

ALTER TABLE :SCHEMA_RESULTS.wdpa_pressure_roads_pa ADD PRIMARY KEY (wdpaid);
COMMENT ON TABLE :SCHEMA_RESULTS.wdpa_pressure_roads_pa IS 'Road pressure for PAs > 5km2';

