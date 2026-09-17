-- PROCESS POPULATION DENSITY 
DROP TABLE IF EXISTS ind_bu_pop_density; 
CREATE TEMPORARY TABLE ind_bu_pop_density AS

WITH 
list_bu AS (SELECT LTRIM(gname,'bu_')::integer wdpaid FROM :BU_SCHEMA.list_bu),
bus_density_2015 AS (
SELECT 
a.wdpaid,
b.sum/NULLIF((b.non_null_cells/16),0) popdens_2015,
b.sum pop_2015
FROM list_bu a
LEFT JOIN :SCHEMA_PRESSURES.bu_pop2015 b USING(wdpaid)
),
bus_density_2000 AS (
SELECT 
a.wdpaid,
b.sum/NULLIF((b.non_null_cells/16),0) popdens_2000,
b.sum pop_2000
FROM list_bu a
LEFT JOIN :SCHEMA_PRESSURES.bu_pop2000 b USING(wdpaid)
)

SELECT a.*,b.popdens_2000,b.pop_2000 FROM  bus_density_2015 a
LEFT JOIN bus_density_2000 b USING (wdpaid)
ORDER BY wdpaid;

-- PROCESS POPULATION CHANGE

DROP TABLE IF EXISTS ind_bu_popchange;
CREATE TEMPORARY TABLE ind_bu_popchange AS

WITH 
list_bu AS (SELECT LTRIM(gname,'bu_')::integer wdpaid FROM :BU_SCHEMA.list_bu),
pop_2000_2015 AS (
SELECT 
a.wdpaid,
b.pop_2015,
b.popdens_2015,
b.pop_2000,
b.popdens_2000
FROM list_bu a
LEFT JOIN ind_bu_pop_density b USING (wdpaid)
)

SELECT
wdpaid,
round((popdens_2015::numeric-popdens_2000::numeric),2) pop_dens_change_bu,
round(((pop_2015::numeric-pop_2000::numeric)/NULLIF(pop_2000::numeric,0)*100),2) pop_change_perc_bu
FROM pop_2000_2015
ORDER BY wdpaid;

-- WRITE FINAL TABLE
DROP TABLE IF EXISTS :SCHEMA_RESULTS.wdpa_pressure_population_bu;
CREATE TABLE :SCHEMA_RESULTS.wdpa_pressure_population_bu AS
SELECT 
a.wdpaid,
a.pop_2015 p_population_bu_last_epoch_sum,
a.popdens_2015 p_population_bu_last_epoch_density,
b.pop_dens_change_bu p_population_bu_density_change,
b.pop_change_perc_bu p_population_bu_change_perc_first_epoch
FROM ind_bu_pop_density a 
LEFT JOIN ind_bu_popchange b USING (wdpaid);
ALTER TABLE :SCHEMA_RESULTS.wdpa_pressure_population_bu ADD PRIMARY KEY (wdpaid);
COMMENT ON TABLE :SCHEMA_RESULTS.wdpa_pressure_population_bu
    IS 'GHS Population data for 10km buffers';