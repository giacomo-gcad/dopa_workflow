CREATE TABLE protected_sites.wdoecm_geom_202003 AS

WITH

polygons AS (
SELECT
CAST(WDPAID AS integer) as wdpaid,
COUNT(WDPAID) AS parcels,
'Polygon' AS type,
ST_UNION(wkb_geometry) AS geom
FROM protected_sites.wdoecm_poly_202003
WHERE
WDPAID IN (
SELECT WDPAID
FROM protected_sites.wdoecm_poly_202003
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
GROUP BY WDPAID
HAVING COUNT(WDPAID) > 1
)
GROUP BY WDPAID
UNION
SELECT
CAST(WDPAID AS integer) as wdpaid,
CAST('1' AS integer) AS parcels,
'Polygon' AS type,
wkb_geometry AS geom
FROM protected_sites.wdoecm_poly_202003
WHERE
WDPAID IN (
SELECT WDPAID
FROM protected_sites.wdoecm_poly_202003
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
GROUP BY WDPAID
HAVING COUNT(WDPAID) = 1)
)

SELECT
wdpaid,
parcels,
type,
geom FROM polygons;

CREATE INDEX wdoecm_geom_202003_idx ON protected_sites.wdoecm_geom_202003 USING gist(geom);

-- SECOND PART: Repair invalid geometries
ALTER TABLE protected_sites.wdoecm_geom_202003
ADD COLUMN geom_was_invalid boolean DEFAULT FALSE;

UPDATE protected_sites.wdoecm_geom_202003
SET geom_was_invalid = TRUE 
WHERE ST_IsValid(geom) IS FALSE;

UPDATE protected_sites.wdoecm_geom_202003
SET geom = ST_MakeValid(geom)
WHERE geom_was_invalid IS TRUE;

ALTER TABLE protected_sites.wdoecm_geom_202003
--DROP COLUMN geom_was_invalid,
ADD COLUMN area_geo double precision;

UPDATE protected_sites.wdoecm_geom_202003
SET area_geo = (ST_AREA(geom::geography)/1000000);

-- THIRD PART: Create final tables

DROP TABLE IF EXISTS protected_sites.wdoecm_202003;
CREATE TABLE protected_sites.wdoecm_202003 AS
WITH
geoms AS (SELECT * FROM protected_sites.wdoecm_geom_202003),
atts AS (SELECT * FROM protected_sites.wdoecm_atts_202003),
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

ALTER TABLE protected_sites.wdoecm_202003
ADD PRIMARY KEY (wdpaid),
DROP COLUMN ogc_fid;
CREATE INDEX wdoecm_202003_idx ON protected_sites.wdoecm_202003 USING gist(geom);

