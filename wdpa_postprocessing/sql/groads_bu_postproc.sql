-- PROCESS GROADS
DROP TABLE IF EXISTS :SCHEMA_RESULTS.wdpa_pressure_roads_bu; 
CREATE TABLE :SCHEMA_RESULTS.wdpa_pressure_roads_bu AS

WITH pas AS 
(
SELECT 
LTRIM(gname,'bu_')::integer wdpaid
FROM :BU_SCHEMA.list_bu
)

SELECT
a.wdpaid,
b.mean p_road_bu_perc_tot
FROM pas a
LEFT JOIN :SCHEMA_PRESSURES.bu_groads b ON a.wdpaid=b.wdpaid
ORDER BY a.wdpaid;

ALTER TABLE :SCHEMA_RESULTS.wdpa_pressure_roads_bu ADD PRIMARY KEY (wdpaid);
COMMENT ON TABLE :SCHEMA_RESULTS.wdpa_pressure_roads_bu IS 'Road pressure for 10km buffers';

