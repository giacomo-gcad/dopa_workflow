-- PROCESS WORLDCLIM

DROP TABLE IF EXISTS pas; CREATE TEMPORARY TABLE pas  AS 
(SELECT LTRIM(gname,'pa_')::integer wdpaid FROM :PA_SCHEMA.list_pa_tc);

DROP TABLE IF EXISTS tmax; CREATE TEMPORARY TABLE tmax  AS 
WITH tmaxall AS (
SELECT a.wdpaid,
ROUND(tmx1.mean::numeric,2) cli_tmax_01,ROUND(tmx2.mean::numeric,2) cli_tmax_02,ROUND(tmx3.mean::numeric,2) cli_tmax_03,ROUND(tmx4.mean::numeric,2) cli_tmax_04,ROUND(tmx5.mean::numeric,2) cli_tmax_05,ROUND(tmx6.mean::numeric,2) cli_tmax_06,
ROUND(tmx7.mean::numeric,2) cli_tmax_07,ROUND(tmx8.mean::numeric,2) cli_tmax_08,ROUND(tmx9.mean::numeric,2) cli_tmax_09,ROUND(tmx10.mean::numeric,2) cli_tmax_10,ROUND(tmx11.mean::numeric,2) cli_tmax_11,ROUND(tmx12.mean::numeric,2) cli_tmax_12
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
ROUND(ta1.mean::numeric,2) cli_tmean_01,ROUND(ta2.mean::numeric,2) cli_tmean_02,ROUND(ta3.mean::numeric,2) cli_tmean_03,ROUND(ta4.mean::numeric,2) cli_tmean_04,ROUND(ta5.mean::numeric,2) cli_tmean_05,ROUND(ta6.mean::numeric,2) cli_tmean_06,
ROUND(ta7.mean::numeric,2) cli_tmean_07,ROUND(ta8.mean::numeric,2) cli_tmean_08,ROUND(ta9.mean::numeric,2) cli_tmean_09,ROUND(ta10.mean::numeric,2) cli_tmean_10,ROUND(ta11.mean::numeric,2) cli_tmean_11,ROUND(ta12.mean::numeric,2) cli_tmean_12
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
ROUND(tmn1.mean::numeric,2) cli_tmin_01,ROUND(tmn2.mean::numeric,2) cli_tmin_02,ROUND(tmn3.mean::numeric,2) cli_tmin_03,ROUND(tmn4.mean::numeric,2) cli_tmin_04,ROUND(tmn5.mean::numeric,2) cli_tmin_05,ROUND(tmn6.mean::numeric,2) cli_tmin_06,
ROUND(tmn7.mean::numeric,2) cli_tmin_07,ROUND(tmn8.mean::numeric,2) cli_tmin_08,ROUND(tmn9.mean::numeric,2) cli_tmin_09,ROUND(tmn10.mean::numeric,2) cli_tmin_10,ROUND(tmn11.mean::numeric,2) cli_tmin_11,ROUND(tmn12.mean::numeric,2) cli_tmin_12
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
ROUND(pre1.mean::numeric,2) cli_prec_01,ROUND(pre2.mean::numeric,2) cli_prec_02,ROUND(pre3.mean::numeric,2) cli_prec_03,ROUND(pre4.mean::numeric,2) cli_prec_04,ROUND(pre5.mean::numeric,2) cli_prec_05,ROUND(pre6.mean::numeric,2) cli_prec_06,
ROUND(pre7.mean::numeric,2) cli_prec_07,ROUND(pre8.mean::numeric,2) cli_prec_08,ROUND(pre9.mean::numeric,2) cli_prec_09,ROUND(pre10.mean::numeric,2) cli_prec_10,ROUND(pre11.mean::numeric,2) cli_prec_11,ROUND(pre12.mean::numeric,2) cli_prec_12
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

