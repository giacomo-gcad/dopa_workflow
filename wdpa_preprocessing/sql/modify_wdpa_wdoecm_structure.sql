-- RENAME GEOMETRY COLUMN
ALTER TABLE :POLYGONS RENAME COLUMN wkb_geometry TO shape;
ALTER TABLE :POINTS RENAME COLUMN wkb_geometry TO shape;

-- DROP AND ADD COLUMNS
ALTER TABLE :POLYGONS
DROP COLUMN IF EXISTS wdpaid,
DROP COLUMN IF EXISTS wdpa_pid,
DROP COLUMN IF EXISTS pa_def, 
DROP COLUMN IF EXISTS marine; 

ALTER TABLE :POLYGONS
ADD COLUMN wdpaid integer,
ADD COLUMN wdpa_pid text,
ADD COLUMN pa_def integer,
ADD COLUMN marine integer;

ALTER TABLE :POINTS
DROP COLUMN IF EXISTS wdpaid,
DROP COLUMN IF EXISTS wdpa_pid, 
DROP COLUMN IF EXISTS pa_def, 
DROP COLUMN IF EXISTS marine; 

ALTER TABLE :POINTS
ADD COLUMN wdpaid integer,
ADD COLUMN wdpa_pid text,
ADD COLUMN pa_def integer,
ADD COLUMN marine integer;

ALTER TABLE :ATTRIBUTES
DROP COLUMN IF EXISTS wdpaid, 
DROP COLUMN IF EXISTS wdpa_pid, 
DROP COLUMN IF EXISTS pa_def, 
DROP COLUMN IF EXISTS marine; 

ALTER TABLE :ATTRIBUTES
ADD COLUMN wdpaid integer,
ADD COLUMN wdpa_pid text,
ADD COLUMN pa_def integer,
ADD COLUMN marine integer;

-- UPDATE COLUMNS FOR WDPAID, WDPA_PID, PA_DEF AND MARINE
UPDATE :POLYGONS SET wdpaid = site_id;
UPDATE :POINTS SET wdpaid = site_id;
UPDATE :ATTRIBUTES SET wdpaid = site_id;

UPDATE :POLYGONS SET wdpa_pid = site_pid;
UPDATE :POINTS SET wdpa_pid = site_pid;
UPDATE :ATTRIBUTES SET wdpa_pid = site_pid;

UPDATE :POLYGONS SET pa_def = 0 WHERE site_type='OECM';
UPDATE :POLYGONS SET pa_def = 1 WHERE site_type='PA';
UPDATE :POINTS SET pa_def = 1 WHERE site_type='PA';
UPDATE :POINTS SET pa_def = 0 WHERE site_type='OECM';
UPDATE :ATTRIBUTES SET pa_def = 1 WHERE site_type='PA';
UPDATE :ATTRIBUTES SET pa_def = 0 WHERE site_type='OECM';

UPDATE :POLYGONS SET marine = 0 WHERE realm='Terrestrial';
UPDATE :POLYGONS SET marine = 1 WHERE realm='Coastal';
UPDATE :POLYGONS SET marine = 2 WHERE realm='Marine';
UPDATE :POINTS SET marine = 0 WHERE realm='Terrestrial';
UPDATE :POINTS SET marine = 1 WHERE realm='Coastal';
UPDATE :POINTS SET marine = 2 WHERE realm='Marine';
UPDATE :ATTRIBUTES SET marine = 0 WHERE realm='Terrestrial';
UPDATE :ATTRIBUTES SET marine = 1 WHERE realm='Coastal';
UPDATE :ATTRIBUTES SET marine = 2 WHERE realm='Marine';


