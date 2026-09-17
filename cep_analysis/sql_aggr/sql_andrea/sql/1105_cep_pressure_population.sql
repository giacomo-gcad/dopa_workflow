DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM :v_rcep_in.:v_theme;
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS SELECT * FROM :v_rcep_in.index_cep;
--  write final indicator table
DROP TABLE IF EXISTS :v_rcep_out.wdpa_pressure_population_pa; CREATE  TABLE :v_rcep_out.wdpa_pressure_population_pa AS
WITH
a AS (SELECT * FROM pa_index NATURAL JOIN theme),
area_pas AS (SELECT pa wdpaid,pa_name,iso3,is_marine,
--SUM(sqkm) sqkm, 
SUM(area_m2)/1000000 pa_tot_area_sqkm 
FROM a GROUP BY pa,pa_name,iso3,is_marine ORDER BY pa),
density_first_epoch AS 
(SELECT wdpaid, pa_pressure_population_first_epoch_sum, ROUND(pa_pressure_population_first_epoch_sum::numeric/NULLIF(pa_tot_area_sqkm::numeric,0),2) pa_pressure_population_density_first_epoch
FROM :v_rcep_out.wdpa_pressure_population_first_epoch JOIN area_pas USING(wdpaid)),
density_last_epoch AS 
(SELECT wdpaid, pa_pressure_population_last_epoch_sum, ROUND(pa_pressure_population_last_epoch_sum::numeric/NULLIF(pa_tot_area_sqkm::numeric,0),2) pa_pressure_population_density_last_epoch
FROM :v_rcep_out.wdpa_pressure_population_last_epoch JOIN area_pas USING(wdpaid)),
density_change AS 
(SELECT a.wdpaid,(a.pa_pressure_population_density_last_epoch-b.pa_pressure_population_density_first_epoch) pa_pressure_population_density_change
FROM density_last_epoch a LEFT JOIN density_first_epoch b USING (wdpaid)),
pop_change AS 
(SELECT a.wdpaid,((a.pa_pressure_population_last_epoch_sum-b.pa_pressure_population_first_epoch_sum)/NULLIF(b.pa_pressure_population_first_epoch_sum,0)*100) pa_pressure_population_change_perc_first_epoch
FROM density_last_epoch a LEFT JOIN density_first_epoch b USING (wdpaid))

SELECT a.wdpaid,
a.pa_pressure_population_last_epoch_sum p_population_pa_last_epoch_sum,
a.pa_pressure_population_density_last_epoch p_population_pa_last_epoch_density,
b.pa_pressure_population_density_change p_population_pa_density_change,
c.pa_pressure_population_change_perc_first_epoch p_population_pa_change_perc_first_epoch
FROM density_last_epoch a LEFT JOIN density_change b USING (wdpaid) LEFT JOIN pop_change c USING (wdpaid)
ORDER BY wdpaid;