DROP TABLE IF EXISTS :v_rcep_out.wdpa_pressure_agriculture_bu;CREATE TABLE :v_rcep_out.wdpa_pressure_agriculture_bu AS
SELECT
wdpaid,(theme_sqkm/tot_sqkm*100) p_agriculture_bu_perc_tot
FROM :v_rcep_out.pabu_intermediate_p_agriculture_bu
WHERE cat=40;
