-- PROCESS HDI

DROP TABLE IF EXISTS :SCHEMA_RESULTS.:TABLE_IND; 
CREATE TABLE :SCHEMA_RESULTS.:TABLE_IND AS

WITH 
list_pa AS (SELECT LTRIM(gname,'pa_')::integer wdpaid FROM :PA_SCHEMA.:LIST_PA),
all_segments AS (SELECT DISTINCT wdpaid,segm_id FROM :SCHEMA_HDI.:DATA_HDI),
area_pa AS (SELECT wdpaid, area_geo FROM :WDPA_SCHEMA.wdpa_wdoecm_:WDPA_DATE),
n_segm AS (SELECT DISTINCT a.wdpaid,COUNT(a.segm_id) hdi_freq,b.area_geo km2 FROM all_segments a LEFT JOIN area_pa b ON a.wdpaid=b.wdpaid GROUP BY a.wdpaid,b.area_geo ORDER BY a.wdpaid)

SELECT
a.wdpaid,
b.hdi_freq,
POWER(b.hdi_freq,2)/SQRT(b.km2) hdi_awhd
FROM list_pa a
LEFT JOIN n_segm b USING(wdpaid)
ORDER BY a.wdpaid
