-- reports by land only
-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM :v_rcep_in.:v_theme;
-- SELECT THE AREA;
DROP TABLE IF EXISTS area_index; CREATE TEMPORARY TABLE area_index AS SELECT cid,area_m2 FROM :v_rcep_in.cid_area_by_tile;
------------------------------------------------------------
DROP TABLE IF EXISTS pa_index; CREATE TEMPORARY TABLE pa_index AS SELECT * FROM :v_rcep_in.index_pa_cep_last;
------------------------------------------------------------------
----------------------------------------
DROP TABLE IF EXISTS cid_theme;CREATE TEMPORARY TABLE cid_theme AS
SELECT cid,SUM(sum)/1000000 t_sqkm FROM theme GROUP BY cid;

DROP TABLE IF EXISTS cid_pa_land;CREATE TEMPORARY TABLE cid_pa_land AS
SELECT DISTINCT pa,pa_name,iso3,cid FROM pa_index WHERE marine IN (0,1);

DROP TABLE IF EXISTS cid_area;CREATE TEMPORARY TABLE cid_area AS
SELECT cid,SUM(area_m2/1000000) sqkm FROM area_index GROUP BY cid;

-- PROTECTION
DROP TABLE IF EXISTS pa_land_theme;CREATE TEMPORARY TABLE pa_land_theme AS
SELECT pa,pa_name,iso3,SUM(sqkm) sqkm,SUM(t_sqkm) p_builtup_pa_sqkm FROM cid_pa_land
LEFT JOIN cid_area USING(cid)
LEFT JOIN cid_theme USING(cid)
GROUP BY  pa,pa_name,iso3;

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
-- pa
DROP TABLE IF EXISTS :v_rcep_out.wdpa_pressure_builtup_pa;
CREATE TABLE :v_rcep_out.wdpa_pressure_builtup_pa AS
SELECT * FROM pa_land_theme;
