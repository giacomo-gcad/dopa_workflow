--FIRST PART: SELECT RELEVANT POLYGONS AND POINTS; MAKE BUFFERS ON POINTS, WRITE GEOMS

DROP TABLE IF EXISTS :vSCHEMA.wdpa_wdoecm_geom_:vDATE;
CREATE TABLE :vSCHEMA.wdpa_wdoecm_geom_:vDATE AS

WITH

polygons AS (
SELECT
CAST(WDPAID AS integer) as wdpaid,
COUNT(WDPAID) AS parcels,
'Polygon' AS type,
ST_UNION(shape) AS geom 
FROM :vSCHEMA.:vINNAME_POLY
WHERE
WDPAID IN (
SELECT WDPAID
FROM :vSCHEMA.:vINNAME_POLY
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
-- AND pa_def='0'        -- THIS ALLOWS TO PROCESS ONLY WDOECM 
GROUP BY WDPAID
HAVING COUNT(WDPAID) > 1
)
GROUP BY WDPAID
UNION
SELECT
CAST(WDPAID AS integer) as wdpaid,
CAST('1' AS integer) AS parcels,
'Polygon' AS type,
shape AS geom
FROM :vSCHEMA.:vINNAME_POLY
WHERE
WDPAID IN (
SELECT WDPAID
FROM :vSCHEMA.:vINNAME_POLY
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
-- AND pa_def='0'        -- THIS ALLOWS TO PROCESS ONLY WDOECM 
GROUP BY WDPAID
HAVING COUNT(WDPAID) = 1)
),

points AS (
SELECT
CAST(WDPAID AS integer) as wdpaid,
'Point' AS type,
REP_AREA AS rep_areas,
shape AS geom
FROM :vSCHEMA.:vINNAME_POINT
WHERE
WDPAID IN (
SELECT WDPAID
FROM :vSCHEMA.:vINNAME_POINT
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
AND
REP_AREA > 0)
-- AND pa_def='0'        -- THIS ALLOWS TO PROCESS ONLY WDOECM 
),

non_intersecting_points AS (
SELECT
a.wdpaid,
a.type,
b.parcels,
(ST_Buffer(a.geom::geography(MultiPoint),b.radius*1000))::geometry(Polygon) as geom  -- modified on :vDATE25
FROM points a
JOIN (
	SELECT
	wdpaid,
	COUNT(wdpaid)::integer AS parcels,
	sqrt(
		(rep_areas/(COUNT(wdpaid)::integer))/pi()
	) as radius
	FROM points
	GROUP BY wdpaid,rep_areas
	) b on a.wdpaid=b.wdpaid
	WHERE ST_INTERSECTS((ST_Buffer(a.geom::geography(MultiPoint),b.radius*1000)), ST_GeogFromText('LINESTRING(180 -90, 180 0, 180 90)')) IS false  -- modified on :vDATE25
	),

points_output_1 AS (
SELECT
wdpaid,
type,
parcels,
ST_MULTI(ST_Union(geom)) as geom
FROM non_intersecting_points
GROUP BY
wdpaid,
type,
parcels),

intersecting_points AS (
SELECT
a.wdpaid,
a.type,
b.parcels,
ST_Split(((ST_Buffer(ST_Translate(a.geom, +180, 0)::geography(MultiPoint),b.radius*1000))::geometry(Polygon)), ST_GeomFromText('LINESTRING(0 -90, 0 90)',4326)) as geom  -- modified on :vDATE25
FROM points a
JOIN (
	SELECT
	wdpaid,
	COUNT(wdpaid)::integer AS parcels,
	sqrt(
		(rep_areas/(COUNT(wdpaid)::integer))/pi()
	) as radius
	FROM points
	GROUP BY wdpaid,rep_areas
	) b on a.wdpaid=b.wdpaid
WHERE a.wdpaid NOT IN (SELECT wdpaid FROM points_output_1)
),

reshifted_points AS (
SELECT
wdpaid,
type,
parcels,
id,
CASE WHEN ST_XMAX(geom) > 0
THEN
ST_Translate(geom, -180, 0)
ELSE
ST_Translate(geom, 180, 0)
END AS geom
FROM (SELECT
wdpaid,
type,
parcels,
(ST_Dump(geom)).path[1] id,
(ST_Dump(geom)).geom geom
FROM intersecting_points) as shifted_points),

points_output_2 as (
SELECT
wdpaid,
type,
parcels,
ST_MULTI(ST_UNION(geom)) as geom
FROM reshifted_points
GROUP BY
wdpaid,
type,
parcels)

SELECT
wdpaid,
parcels,
type,
geom FROM polygons
UNION
SELECT
wdpaid,
parcels,
type,
geom
FROM points_output_1
UNION
SELECT
wdpaid,
parcels,
type,
geom
FROM points_output_2;
CREATE INDEX wdpa_wdoecm_geom_:vDATE:vidx ON :vSCHEMA.wdpa_wdoecm_geom_:vDATE USING gist(geom);

-- SECOND PART: MARK INVALID GEOMS (TO BE MANUALLY REPAIRED LATER)
ALTER TABLE :vSCHEMA.wdpa_wdoecm_geom_:vDATE
ADD COLUMN geom_was_invalid boolean DEFAULT FALSE;

UPDATE :vSCHEMA.wdpa_wdoecm_geom_:vDATE
SET geom_was_invalid = TRUE 
WHERE ST_IsValid(geom) IS FALSE;
