-- MANUAL PROCEDURE FOR REPAIRING GEOMETRIES
-- 1) EDIT INPUT TABLE NAMES (protected_sites.wdpa_geom_yyyymm and protected_sites.wdpa_poly_input_yyyymm)
-- 2) EXECUTE IN PGADMIN STEP BY STEP

DROP TABLE IF EXISTS wdpa_check01;
CREATE TEMPORARY TABLE wdpa_check01 AS
WITH
a AS (SELECT wdpaid FROM protected_sites.wdpa_geom_202101 WHERE geom_was_invalid IS TRUE),
b AS (SELECT wdpaid,(ST_Dump(ST_Multi(shape))).* FROM  protected_sites.wdpa_poly_input_202101 WHERE wdpaid IN (SELECT wdpaid FROM a)),
c AS (SELECT wdpaid,UNNEST(path) path,geom,(ST_IsValidDetail(geom)).*,ST_GeometryType(geom) FROM b) -- this is important
SELECT * FROM c;

DROP TABLE IF EXISTS wdpa_check02;
CREATE TEMPORARY TABLE wdpa_check02 AS
SELECT wdpaid,'point' t,path,ST_SetSRID(location,4326) point FROM wdpa_check01 WHERE valid IS FALSE -- this allows you to check where the issue is
UNION
SELECT wdpaid,'poly' t,path,geom FROM wdpa_check01 WHERE valid IS FALSE;

SELECT * FROM wdpa_check02; -- visual check, point by point

DROP TABLE IF EXISTS wdpa_check03;
CREATE TEMPORARY TABLE wdpa_check03 AS
SELECT (ST_DUMPRINGS(ST_MAKEVALID(geom))).* FROM wdpa_check01 where wdpaid =203484 AND path = 1; -- this splits the rings, selecting only the linear features 

DROP TABLE IF EXISTS wdpa_correction;
CREATE TEMPORARY TABLE wdpa_correction AS
SELECT 203484 wdpaid,ST_MULTI(geom) geom FROM wdpa_check03 WHERE 0=ANY(path) -- check before which is the correct ring

UPDATE protected_sites.wdpa_geom_202101
SET geom=b.geom
FROM (SELECT * FROM wdpa_correction) b
WHERE wdpa_geom_202101.wdpaid=b.wdpaid; -- check before that the original geom doesn't contain further geometries (the check is coming from a dump)

-- if the original geom is multipart, ST_COLLECT the geoms FROM the ST_DUMP WHERE valid IS TRUE UNION the corrected geom 