DROP TABLE IF EXISTS :v_rcep_out.wdpa_lc_esa CASCADE;

DROP TABLE IF EXISTS abc;CREATE TEMPORARY TABLE abc AS
WITH
a AS (SELECT pa wdpaid FROM :v_rcep_in.atts_pa_last),
b AS (SELECT lc_code lc_esa_code FROM themes.class_lc_esa)
SELECT * FROM a,b;

DROP TABLE IF EXISTS lc_1995;CREATE TEMPORARY TABLE lc_1995 AS
SELECT wdpaid,cat lc_esa_code,theme_sqkm lc_esa_1995_sqkm FROM :v_rcep_out.wdpa_intermediate_lc_esa_1995 ORDER BY wdpaid,lc_esa_code;

DROP TABLE IF EXISTS lc_2000;CREATE TEMPORARY TABLE lc_2000 AS
SELECT wdpaid,cat lc_esa_code,theme_sqkm lc_esa_2000_sqkm FROM :v_rcep_out.wdpa_intermediate_lc_esa_2000 ORDER BY wdpaid,lc_esa_code;

DROP TABLE IF EXISTS lc_2005;CREATE TEMPORARY TABLE lc_2005 AS
SELECT wdpaid,cat lc_esa_code,theme_sqkm lc_esa_2005_sqkm FROM :v_rcep_out.wdpa_intermediate_lc_esa_2005 ORDER BY wdpaid,lc_esa_code;

DROP TABLE IF EXISTS lc_2010;CREATE TEMPORARY TABLE lc_2010 AS
SELECT wdpaid,cat lc_esa_code,theme_sqkm lc_esa_2010_sqkm FROM :v_rcep_out.wdpa_intermediate_lc_esa_2010 ORDER BY wdpaid,lc_esa_code;

DROP TABLE IF EXISTS lc_2015;CREATE TEMPORARY TABLE lc_2015 AS
SELECT wdpaid,cat lc_esa_code,theme_sqkm lc_esa_2015_sqkm FROM :v_rcep_out.wdpa_intermediate_lc_esa_2015 ORDER BY wdpaid,lc_esa_code;

DROP TABLE IF EXISTS lc_2020;CREATE TEMPORARY TABLE lc_2020 AS
SELECT wdpaid,cat lc_esa_code,theme_sqkm lc_esa_2020_sqkm FROM :v_rcep_out.wdpa_intermediate_lc_esa_2020 ORDER BY wdpaid,lc_esa_code;


DROP TABLE IF EXISTS d;CREATE TEMPORARY TABLE d AS
SELECT * FROM abc
LEFT JOIN lc_1995 USING(wdpaid,lc_esa_code)
LEFT JOIN lc_2000 USING(wdpaid,lc_esa_code)
LEFT JOIN lc_2005 USING(wdpaid,lc_esa_code)
LEFT JOIN lc_2010 USING(wdpaid,lc_esa_code)
LEFT JOIN lc_2015 USING(wdpaid,lc_esa_code)
LEFT JOIN lc_2020 USING(wdpaid,lc_esa_code)
;

DROP TABLE IF EXISTS e;CREATE TEMPORARY TABLE e AS
SELECT * FROM d
WHERE (lc_esa_1995_sqkm IS NOT NULL AND lc_esa_2000_sqkm IS NOT NULL AND lc_esa_2005_sqkm IS NOT NULL AND lc_esa_2010_sqkm IS NOT NULL AND lc_esa_2015_sqkm IS NOT NULL AND lc_esa_2020_sqkm IS NOT NULL)
ORDER BY wdpaid,lc_esa_code;

DROP TABLE IF EXISTS f;CREATE TEMPORARY TABLE f AS
SELECT wdpaid,
ARRAY_AGG(lc_esa_code) lc_esa_code,
ARRAY_AGG(lc_esa_1995_sqkm)lc_esa_1995_sqkm,
ARRAY_AGG(lc_esa_2000_sqkm)lc_esa_2000_sqkm,
ARRAY_AGG(lc_esa_2005_sqkm)lc_esa_2005_sqkm,
ARRAY_AGG(lc_esa_2010_sqkm)lc_esa_2010_sqkm,
ARRAY_AGG(lc_esa_2015_sqkm)lc_esa_2015_sqkm,
ARRAY_AGG(lc_esa_2020_sqkm)lc_esa_2020_sqkm
FROM e GROUP BY wdpaid ORDER BY wdpaid;

CREATE TABLE :v_rcep_out.wdpa_lc_esa AS SELECT * FROM f;
