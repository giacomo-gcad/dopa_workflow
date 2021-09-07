-- THIRD PART: ADD area_geo

ALTER TABLE protected_sites.wdoecm_geom_202101
--DROP COLUMN geom_was_invalid,
ADD COLUMN area_geo double precision;

UPDATE protected_sites.wdoecm_geom_202101
SET area_geo = (ST_AREA(geom::geography)/1000000);

-- FOURTH PART: Create final tables

DROP TABLE IF EXISTS protected_sites.wdoecm_202101;
CREATE TABLE protected_sites.wdoecm_202101 AS
WITH
geoms AS (SELECT * FROM protected_sites.wdoecm_geom_202101),
atts AS (SELECT * FROM protected_sites.wdoecm_atts_202101),
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

ALTER TABLE protected_sites.wdoecm_202101
ADD PRIMARY KEY (wdpaid),
DROP COLUMN ogc_fid;
CREATE INDEX wdoecm_202101_idx ON protected_sites.wdoecm_202101 USING gist(geom)
