-- SECOND PART: add and compute area_geo

ALTER TABLE :vSCHEMA.wdpa_wdoecm_geom_:vDATE
--DROP COLUMN geom_was_invalid,
ADD COLUMN area_geo double precision;

UPDATE :vSCHEMA.wdpa_wdoecm_geom_:vDATE
SET area_geo = (ST_AREA(geom::geography)/1000000);

-- THIRD PART: Create final tables

DROP TABLE IF EXISTS :vSCHEMA.wdpa_wdoecm_:vDATE;
CREATE TABLE :vSCHEMA.wdpa_wdoecm_:vDATE AS
WITH
geoms AS (SELECT * FROM :vSCHEMA.wdpa_wdoecm_geom_:vDATE),
atts AS (SELECT * FROM :vSCHEMA.wdpa_wdoecm_atts_:vDATE),
redundant_atts AS (
SELECT
*
FROM atts
WHERE gis_area IN (
    SELECT
    MAX(gis_area)
    FROM atts
    WHERE wdpaid IN (SELECT wdpaid FROM geoms)
    GROUP BY wdpaid
    HAVING count(wdpa_pid) > 1
    ORDER BY wdpaid
    ) 
	AND wdpa_pid NOT IN ('555629232_B','522_B') --ADDED ON 2nd April 2019 to avoid duplicated wdpaid in output.
ORDER BY
wdpaid,wdpa_pid),

non_redundant_atts AS (
SELECT
*
FROM atts
WHERE wdpaid IN (
    SELECT
  wdpaid
    FROM atts
    WHERE wdpaid IN (SELECT wdpaid FROM geoms)
    GROUP BY wdpaid
    HAVING count(wdpa_pid) = 1
    ORDER BY wdpaid
    )
ORDER BY
wdpaid,wdpa_pid),

relevant_atts AS (
SELECT * FROM redundant_atts
UNION
SELECT * FROM non_redundant_atts
ORDER BY wdpaid,wdpa_pid)

SELECT
a.*,
b.type,
b.parcels,
b.area_geo,
b.geom
FROM relevant_atts a
JOIN geoms b ON a.wdpaid=b.wdpaid
ORDER BY a.wdpaid;

ALTER TABLE :vSCHEMA.wdpa_wdoecm_:vDATE
ADD PRIMARY KEY (wdpaid),
DROP COLUMN ogc_fid;
CREATE INDEX wdpa_wdoecm_:vDATE:vidx ON :vSCHEMA.wdpa_wdoecm_:vDATE USING gist(geom);

/* -- CREATE FINAL WDPA OVER 5 sqkm TABLE
DROP TABLE IF EXISTS :vSCHEMA.wdoecm_o5_:vDATE;
CREATE TABLE :vSCHEMA.wdoecm_o5_:vDATE AS
SELECT 
*
FROM :vSCHEMA.wdoecm_:vDATE
WHERE area_geo >= :THRESHOLD and type NOT IN ('Point')
ORDER BY wdpaid;

ALTER TABLE :vSCHEMA.wdoecm_o5_:vDATE
ADD PRIMARY KEY (wdpaid);
CREATE INDEX wdoecm_o5_:vDATE:vgeomidx ON :vSCHEMA.wdoecm_o5_:vDATE USING gist (geom);
CREATE INDEX wdoecm_o5_:vDATE:vwdpaididx ON :vSCHEMA.wdoecm_o5_:vDATE USING btree (wdpaid); */

