--sql CREATE TABLE TO STORE DATA FROM r.univar
-- to be used ONLY as slave of exec_cep_conraster_stats.sh
-- N.B. The fields eid and qid is added to csv file in post-processing, after running r.univar

DROP TABLE IF EXISTS :vSCHEMA.:vNAME;
CREATE TABLE :vSCHEMA.:vNAME (
eid integer,
cid integer,
label text,
non_null_cells integer,
null_cells bigint,
min double precision,
max double precision,
range double precision,
mean double precision,
mean_of_abs double precision,
stddev double precision,
variance double precision,
coeff_var double precision,
sum numeric(20,4),
sum_abs numeric(20,4),
first_quart double precision,
median double precision,
third_quart double precision,
perc_90 double precision
); 
