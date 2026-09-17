--country_iucn_species
DROP TABLE IF EXISTS :v_r_non_cep.country_iucn_species;
CREATE TABLE :v_r_non_cep.country_iucn_species AS
SELECT *
FROM ind_redlist.country_iucn_species
ORDER BY country_id;