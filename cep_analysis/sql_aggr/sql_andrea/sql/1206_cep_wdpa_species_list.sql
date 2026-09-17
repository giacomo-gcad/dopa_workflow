DROP TABLE IF EXISTS wdpa_species_list_temp_corals;
CREATE TEMPORARY TABLE wdpa_species_list_temp_corals AS
SELECT DISTINCT wdpaid,UNNEST(corals) id_no FROM :v_rcep_out.wdpa_species_corals;

DROP TABLE IF EXISTS wdpa_species_list_temp_sharks;
CREATE TEMPORARY TABLE wdpa_species_list_temp_sharks AS
SELECT DISTINCT wdpaid,UNNEST(sharks) id_no FROM :v_rcep_out.wdpa_species_sharks;

DROP TABLE IF EXISTS wdpa_species_list_temp_amphibians;
CREATE TEMPORARY TABLE wdpa_species_list_temp_amphibians AS
SELECT DISTINCT wdpaid,UNNEST(amphibians) id_no FROM :v_rcep_out.wdpa_species_amphibians;

DROP TABLE IF EXISTS wdpa_species_list_temp_reptiles;
CREATE TEMPORARY TABLE wdpa_species_list_temp_reptiles AS
SELECT DISTINCT wdpaid,UNNEST(reptiles) id_no FROM :v_rcep_out.wdpa_species_reptiles;

DROP TABLE IF EXISTS wdpa_species_list_temp_mammals;
CREATE TEMPORARY TABLE wdpa_species_list_temp_mammals AS
SELECT DISTINCT wdpaid,UNNEST(mammals) id_no FROM :v_rcep_out.wdpa_species_mammals;

DROP TABLE IF EXISTS wdpa_species_list_temp_birds;
CREATE TEMPORARY TABLE wdpa_species_list_temp_birds AS
SELECT DISTINCT wdpaid,UNNEST(birds) id_no FROM :v_rcep_out.wdpa_species_birds;

DROP TABLE IF EXISTS :v_rcep_out.wdpa_species;
CREATE TABLE :v_rcep_out.wdpa_species AS
SELECT * FROM wdpa_species_list_temp_corals
UNION
SELECT * FROM wdpa_species_list_temp_sharks
UNION
SELECT * FROM wdpa_species_list_temp_amphibians
UNION
SELECT * FROM wdpa_species_list_temp_reptiles
UNION
SELECT * FROM wdpa_species_list_temp_birds
UNION
SELECT * FROM wdpa_species_list_temp_mammals
ORDER BY wdpaid,id_no;