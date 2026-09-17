DROP TABLE IF EXISTS :v_rcep_out.wdpa_pressure_builtup_bu;CREATE TABLE :v_rcep_out.wdpa_pressure_builtup_bu AS
WITH
finput AS (SELECT pa wdpaid FROM :v_rcep_in.atts_pa_last WHERE marine IN (0,1) ORDER BY wdpaid),
land_ext AS(
SELECT wdpaid,SUM(theme_sqkm) land_sqkm
FROM :v_rcep_out.pabu_intermediate_p_builtup_bu
WHERE cat IN (0,2,3,4,5,6) GROUP BY wdpaid ORDER BY wdpaid
),
cats AS (
SELECT wdpaid,SUM(theme_sqkm) theme_sqkm
FROM :v_rcep_out.pabu_intermediate_p_builtup_bu
WHERE cat IN (3,4,5,6)
GROUP BY wdpaid ORDER BY wdpaid	
),
all_cats AS (SELECT * FROM finput
JOIN land_ext USING(wdpaid)
JOIN cats USING(wdpaid)
ORDER BY wdpaid)
SELECT wdpaid,
--land_sqkm,
theme_sqkm AS p_builtup_bu_sqkm,
ROUND((theme_sqkm/land_sqkm*100)::numeric,2) p_builtup_bu_perc_land
FROM all_cats ORDER BY wdpaid;
