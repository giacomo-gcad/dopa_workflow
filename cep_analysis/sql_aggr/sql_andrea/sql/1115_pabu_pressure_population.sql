DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM :v_rcep_in.:v_theme;
DROP TABLE IF EXISTS bu_index; CREATE TEMPORARY TABLE bu_index AS SELECT * FROM :v_rcep_in.index_bu_last;
--  write final indicator table
DROP TABLE IF EXISTS :v_rcep_out.wdpa_pressure_population_bu; CREATE  TABLE :v_rcep_out.wdpa_pressure_population_bu AS
WITH
a AS (SELECT * FROM bu_index NATURAL JOIN theme),
area_bus AS (SELECT bu wdpaid,
SUM(area_m2)/1000000 bu_tot_area_sqkm 
FROM a GROUP BY bu ORDER BY bu),
density_first_epoch AS 
(SELECT wdpaid, bu_pressure_population_first_epoch_bu_sum, ROUND(bu_pressure_population_first_epoch_bu_sum::numeric/NULLIF(bu_tot_area_sqkm::numeric,0),2) bu_pressure_population_density_first_epoch
FROM :v_rcep_out.pabu_pressure_population_first_epoch_bu JOIN area_bus USING(wdpaid)),
density_last_epoch AS 
(SELECT wdpaid, bu_pressure_population_last_epoch_bu_sum, ROUND(bu_pressure_population_last_epoch_bu_sum::numeric/NULLIF(bu_tot_area_sqkm::numeric,0),2) bu_pressure_population_density_last_epoch
FROM :v_rcep_out.pabu_pressure_population_last_epoch_bu JOIN area_bus USING(wdpaid)),
density_change AS 
(SELECT a.wdpaid,(a.bu_pressure_population_density_last_epoch-b.bu_pressure_population_density_first_epoch) bu_pressure_population_density_change
FROM density_last_epoch a LEFT JOIN density_first_epoch b USING (wdpaid)),
pop_change AS 
(SELECT a.wdpaid,((a.bu_pressure_population_last_epoch_bu_sum-b.bu_pressure_population_first_epoch_bu_sum)/NULLIF(b.bu_pressure_population_first_epoch_bu_sum,0)*100) bu_pressure_population_change_perc_first_epoch
FROM density_last_epoch a LEFT JOIN density_first_epoch b USING (wdpaid))

SELECT a.wdpaid,
a.bu_pressure_population_last_epoch_bu_sum p_population_bu_last_epoch_sum,
a.bu_pressure_population_density_last_epoch p_population_bu_last_epoch_density,
b.bu_pressure_population_density_change p_population_bu_density_change,
c.bu_pressure_population_change_perc_first_epoch p_population_bu_change_perc_first_epoch
FROM density_last_epoch a LEFT JOIN density_change b USING (wdpaid) LEFT JOIN pop_change c USING (wdpaid)
ORDER BY wdpaid;