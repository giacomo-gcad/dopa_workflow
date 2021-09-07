-- CREATE A NEW TABLE WITH UNION OF WDPA AND WDOECM

DROP TABLE IF EXISTS protected_sites.wdpa_oecm_:VDATE;
CREATE TABLE protected_sites.wdpa_oecm_:VDATE AS
(SELECT * FROM protected_sites.wdpa_:VDATE
UNION
SELECT * FROM protected_sites.wdoecm_:VDATE
ORDER BY wdpaid);

ALTER TABLE protected_sites.wdpa_oecm_:VDATE ADD PRIMARY KEY (wdpaid);
CREATE INDEX wdpa_oecm_:VDATE_idx ON protected_sites.wdpa_oecm_:VDATE USING gist (geom);