CREATE TABLE :vSCHEMA.wdpa_geom_:vDATE AS

WITH

polygons AS (
SELECT
CAST(WDPAID AS integer) as wdpaid,
COUNT(WDPAID) AS parcels,
'Polygon' AS type,
ST_UNION(wkb_geometry) AS geom
FROM :vSCHEMA.:vINNAME_POLY
WHERE
WDPAID IN (
SELECT WDPAID
FROM :vSCHEMA.:vINNAME_POLY
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
AND 
WDPAID NOT IN (903141) -- from February 2018: wdpaid 903141 (Primeval Beech Forests of the Carpathians and Other Regions of Europe) is excluded from all the analysis
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
FROM :vSCHEMA.:vINNAME_POLY
WHERE
WDPAID IN (
SELECT WDPAID
FROM :vSCHEMA.:vINNAME_POLY
WHERE STATUS NOT IN ('Not Reported', 'Proposed')
AND
DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')
AND
WDPAID NOT IN (903141) -- from February 2018: wdpaid 903141 (Primeval Beech Forests of the Carpathians and Other Regions of Europe) is excluded from all the analysis
GROUP BY WDPAID
HAVING COUNT(WDPAID) = 1)
),

points AS (
SELECT
CAST(WDPAID AS integer) as wdpaid,
'Point' AS type,
REP_AREA AS rep_areas,
wkb_geometry AS geom
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
geom FROM polygons -- modified on :vDATE25
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
CREATE INDEX wdpa_geom_:vDATE:vidx ON :vSCHEMA.wdpa_geom_:vDATE USING gist(geom);

-- SECOND PART: Repair invalid geometries
ALTER TABLE :vSCHEMA.wdpa_geom_:vDATE
ADD COLUMN geom_was_invalid boolean DEFAULT FALSE;

UPDATE :vSCHEMA.wdpa_geom_:vDATE
SET geom_was_invalid = TRUE 
WHERE ST_IsValid(geom) IS FALSE;

UPDATE :vSCHEMA.wdpa_geom_:vDATE
SET geom = ST_MakeValid(geom)
WHERE geom_was_invalid IS TRUE;

ALTER TABLE :vSCHEMA.wdpa_geom_:vDATE
--DROP COLUMN geom_was_invalid,
ADD COLUMN area_geo double precision;

UPDATE :vSCHEMA.wdpa_geom_:vDATE
SET area_geo = (ST_AREA(geom::geography)/1000000);

-- THIRD PART: Create final tables

DROP TABLE IF EXISTS :vSCHEMA.wdpa_:vDATE;
CREATE TABLE :vSCHEMA.wdpa_:vDATE AS
WITH
geoms AS (SELECT * FROM :vSCHEMA.wdpa_geom_:vDATE),
atts AS (SELECT * FROM :vSCHEMA.wdpa_atts_:vDATE),
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

ALTER TABLE :vSCHEMA.wdpa_:vDATE
ADD PRIMARY KEY (wdpaid),
DROP COLUMN ogc_fid;
CREATE INDEX wdpa_:vDATE:vidx ON :vSCHEMA.wdpa_:vDATE USING gist(geom);

-- CREATE FINAL WDPA OVER 5 sqkm TABLE
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o5_:vDATE;
CREATE TABLE :vSCHEMA.wdpa_o5_:vDATE AS
SELECT 
*
FROM :vSCHEMA.wdpa_:vDATE
WHERE area_geo >= :THRESHOLD and type NOT IN ('Point')
ORDER BY wdpaid;

ALTER TABLE :vSCHEMA.wdpa_o5_:vDATE
ADD PRIMARY KEY (wdpaid);
CREATE INDEX wdpa_o5_:vDATE:vgeomidx ON :vSCHEMA.wdpa_o5_:vDATE USING gist (geom);
CREATE INDEX wdpa_o5_:vDATE:vwdpaididx ON :vSCHEMA.wdpa_o5_:vDATE USING btree (wdpaid);

