-- PROCESS BUILT UP - all years
DROP TABLE IF EXISTS :SCHEMA_PRESSURES.ind_bu_builtup_allyears_:WDPADATE; 
CREATE TABLE :SCHEMA_PRESSURES.ind_bu_builtup_allyears_:WDPADATE AS

WITH pas AS 
(
SELECT 
LTRIM(gname,'bu_')::integer wdpaid
FROM :BU_SCHEMA.list_bu
),

full_data_bu AS (
SELECT 
cat,
wdpaid,
area_m2/1000000 val_km
FROM :SCHEMA_PRESSURES.bu_builtup
),

tot_area_bu AS (
SELECT DISTINCT
a.wdpaid,
b.area_m2/1000000 bu_tot_area_km2
FROM full_data_bu a
LEFT JOIN :SCHEMA_PRESSURES.bu_builtup_totsurface b ON a.wdpaid=b.wdpaid
),

land_area_bu AS (
SELECT DISTINCT
a.wdpaid,
(COALESCE(b.val_km,0)+COALESCE(c.val_km,0)+COALESCE(d.val_km,0)+COALESCE(e.val_km,0)+COALESCE(f.val_km,0)+COALESCE(g.val_km,0)) bu_land_area_km2
FROM full_data_bu a
LEFT JOIN full_data_bu b ON a.wdpaid=b.wdpaid AND b.cat=6
LEFT JOIN full_data_bu c ON a.wdpaid=c.wdpaid AND c.cat=5
LEFT JOIN full_data_bu d ON a.wdpaid=d.wdpaid AND d.cat=4
LEFT JOIN full_data_bu e ON a.wdpaid=e.wdpaid AND e.cat=3
LEFT JOIN full_data_bu f ON a.wdpaid=f.wdpaid AND f.cat=2
LEFT JOIN full_data_bu g ON a.wdpaid=g.wdpaid AND g.cat=0
ORDER BY a.wdpaid
),

rebuilt_bu AS(
SELECT
a.wdpaid,
COALESCE(b.val_km,0) builtup_bu_75_km2,
ROUND((COALESCE(b.val_km::numeric,0)/NULLIF(k.bu_land_area_km2::numeric,0)*100),2)::numeric builtup_bu_75_perc_la,
ROUND((COALESCE(b.val_km::numeric,0)/NULLIF(g.bu_tot_area_km2::numeric,0)*100),2)::numeric builtup_bu_75_perc_ta,
COALESCE(b.val_km,0)+COALESCE(c.val_km,0) builtup_bu_90_km2,
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0))/NULLIF(k.bu_land_area_km2::numeric,0)*100),2)::numeric builtup_bu_90_perc_la,
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0))/NULLIF(g.bu_tot_area_km2::numeric,0)*100),2)::numeric builtup_bu_90_perc_ta,
COALESCE(b.val_km,0)+COALESCE(c.val_km,0)+COALESCE(d.val_km,0) builtup_bu_00_km2,
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0)+COALESCE(d.val_km::numeric,0))/NULLIF(k.bu_land_area_km2::numeric,0)*100),2)::numeric builtup_bu_00_perc_la,  
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0)+COALESCE(d.val_km::numeric,0))/NULLIF(g.bu_tot_area_km2::numeric,0)*100),2)::numeric builtup_bu_00_perc_ta,  
COALESCE(b.val_km,0)+COALESCE(c.val_km,0)+COALESCE(d.val_km,0)+COALESCE(e.val_km,0) builtup_bu_14_km2,
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0)+COALESCE(d.val_km::numeric,0)+COALESCE(e.val_km::numeric,0))/NULLIF(k.bu_land_area_km2::numeric,0)*100),2)::numeric builtup_bu_14_perc_la,
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0)+COALESCE(d.val_km::numeric,0)+COALESCE(e.val_km::numeric,0))/NULLIF(g.bu_tot_area_km2::numeric,0)*100),2)::numeric builtup_bu_14_perc_ta
FROM pas a
LEFT JOIN full_data_bu b ON a.wdpaid=b.wdpaid AND b.cat=6
LEFT JOIN full_data_bu c ON a.wdpaid=c.wdpaid AND c.cat=5
LEFT JOIN full_data_bu d ON a.wdpaid=d.wdpaid AND d.cat=4
LEFT JOIN full_data_bu e ON a.wdpaid=e.wdpaid AND e.cat=3
LEFT JOIN land_area_bu k ON a.wdpaid=k.wdpaid
LEFT JOIN tot_area_bu g ON a.wdpaid=g.wdpaid
ORDER BY a.wdpaid
)

SELECT
a.wdpaid,
a.builtup_bu_75_km2 built_75,
a.builtup_bu_90_km2 built_90,
a.builtup_bu_00_km2 built_00,
a.builtup_bu_14_km2 built_14,
a.builtup_bu_75_perc_ta built_75_perc_tot_area,
a.builtup_bu_90_perc_ta built_90_perc_tot_area,
a.builtup_bu_00_perc_ta built_00_perc_tot_area,
a.builtup_bu_14_perc_ta built_14_perc_tot_area,
a.builtup_bu_75_perc_la built_75_perc_land_area,
a.builtup_bu_90_perc_la built_90_perc_land_area,
a.builtup_bu_00_perc_la built_00_perc_land_area,
a.builtup_bu_14_perc_la built_14_perc_land_area,
a.builtup_bu_14_km2 ind,
a.builtup_bu_14_perc_la ind_perc, -- TO BE CHANGED IF WE WANT TO SHOW THE % COMPUTED ON THE TOTAL AREA OF BUFFER INSTEAD OF THE TERRESTRIAL AREA
b.bu_land_area_km2 land_area_km2,
c.bu_tot_area_km2 tot_area_km2
FROM rebuilt_bu a
LEFT JOIN land_area_bu b ON a.wdpaid=b.wdpaid
LEFT JOIN tot_area_bu c ON a.wdpaid=c.wdpaid
ORDER BY a.wdpaid;

ALTER TABLE :SCHEMA_PRESSURES.ind_bu_builtup_allyears_:WDPADATE ADD PRIMARY KEY (wdpaid);
COMMENT ON TABLE :SCHEMA_PRESSURES.ind_bu_builtup_allyears_:WDPADATE
    IS 'Built up data (all years) for 10km buffers';


-- WRITE TABLE WITH ONLY PRESSURE INDICATOR AND %
DROP TABLE IF EXISTS :SCHEMA_RESULTS.wdpa_pressure_builtup_bu; 
CREATE TABLE :SCHEMA_RESULTS.wdpa_pressure_builtup_bu AS

WITH pas AS 
(
SELECT 
LTRIM(gname,'bu_')::integer wdpaid
FROM :BU_SCHEMA.list_bu
),

full_data_bu AS (
SELECT 
cat,
wdpaid,
area_m2/1000000 val_km
FROM :SCHEMA_PRESSURES.bu_builtup
),

land_area_bu AS (
SELECT DISTINCT
a.wdpaid,
(COALESCE(b.val_km,0)+COALESCE(c.val_km,0)+COALESCE(d.val_km,0)+COALESCE(e.val_km,0)+COALESCE(f.val_km,0)+COALESCE(g.val_km,0)) bu_land_area_km2
FROM full_data_bu a
LEFT JOIN full_data_bu b ON a.wdpaid=b.wdpaid AND b.cat=6
LEFT JOIN full_data_bu c ON a.wdpaid=c.wdpaid AND c.cat=5
LEFT JOIN full_data_bu d ON a.wdpaid=d.wdpaid AND d.cat=4
LEFT JOIN full_data_bu e ON a.wdpaid=e.wdpaid AND e.cat=3
LEFT JOIN full_data_bu f ON a.wdpaid=f.wdpaid AND f.cat=2
LEFT JOIN full_data_bu g ON a.wdpaid=g.wdpaid AND g.cat=0

ORDER BY a.wdpaid
),

rebuilt_bu AS(
SELECT
a.wdpaid,
COALESCE(b.val_km,0)+COALESCE(c.val_km,0)+COALESCE(d.val_km,0)+COALESCE(e.val_km,0) builtup_bu_14_km2,
ROUND(((COALESCE(b.val_km::numeric,0)+COALESCE(c.val_km::numeric,0)+COALESCE(d.val_km::numeric,0)+COALESCE(e.val_km::numeric,0))/NULLIF(k.bu_land_area_km2::numeric,0)*100),2)::numeric builtup_bu_14_perc
FROM pas a
LEFT JOIN full_data_bu b ON a.wdpaid=b.wdpaid AND b.cat=6
LEFT JOIN full_data_bu c ON a.wdpaid=c.wdpaid AND c.cat=5
LEFT JOIN full_data_bu d ON a.wdpaid=d.wdpaid AND d.cat=4
LEFT JOIN full_data_bu e ON a.wdpaid=e.wdpaid AND e.cat=3
LEFT JOIN land_area_bu k ON a.wdpaid=k.wdpaid
ORDER BY a.wdpaid
)

SELECT
wdpaid,
builtup_bu_14_km2 p_builtup_bu_sqkm,
builtup_bu_14_perc p_builtup_bu_perc_land
FROM rebuilt_bu
ORDER BY wdpaid;

ALTER TABLE :SCHEMA_RESULTS.wdpa_pressure_builtup_bu ADD PRIMARY KEY (wdpaid);
COMMENT ON TABLE :SCHEMA_RESULTS.wdpa_pressure_builtup_bu
    IS 'Built up data for 10km buffers';

