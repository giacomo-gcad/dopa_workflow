--sql CREATE TABLE TO STORE DATA FROM HDI 

DROP TABLE IF EXISTS :vSCHEMA.:vNAME;
CREATE TABLE :vSCHEMA.:vNAME (
cat integer,
label text,
wdpaid_pa text,
aleat integer,
segm_id text
);
