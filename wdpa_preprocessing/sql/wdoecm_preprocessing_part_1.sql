CREATE TABLE protected_sites.wdoecm_geom_202101 AS

WITH

polygons AS (
SELECT
CAST(WDPAID AS integer) as wdpaid,
COUNT(WDPAID) AS parcels,
'Polygon' AS type,
ST_UNION(wkb_geometry) AS geom
FROM protected_sites.wdoecm_poly_202101
WHERE
WDPAID IN (
SELECT WDPAID
FROM protected_sites.wdoecm_poly_202101
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
FROM protected_sites.wdoecm_poly_202101
WHERE
WDPAID IN (
SELECT WDPAID
FROM protected_sites.wdoecm_poly_202101
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

CREATE INDEX wdoecm_geom_202101_idx ON protected_sites.wdoecm_geom_202101 USING gist(geom);

-- SECOND PART: Repair invalid geometries
ALTER TABLE protected_sites.wdoecm_geom_202101
ADD COLUMN geom_was_invalid boolean DEFAULT FALSE;

UPDATE protected_sites.wdoecm_geom_202101
SET geom_was_invalid = TRUE 
WHERE ST_IsValid(geom) IS FALSE;

