-- CREATE SCHEMAS for PA and BU
-- pa
CREATE SCHEMA IF NOT EXISTS :paschema;
GRANT ALL ON SCHEMA :paschema TO h05ibex;
GRANT USAGE ON SCHEMA :paschema TO h05ibexro;

-- CREATE TABLES WITH LIST OF PAs and BUs (All, only terrestrial and coastal, only marine)
CREATE TABLE :paschema.list_pa AS
SELECT 'pa_'||wdpaid::text gname
FROM :wdpaschema.wdpa_wdoecm_o5_:vDATE
ORDER BY wdpaid;

CREATE TABLE :paschema.list_pa_tc AS
SELECT 'pa_'||a.wdpaid::text gname
FROM :wdpaschema.wdpa_wdoecm_o5_:vDATE a
LEFT JOIN :wdpaschema.wdpa_wdoecm_:vDATE b ON a.wdpaid=b.wdpaid
WHERE b.marine NOT IN (2)
ORDER BY a.wdpaid;

CREATE TABLE :paschema.list_pa_ma AS
SELECT 'pa_'||a.wdpaid::text gname
FROM :wdpaschema.wdpa_wdoecm_o5_:vDATE a
LEFT JOIN :wdpaschema.wdpa_wdoecm_:vDATE b ON a.wdpaid=b.wdpaid
WHERE b.marine IN (2)
ORDER BY a.wdpaid;
