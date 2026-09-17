DROP TABLE IF EXISTS :v_rcep_out.wdpa_pressure_agriculture_pa;CREATE TABLE :v_rcep_out.wdpa_pressure_agriculture_pa AS
SELECT
wdpaid,(theme_sqkm/tot_sqkm*100) p_agriculture_pa_perc_tot
FROM :v_rcep_out.wdpa_intermediate_lc_copernicus
WHERE cat=40;
