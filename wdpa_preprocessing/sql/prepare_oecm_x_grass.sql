-- CREATE TABLES WITH LIST OF OECM and BUs of OECM (All, only terrestrial and coastal, only marine)
CREATE TABLE :paschema.list_oecm AS
SELECT 'pa_'||wdpaid::text gname
FROM :wdpaschema.wdoecm_o5_:vDATE
ORDER BY wdpaid;

CREATE TABLE :paschema.list_oecm_tc AS
SELECT 'pa_'||wdpaid::text gname
FROM :wdpaschema.wdoecm_o5_:vDATE 
WHERE marine NOT IN (2)
ORDER BY wdpaid;

CREATE TABLE :paschema.list_oecm_ma AS
SELECT 'pa_'||wdpaid::text gname
FROM :wdpaschema.wdoecm_o5_:vDATE 
WHERE marine IN (2)
ORDER BY wdpaid;

CREATE TABLE :buschema.list_bu_oecm AS
SELECT 'bu_'||wdpaid::text gname
FROM :wdpaschema.wdoecm_o5_buffers_:vDATE
ORDER BY wdpaid;

CREATE TABLE :buschema.list_bu_oecm_tc AS
SELECT 'bu_'||wdpaid::text gname
FROM :wdpaschema.wdoecm_o5_buffers_:vDATE a
LEFT JOIN :wdpaschema.wdoecm_:vDATE b USING (wdpaid)
WHERE b.marine NOT IN (2)
ORDER BY wdpaid;

CREATE TABLE :buschema.list_bu_oecm_ma AS
SELECT 'bu_'||wdpaid::text gname
FROM :wdpaschema.wdoecm_o5_buffers_:vDATE
LEFT JOIN :wdpaschema.wdoecm_:vDATE b USING (wdpaid)
WHERE b.marine IN (2)
ORDER BY wdpaid;
