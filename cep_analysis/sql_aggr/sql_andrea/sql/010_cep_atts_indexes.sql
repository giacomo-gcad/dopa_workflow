-------------------------------------------------------------------------------------
-- SETTINGS BLOCK: CHANGE HERE TO UPDATE DATA (BACKUP THE current cep,cep_indexes,t_atts)
---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS :v_rcep_in.atts_country_last;CREATE TABLE :v_rcep_in.atts_country_last AS -- COUNTRY ATTRIBUTES
SELECT country_id country,country_name,iso3,iso2,un_m49,status FROM administrative_units.:v_country;
---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS :v_rcep_in.atts_ecoregion_last;CREATE TABLE :v_rcep_in.atts_ecoregion_last AS -- ECOREGION ATTRIBUTES
SELECT first_level_code ecoregion,first_level ecoregion_name,second_level_code,second_level,third_level_code,third_level,source,
CASE WHEN source IN ('eeow','teow') THEN FALSE ELSE TRUE END is_marine
FROM habitats_and_biotopes.:v_ecoregion;
---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS :v_rcep_in.atts_pa_last;CREATE TABLE :v_rcep_in.atts_pa_last AS -- WDPA ATTRIBUTES
SELECT wdpaid pa,name pa_name,desig_eng,iucn_cat,marine,CASE WHEN metadataid=1832 THEN TRUE ELSE FALSE END is_n2k,iso3,type,area_geo
FROM protected_sites.:v_wdpa;
-----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS :v_rcep_in.grid_vector;CREATE TABLE :v_rcep_in.grid_vector AS
SELECT * FROM cep.grid_vector;
ALTER TABLE :v_rcep_in.grid_vector ADD PRIMARY KEY (qid);CREATE INDEX ON :v_rcep_in.grid_vector USING gist(geom);
---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS country_eco;CREATE TEMPORARY TABLE country_eco AS
WITH
a AS (SELECT qid,cid,UNNEST(country) country,UNNEST(eco) ecoregion,CASE WHEN 0=ANY(pa) THEN false ELSE true END is_protected, sqkm FROM cep.:v_cep),
b AS (SELECT country,country_name,iso3 FROM :v_rcep_in.atts_country_last),
c AS (SELECT ecoregion,ecoregion_name,source,is_marine FROM :v_rcep_in.atts_ecoregion_last),
d AS (SELECT qid,cid,country,country_name,iso3,ecoregion,ecoregion_name,source,is_marine,is_protected,sqkm FROM a JOIN b USING (country) JOIN c USING (ecoregion))
SELECT * FROM d;
---------------------------------------------------------------------------------------
-- OUTPUT BLOCK
---------------------------------------------------------------------------------------
-- CEP INDEX
DROP TABLE IF EXISTS :v_rcep_in.index_cep_last;CREATE TABLE :v_rcep_in.index_cep_last AS
WITH
a1 AS (SELECT qid,cid,u.*,pa FROM cep.cep_last,UNNEST(country,eco) AS u(country,eco)),
a AS (SELECT qid,cid,country,eco,UNNEST(pa) pa FROM a1)
SELECT a.qid,a.cid,a.country,b.country_name,b.iso3,a.eco,c.ecoregion_name,
CASE WHEN c.source IN ('teow','eeow') THEN false::bool ELSE true::bool END is_marine,
a.pa,d.pa_name,
CASE a.pa WHEN 0 THEN false::bool ELSE true::bool END is_protected,
e.sqkm
FROM a
LEFT JOIN :v_rcep_in.atts_country_last b ON a.country=b.country
LEFT JOIN :v_rcep_in.atts_ecoregion_last c ON a.eco=c.ecoregion
LEFT JOIN :v_rcep_in.atts_pa_last d ON a.pa=d.pa
LEFT JOIN cep.cep_last e USING(qid,cid)
ORDER BY a.qid,a.cid;
-- COUNTRY
DROP TABLE IF EXISTS :v_rcep_in.index_country_cep_last;CREATE TABLE :v_rcep_in.index_country_cep_last AS
SELECT country,country_name,iso3,is_marine,is_protected,qid,cid,sqkm FROM country_eco ORDER BY country,qid,cid;
-- ECOREGION
DROP TABLE IF EXISTS :v_rcep_in.index_ecoregion_cep_last;CREATE TABLE :v_rcep_in.index_ecoregion_cep_last AS
SELECT ecoregion,ecoregion_name,source,is_marine,is_protected,qid,cid,sqkm FROM country_eco ORDER BY ecoregion,qid,cid;
-- PA
DROP TABLE IF EXISTS :v_rcep_in.index_pa_cep_last;CREATE TABLE :v_rcep_in.index_pa_cep_last AS
WITH
a AS (SELECT UNNEST(pa) pa,qid,cid,sqkm FROM cep.:v_cep WHERE 0!=ANY(pa))
SELECT pa,pa_name,iso3,marine,type,qid,cid,sqkm FROM a JOIN :v_rcep_in.atts_pa_last b USING(pa) ORDER BY pa,qid,cid;
-- BU INDEX
DROP TABLE IF EXISTS :v_rcep_in.index_bu_last;CREATE TABLE :v_rcep_in.index_bu_last AS
SELECT UNNEST(buffers) bu,qid,cid,sqkm FROM cep.:v_buffers ORDER BY bu,qid,cid;
