-- SELECT THE THEME;
DROP TABLE IF EXISTS theme_1st; CREATE TEMPORARY TABLE theme_1st AS SELECT * FROM results_202601_cep_in.r_univar_cep_pop2000_202601;
DROP TABLE IF EXISTS theme_2nd; CREATE TEMPORARY TABLE theme_2nd AS SELECT * FROM results_202601_cep_in.r_univar_cep_pop2020_202601;
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS SELECT * FROM cep_data_202601.cep_index;
------------------------------------------------------------------

-- PROTECTION 1st_epoch
DROP TABLE IF EXISTS pa_1st_epoch;CREATE TEMPORARY TABLE pa_1st_epoch AS
SELECT pa wdpaid,MIN(min) pa_p_pop_first_epoch_min,MAX(max) pa_p_pop_first_epoch_max,SUM(mean*area_m2)/SUM(area_m2) pa_p_pop_first_epoch_mean,SUM(sum) pa_p_pop_first_epoch_sum
FROM (SELECT DISTINCT pa,qid,cid,(sqkm*1000000) area_m2  FROM pa_index)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme_1st)b USING(qid,cid)
GROUP BY pa ORDER BY pa;

-- PROTECTION 2nd_epoch
DROP TABLE IF EXISTS pa_2nd_epoch;CREATE TEMPORARY TABLE pa_2nd_epoch AS
SELECT pa wdpaid,MIN(min) pa_p_pop_last_epoch_min,MAX(max) pa_p_pop_last_epoch_max,SUM(mean*area_m2)/SUM(area_m2) pa_p_pop_last_epoch_mean,SUM(sum) pa_p_pop_last_epoch_sum
FROM (SELECT DISTINCT pa,qid,cid,(sqkm*1000000) area_m2  FROM pa_index)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme_2nd)b USING(qid,cid)
GROUP BY pa ORDER BY pa;

DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM results_202601_cep_in.cid_area_cep_ghs_pop_202601;

DROP TABLE IF EXISTS area_pas; CREATE TEMPORARY TABLE area_pas AS

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
WITH
a AS (SELECT * FROM pa_index NATURAL JOIN theme)
SELECT pa wdpaid,pa_name,is_marine,
SUM(area_m2)/1000000 pa_tot_area_sqkm 
FROM a WHERE is_marine IS FALSE GROUP BY pa,pa_name,is_marine ORDER BY pa;

DROP TABLE IF EXISTS density_first_epoch; CREATE TEMPORARY TABLE density_first_epoch AS
SELECT wdpaid, is_marine,pa_p_pop_first_epoch_sum, ROUND(pa_p_pop_first_epoch_sum::numeric/NULLIF(pa_tot_area_sqkm::numeric,0),2) pa_pressure_population_density_first_epoch
FROM pa_1st_epoch JOIN area_pas USING(wdpaid) WHERE wdpaid!=0;

DROP TABLE IF EXISTS density_last_epoch; CREATE TEMPORARY TABLE density_last_epoch AS
SELECT wdpaid, pa_p_pop_last_epoch_sum, ROUND(pa_p_pop_last_epoch_sum::numeric/NULLIF(pa_tot_area_sqkm::numeric,0),2) pa_pressure_population_density_last_epoch
FROM pa_2nd_epoch JOIN area_pas USING(wdpaid)  WHERE wdpaid!=0;

DROP TABLE IF EXISTS density_change; CREATE TEMPORARY TABLE density_change AS
SELECT a.wdpaid,(a.pa_pressure_population_density_last_epoch-b.pa_pressure_population_density_first_epoch) pa_pressure_population_density_change
FROM density_last_epoch a LEFT JOIN density_first_epoch b USING (wdpaid);

DROP TABLE IF EXISTS pop_change; CREATE TEMPORARY TABLE pop_change AS
SELECT a.wdpaid,((a.pa_p_pop_last_epoch_sum-b.pa_p_pop_first_epoch_sum)/NULLIF(b.pa_p_pop_first_epoch_sum,0)*100) pa_pressure_population_change_perc_first_epoch
FROM density_last_epoch a LEFT JOIN density_first_epoch b USING (wdpaid);

DROP TABLE IF EXISTS results_202601_cep_out.wdpa_pressure_population_pa; CREATE  TABLE results_202601_cep_out.wdpa_pressure_population_pa AS
SELECT a.wdpaid,
d.pa_p_pop_first_epoch_sum p_population_pa_last_epoch_sum,
a.pa_pressure_population_density_last_epoch p_population_pa_last_epoch_density,
b.pa_pressure_population_density_change p_population_pa_density_change,
c.pa_pressure_population_change_perc_first_epoch p_population_pa_change_perc_first_epoch
FROM density_last_epoch a 
LEFT JOIN pa_1st_epoch d USING(wdpaid) LEFT JOIN density_change b USING (wdpaid) LEFT JOIN pop_change c USING (wdpaid)
ORDER BY wdpaid;
