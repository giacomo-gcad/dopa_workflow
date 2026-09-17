-- prepare threatened
DROP TABLE IF EXISTS t;CREATE TEMPORARY TABLE t AS
SELECT id_no FROM species.dopa_species WHERE threatened IS TRUE ORDER BY id_no;
-- prepare endemic
DROP TABLE IF EXISTS e;CREATE TEMPORARY TABLE e AS
SELECT id_no FROM species.dopa_species WHERE endemic IS TRUE ORDER BY id_no;
-- prepare threatened endemic
DROP TABLE IF EXISTS te;CREATE TEMPORARY TABLE te AS
SELECT id_no FROM species.dopa_species WHERE threatened IS TRUE AND endemic IS TRUE ORDER BY id_no;

\set o_richness :v_topic'_richness'
\set o_threatened :v_topic'_threatened'
\set o_richness_threatened :v_topic'_threatened_richness'
\set o_endemic :v_topic'_endemic'
\set o_richness_endemic :v_topic'_endemich_richness'
\set o_threatened_endemic :v_topic'_threatened_endemic'
\set o_richness_threatened_endemic :v_topic'_richness_threatened_endemic'

-- import info from species dataset
DROP TABLE IF EXISTS s;CREATE TEMPORARY TABLE s AS
SELECT DISTINCT cid,UNNEST(:v_topic) id_no FROM species.flat_:v_topic ORDER BY cid,id_no;

------------------------------------------------------
--COUNTRY
------------------------------------------------------

-- select info from intermediate stage
DROP TABLE IF EXISTS b;CREATE TEMPORARY TABLE b AS
SELECT DISTINCT country_id,cat cid FROM :v_rcep_out.country_intermediate_species_:v_topic ORDER BY cid,country_id;
-------------------------------------------------------
-- list threatened
DROP TABLE IF EXISTS s_t;CREATE TEMPORARY TABLE s_t AS
SELECT cid,id_no FROM s NATURAL JOIN t;
-- list endemic
DROP TABLE IF EXISTS s_e;CREATE TEMPORARY TABLE s_e AS
SELECT cid,id_no FROM s NATURAL JOIN e;
-- list endemic
DROP TABLE IF EXISTS s_te;CREATE TEMPORARY TABLE s_te AS
SELECT cid,id_no FROM s  NATURAL JOIN te;

-- JOIN species and pa info
DROP TABLE IF EXISTS c;CREATE TEMPORARY TABLE c AS
SELECT *,
CARDINALITY(species) richness_species,
CARDINALITY(species_threatened) richness_species_threatened,
CARDINALITY(species_endemic) richness_species_endemic,
CARDINALITY(species_threatened_endemic) richness_species_threatened_endemic
FROM 
(SELECT country_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species
 FROM b JOIN s USING(cid)
 GROUP BY country_id ORDER BY country_id) ps
LEFT JOIN
(SELECT country_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_threatened
 FROM b JOIN s_t USING(cid)
 GROUP BY country_id ORDER BY country_id) pst
USING(country_id)
LEFT JOIN
(SELECT country_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_endemic
 FROM b JOIN s_e USING(cid)
 GROUP BY country_id ORDER BY country_id) pse
USING(country_id)
LEFT JOIN
(SELECT country_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_threatened_endemic
 FROM b JOIN s_te USING(cid) GROUP BY country_id ORDER BY country_id) pste
USING(country_id)
ORDER BY country_id;

DROP TABLE IF EXISTS :v_rcep_out.country_species_:v_topic;
CREATE TABLE :v_rcep_out.country_species_:v_topic AS
SELECT 
country_id,
species :v_topic,
richness_species :o_richness,
species_threatened :o_threatened,
richness_species_threatened :o_richness_threatened,
species_endemic :o_endemic,
richness_species_endemic :o_richness_endemic,
species_threatened_endemic :o_threatened_endemic,
richness_species_threatened_endemic :o_richness_threatened_endemic
FROM c
ORDER BY country_id;

------------------------------------------------------
--ECOREGION
------------------------------------------------------
-- select info from intermediate stage
DROP TABLE IF EXISTS b;CREATE TEMPORARY TABLE b AS
SELECT DISTINCT eco_id,cat cid FROM :v_rcep_out.ecoregion_intermediate_species_:v_topic ORDER BY cid,eco_id;
-------------------------------------------------------
-- list threatened
DROP TABLE IF EXISTS s_t;CREATE TEMPORARY TABLE s_t AS
SELECT cid,id_no FROM s NATURAL JOIN t;
-- list endemic
DROP TABLE IF EXISTS s_e;CREATE TEMPORARY TABLE s_e AS
SELECT cid,id_no FROM s NATURAL JOIN e;
-- list endemic
DROP TABLE IF EXISTS s_te;CREATE TEMPORARY TABLE s_te AS
SELECT cid,id_no FROM s  NATURAL JOIN te;

-- JOIN species and pa info
DROP TABLE IF EXISTS c;CREATE TEMPORARY TABLE c AS
SELECT *,
CARDINALITY(species) richness_species,
CARDINALITY(species_threatened) richness_species_threatened,
CARDINALITY(species_endemic) richness_species_endemic,
CARDINALITY(species_threatened_endemic) richness_species_threatened_endemic
FROM 
(SELECT eco_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species
 FROM b JOIN s USING(cid)
 GROUP BY eco_id ORDER BY eco_id) ps
LEFT JOIN
(SELECT eco_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_threatened
 FROM b JOIN s_t USING(cid)
 GROUP BY eco_id ORDER BY eco_id) pst
USING(eco_id)
LEFT JOIN
(SELECT eco_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_endemic
 FROM b JOIN s_e USING(cid)
 GROUP BY eco_id ORDER BY eco_id) pse
USING(eco_id)
LEFT JOIN
(SELECT eco_id,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_threatened_endemic
 FROM b JOIN s_te USING(cid) GROUP BY eco_id ORDER BY eco_id) pste
USING(eco_id)
ORDER BY eco_id;

DROP TABLE IF EXISTS :v_rcep_out.ecoregion_species_:v_topic;
CREATE TABLE :v_rcep_out.ecoregion_species_:v_topic AS
SELECT 
eco_id,
species :v_topic,
richness_species :o_richness,
species_threatened :o_threatened,
richness_species_threatened :o_richness_threatened,
species_endemic :o_endemic,
richness_species_endemic :o_richness_endemic,
species_threatened_endemic :o_threatened_endemic,
richness_species_threatened_endemic :o_richness_threatened_endemic
FROM c
ORDER BY eco_id;


------------------------------------------------------
--PA
------------------------------------------------------
-- select info from intermediate stage
DROP TABLE IF EXISTS b;CREATE TEMPORARY TABLE b AS
SELECT DISTINCT wdpaid,cat cid FROM :v_rcep_out.wdpa_intermediate_species_:v_topic ORDER BY cid,wdpaid;
-------------------------------------------------------
-- list threatened
-- list threatened
DROP TABLE IF EXISTS s_t;CREATE TEMPORARY TABLE s_t AS
SELECT cid,id_no FROM s NATURAL JOIN t;
-- list endemic
DROP TABLE IF EXISTS s_e;CREATE TEMPORARY TABLE s_e AS
SELECT cid,id_no FROM s NATURAL JOIN e;
-- list endemic
DROP TABLE IF EXISTS s_te;CREATE TEMPORARY TABLE s_te AS
SELECT cid,id_no FROM s  NATURAL JOIN te;

-- JOIN species and pa info
DROP TABLE IF EXISTS c;CREATE TEMPORARY TABLE c AS
SELECT *,
CARDINALITY(species) richness_species,
CARDINALITY(species_threatened) richness_species_threatened,
CARDINALITY(species_endemic) richness_species_endemic,
CARDINALITY(species_threatened_endemic) richness_species_threatened_endemic
FROM 
(SELECT wdpaid,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species
 FROM b JOIN s USING(cid)
 GROUP BY wdpaid ORDER BY wdpaid) ps
LEFT JOIN
(SELECT wdpaid,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_threatened
 FROM b JOIN s_t USING(cid)
 GROUP BY wdpaid ORDER BY wdpaid) pst
USING(wdpaid)
LEFT JOIN
(SELECT wdpaid,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_endemic
 FROM b JOIN s_e USING(cid)
 GROUP BY wdpaid ORDER BY wdpaid) pse
USING(wdpaid)
LEFT JOIN
(SELECT wdpaid,ARRAY_AGG(DISTINCT id_no ORDER BY id_no) species_threatened_endemic
 FROM b JOIN s_te USING(cid) GROUP BY wdpaid ORDER BY wdpaid) pste
USING(wdpaid)
ORDER BY wdpaid;

DROP TABLE IF EXISTS :v_rcep_out.wdpa_species_:v_topic;
CREATE TABLE :v_rcep_out.wdpa_species_:v_topic AS
SELECT 
wdpaid,
species :v_topic,
richness_species :o_richness,
species_threatened :o_threatened,
richness_species_threatened :o_richness_threatened,
species_endemic :o_endemic,
richness_species_endemic :o_richness_endemic,
species_threatened_endemic :o_threatened_endemic,
richness_species_threatened_endemic :o_richness_threatened_endemic
FROM c
ORDER BY wdpaid;


