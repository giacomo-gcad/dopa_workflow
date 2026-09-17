DROP TABLE IF EXISTS :SCHEMA_CLIM.copernicus_sst_wdpa_:DATE;
CREATE TABLE :SCHEMA_CLIM.copernicus_sst_wdpa_:DATE AS

WITH pas AS 
(
SELECT 
LTRIM(gname,'pa_')::integer wdpaid
FROM :PA_SCHEMA.list_pa_ma
)

SELECT 
main.wdpaid,
d01.max/100 cli_tmax_01,
d02.max/100 cli_tmax_02,
d03.max/100 cli_tmax_03,
d04.max/100 cli_tmax_04,
d05.max/100 cli_tmax_05,
d06.max/100 cli_tmax_06,
d07.max/100 cli_tmax_07,
d08.max/100 cli_tmax_08,
d09.max/100 cli_tmax_09,
d10.max/100 cli_tmax_10,
d11.max/100 cli_tmax_11,
d12.max/100 cli_tmax_12,
b01.mean/100 cli_tmean_01,
b02.mean/100 cli_tmean_02,
b03.mean/100 cli_tmean_03,
b04.mean/100 cli_tmean_04,
b05.mean/100 cli_tmean_05,
b06.mean/100 cli_tmean_06,
b07.mean/100 cli_tmean_07,
b08.mean/100 cli_tmean_08,
b09.mean/100 cli_tmean_09,
b10.mean/100 cli_tmean_10,
b11.mean/100 cli_tmean_11,
b12.mean/100 cli_tmean_12,
c01.min/100 cli_tmin_01,
c02.min/100 cli_tmin_02,
c03.min/100 cli_tmin_03,
c04.min/100 cli_tmin_04,
c05.min/100 cli_tmin_05,
c06.min/100 cli_tmin_06,
c07.min/100 cli_tmin_07,
c08.min/100 cli_tmin_08,
c09.min/100 cli_tmin_09,
c10.min/100 cli_tmin_10,
c11.min/100 cli_tmin_11,
c12.min/100 cli_tmin_12,
NULL::numeric cli_prec_01,
NULL::numeric cli_prec_02,
NULL::numeric cli_prec_03,
NULL::numeric cli_prec_04,
NULL::numeric cli_prec_05,
NULL::numeric cli_prec_06,
NULL::numeric cli_prec_07,
NULL::numeric cli_prec_08,
NULL::numeric cli_prec_09,
NULL::numeric cli_prec_10,
NULL::numeric cli_prec_11,
NULL::numeric cli_prec_12
FROM pas main
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_01 b01 ON main.wdpaid=b01.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_02 b02 ON main.wdpaid=b02.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_03 b03 ON main.wdpaid=b03.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_04 b04 ON main.wdpaid=b04.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_05 b05 ON main.wdpaid=b05.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_06 b06 ON main.wdpaid=b06.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_07 b07 ON main.wdpaid=b07.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_08 b08 ON main.wdpaid=b08.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_09 b09 ON main.wdpaid=b09.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_10 b10 ON main.wdpaid=b10.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_11 b11 ON main.wdpaid=b11.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_avg_12 b12 ON main.wdpaid=b12.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_01 c01 ON main.wdpaid=c01.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_02 c02 ON main.wdpaid=c02.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_03 c03 ON main.wdpaid=c03.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_04 c04 ON main.wdpaid=c04.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_05 c05 ON main.wdpaid=c05.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_06 c06 ON main.wdpaid=c06.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_07 c07 ON main.wdpaid=c07.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_08 c08 ON main.wdpaid=c08.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_09 c09 ON main.wdpaid=c09.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_10 c10 ON main.wdpaid=c10.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_11 c11 ON main.wdpaid=c11.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_min_12 c12 ON main.wdpaid=c12.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_01 d01 ON main.wdpaid=d01.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_02 d02 ON main.wdpaid=d02.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_03 d03 ON main.wdpaid=d03.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_04 d04 ON main.wdpaid=d04.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_05 d05 ON main.wdpaid=d05.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_06 d06 ON main.wdpaid=d06.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_07 d07 ON main.wdpaid=d07.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_08 d08 ON main.wdpaid=d08.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_09 d09 ON main.wdpaid=d09.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_10 d10 ON main.wdpaid=d10.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_11 d11 ON main.wdpaid=d11.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_sst_max_12 d12 ON main.wdpaid=d12.wdpaid
ORDER BY wdpaid;

ALTER TABLE :SCHEMA_CLIM.copernicus_sst_wdpa
ADD PRIMARY KEY (wdpaid);
