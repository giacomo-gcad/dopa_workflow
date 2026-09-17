-- PROCESS AGRICULTURE FROM COPERNICUS
DROP TABLE IF EXISTS :SCHEMA_PRESSURES.wdpa_pressure_agriculture_bu; 
CREATE TABLE :SCHEMA_PRESSURES.wdpa_pressure_agriculture_bu AS


WITH
pas AS (SELECT LTRIM(gname,'bu_')::integer wdpaid FROM :BU_SCHEMA.list_bu),

bu_surface AS (
SELECT 
a.wdpaid,
b.area_m2/1000000 tot_area
FROM pas a
RIGHT JOIN :SCHEMA_PRESSURES.bu_cop_lc_totsurface b USING (wdpaid)
),

agri_area AS (
SELECT DISTINCT
a.wdpaid,
SUM(b.area_m2/1000000)/a.tot_area*100 ind
FROM bu_surface a
LEFT JOIN :SCHEMA_PRESSURES.bu_cop_lc b USING(wdpaid)
WHERE b.cat=40
GROUP BY a.wdpaid,a.tot_area)

SELECT 
a.wdpaid,
COALESCE(b.ind,0) p_agriculture_bu_perc_tot
FROM pas a LEFT JOIN agri_area b USING(wdpaid)
ORDER BY a.wdpaid
