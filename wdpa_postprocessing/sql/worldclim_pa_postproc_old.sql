-- PROCESS WORLDCLIM

DROP TABLE IF EXISTS pas; CREATE TEMPORARY TABLE pas  AS 
(SELECT LTRIM(gname,'pa_')::integer wdpaid FROM :PA_SCHEMA.list_pa_tc);

DROP TABLE IF EXISTS tmax; CREATE TEMPORARY TABLE tmax  AS 
WITH tmaxall AS (
SELECT a.wdpaid,
tmx1.mean cli_tmax_01,tmx2.mean cli_tmax_02,tmx3.mean cli_tmax_03,tmx4.mean cli_tmax_04,tmx5.mean cli_tmax_05,tmx6.mean cli_tmax_06,
tmx7.mean cli_tmax_07,tmx8.mean cli_tmax_08,tmx9.mean cli_tmax_09,tmx10.mean cli_tmax_10,tmx11.mean cli_tmax_11,tmx12.mean cli_tmax_12
FROM pas a
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_01 tmx1 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_02 tmx2 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_03 tmx3 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_04 tmx4 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_05 tmx5 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_06 tmx6 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_07 tmx7 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_08 tmx8 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_09 tmx9 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_10 tmx10 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_11 tmx11 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmax_12 tmx12 USING(wdpaid))
SELECT DISTINCT * FROM tmaxall;

DROP TABLE IF EXISTS tmean; CREATE TEMPORARY TABLE tmean  AS 
WITH tmeanall AS (
SELECT a.wdpaid,
ta1.mean cli_tmean_01,ta2.mean cli_tmean_02,ta3.mean cli_tmean_03,ta4.mean cli_tmean_04,ta5.mean cli_tmean_05,ta6.mean cli_tmean_06,
ta7.mean cli_tmean_07,ta8.mean cli_tmean_08,ta9.mean cli_tmean_09,ta10.mean cli_tmean_10,ta11.mean cli_tmean_11,ta12.mean cli_tmean_12
FROM pas a 
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_01 ta1 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_02 ta2 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_03 ta3 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_04 ta4 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_05 ta5 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_06 ta6 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_07 ta7 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_08 ta8 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_09 ta9 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_10 ta10 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_11 ta11 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tavg_12 ta12 USING(wdpaid))
SELECT DISTINCT * FROM tmeanall;


DROP TABLE IF EXISTS tmin; CREATE TEMPORARY TABLE tmin  AS 
WITH tminall AS (
SELECT a.wdpaid,
tmn1.mean cli_tmin_01,tmn2.mean cli_tmin_02,tmn3.mean cli_tmin_03,tmn4.mean cli_tmin_04,tmn5.mean cli_tmin_05,tmn6.mean cli_tmin_06,
tmn7.mean cli_tmin_07,tmn8.mean cli_tmin_08,tmn9.mean cli_tmin_09,tmn10.mean cli_tmin_10,tmn11.mean cli_tmin_11,tmn12.mean cli_tmin_12
FROM pas a
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_01 tmn1 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_02 tmn2 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_03 tmn3 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_04 tmn4 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_05 tmn5 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_06 tmn6 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_07 tmn7 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_08 tmn8 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_09 tmn9 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_10 tmn10 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_11 tmn11 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_tmin_12 tmn12 USING(wdpaid))
SELECT DISTINCT * FROM tminall;

DROP TABLE IF EXISTS prec; CREATE TEMPORARY TABLE prec  AS 
WITH precall AS (
SELECT a.wdpaid,
pre1.mean cli_prec_01,pre2.mean cli_prec_02,pre3.mean cli_prec_03,pre4.mean cli_prec_04,pre5.mean cli_prec_05,pre6.mean cli_prec_06,
pre7.mean cli_prec_07,pre8.mean cli_prec_08,pre9.mean cli_prec_09,pre10.mean cli_prec_10,pre11.mean cli_prec_11,pre12.mean cli_prec_12
FROM pas a
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_01 pre1 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_02 pre2 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_03 pre3 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_04 pre4 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_05 pre5 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_06 pre6 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_07 pre7 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_08 pre8 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_09 pre9 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_10 pre10 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_11 pre11 USING(wdpaid)
LEFT JOIN :SCHEMA_CLIM.pa_clim_prec_12 pre12 USING(wdpaid))
SELECT DISTINCT * FROM precall;


DROP TABLE IF EXISTS :SCHEMA_CLIM.worldclim_wdpa_:DATE; 
CREATE TABLE :SCHEMA_CLIM.worldclim_wdpa_:DATE AS
SELECT a.wdpaid,
b.cli_tmax_01,b.cli_tmax_02,b.cli_tmax_03,b.cli_tmax_04,b.cli_tmax_05,b.cli_tmax_06,
b.cli_tmax_07,b.cli_tmax_08,b.cli_tmax_09,b.cli_tmax_10,b.cli_tmax_11,b.cli_tmax_12,
c.cli_tmean_01,c.cli_tmean_02,c.cli_tmean_03,c.cli_tmean_04,c.cli_tmean_05,c.cli_tmean_06,
c.cli_tmean_07,c.cli_tmean_08,c.cli_tmean_09,c.cli_tmean_10,c.cli_tmean_11,c.cli_tmean_12,
d.cli_tmin_01,d.cli_tmin_02,d.cli_tmin_03,d.cli_tmin_04,d.cli_tmin_05,d.cli_tmin_06,
d.cli_tmin_07,d.cli_tmin_08,d.cli_tmin_09,d.cli_tmin_10,d.cli_tmin_11,d.cli_tmin_12,
e.cli_prec_01,e.cli_prec_02,e.cli_prec_03,e.cli_prec_04,e.cli_prec_05,e.cli_prec_06,
e.cli_prec_07,e.cli_prec_08,e.cli_prec_09,e.cli_prec_10,e.cli_prec_11,e.cli_prec_12
FROM pas a
LEFT JOIN tmax b USING(wdpaid)
LEFT JOIN tmean c USING(wdpaid)
LEFT JOIN tmin d USING(wdpaid)
LEFT JOIN prec e USING(wdpaid)
ORDER BY a.wdpaid;

ALTER TABLE :SCHEMA_CLIM.worldclim_wdpa_:DATE
ADD PRIMARY KEY (wdpaid);

