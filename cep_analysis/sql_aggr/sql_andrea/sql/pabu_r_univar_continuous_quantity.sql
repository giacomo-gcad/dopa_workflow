-- SELECT THE THEME;
DROP TABLE IF EXISTS theme; CREATE TEMPORARY TABLE theme AS SELECT * FROM :v_rcep_in.:v_theme;
------------------------------------------------------------
DROP TABLE IF EXISTS bu_index; CREATE TEMPORARY TABLE bu_index AS SELECT * FROM :v_rcep_in.index_bu_last;
------------------------------------------------------------------
\set vmin '_':v_name'_min'
\set vmax '_':v_name'_max'
\set vmean '_':v_name'_mean'
\set vsum '_':v_name'_sum'
----------------------------------------
-- PROTECTION
\set vtab 'bu'
DROP TABLE IF EXISTS :vtab;CREATE TEMPORARY TABLE :vtab AS
SELECT bu wdpaid,MIN(min) :vtab:vmin,MAX(max) :vtab:vmax,SUM(mean*area_m2)/SUM(area_m2) :vtab:vmean,SUM(sum) :vtab:vsum
FROM (SELECT DISTINCT bu,qid,cid,(sqkm*1000000) area_m2  FROM bu_index)a
JOIN (SELECT qid,cid,min,max,mean,sum FROM theme)b USING(qid,cid)
GROUP BY bu ORDER BY bu;

-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
-- pa
DROP TABLE IF EXISTS :v_rcep_out.pabu_:v_name;
CREATE TABLE :v_rcep_out.pabu_:v_name AS
SELECT * FROM bu;
