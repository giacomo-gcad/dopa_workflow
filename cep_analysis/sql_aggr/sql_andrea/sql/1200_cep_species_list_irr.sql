DROP TABLE IF EXISTS s;CREATE TEMPORARY TABLE s AS
SELECT qid,cid,UNNEST(:v_topic) id_no,sqkm FROM species_202001_:v_topic.h_flat ORDER BY cid,id_no;
DROP TABLE IF EXISTS s1;CREATE TEMPORARY TABLE s1 AS
SELECT id_no,SUM(sqkm) range_sqkm FROM s GROUP BY id_no ORDER BY id_no;
DROP TABLE IF EXISTS s2;CREATE TEMPORARY TABLE s2 AS
SELECT DISTINCT cid,id_no FROM s ORDER BY cid,id_no;

-- select info from intermediate stage
DROP TABLE IF EXISTS b;CREATE TEMPORARY TABLE b AS
SELECT DISTINCT wdpaid,cat cid,theme_sqkm,tot_sqkm FROM :v_rcep_out.wdpa_intermediate_species_:v_topic ORDER BY cid,wdpaid;
DROP TABLE IF EXISTS b1;CREATE TEMPORARY TABLE b1 AS
SELECT DISTINCT wdpaid,tot_sqkm FROM b ORDER BY wdpaid;
-------------------------------------------------------
-- JOIN species and pa info
DROP TABLE IF EXISTS c;
CREATE TEMPORARY TABLE c AS
SELECT wdpaid,id_no,SUM(theme_sqkm) theme_sqkm FROM b JOIN s2 USING(cid) GROUP BY wdpaid,id_no ORDER BY wdpaid,id_no;

DROP TABLE IF EXISTS c1;
CREATE TEMPORARY TABLE c1 AS
SELECT wdpaid,id_no,tot_sqkm pa_sqkm,range_sqkm,theme_sqkm species_sqkm FROM c LEFT JOIN s1 USING(id_no) LEFT JOIN b1 USING (wdpaid)
ORDER BY wdpaid,id_no;

DROP TABLE IF EXISTS :v_rcep_out.wdpa_species_:v_topic_irr;
CREATE TABLE :v_rcep_out.wdpa_species_:v_topic_irr AS
SELECT * FROM c1;
