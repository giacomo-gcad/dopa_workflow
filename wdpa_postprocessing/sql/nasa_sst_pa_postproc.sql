DROP TABLE IF EXISTS :SCHEMA_CLIM.nasa_sst_wdpa_:DATE;
CREATE TABLE :SCHEMA_CLIM.nasa_sst_wdpa_:DATE AS


WITH pas AS (
SELECT 
LTRIM(gname,'pa_')::integer wdpaid
FROM :PA_SCHEMA.:PA_TABLE
)


-- Ttemperature values are divided by 200 in order to take into account
-- the scale factor (0.0049999999) used in NETCDF data distributed by NASA

SELECT 
main.wdpaid,
ROUND(d01.mean::numeric/200,2) cli_tmax_01,
ROUND(d02.mean::numeric/200,2) cli_tmax_02,
ROUND(d03.mean::numeric/200,2) cli_tmax_03,
ROUND(d04.mean::numeric/200,2) cli_tmax_04,
ROUND(d05.mean::numeric/200,2) cli_tmax_05,
ROUND(d06.mean::numeric/200,2) cli_tmax_06,
ROUND(d07.mean::numeric/200,2) cli_tmax_07,
ROUND(d08.mean::numeric/200,2) cli_tmax_08,
ROUND(d09.mean::numeric/200,2) cli_tmax_09,
ROUND(d10.mean::numeric/200,2) cli_tmax_10,
ROUND(d11.mean::numeric/200,2) cli_tmax_11,
ROUND(d12.mean::numeric/200,2) cli_tmax_12,
ROUND(b01.mean::numeric/200,2) cli_tmean_01,
ROUND(b02.mean::numeric/200,2) cli_tmean_02,
ROUND(b03.mean::numeric/200,2) cli_tmean_03,
ROUND(b04.mean::numeric/200,2) cli_tmean_04,
ROUND(b05.mean::numeric/200,2) cli_tmean_05,
ROUND(b06.mean::numeric/200,2) cli_tmean_06,
ROUND(b07.mean::numeric/200,2) cli_tmean_07,
ROUND(b08.mean::numeric/200,2) cli_tmean_08,
ROUND(b09.mean::numeric/200,2) cli_tmean_09,
ROUND(b10.mean::numeric/200,2) cli_tmean_10,
ROUND(b11.mean::numeric/200,2) cli_tmean_11,
ROUND(b12.mean::numeric/200,2) cli_tmean_12,
ROUND(c01.mean::numeric/200,2) cli_tmin_01,
ROUND(c02.mean::numeric/200,2) cli_tmin_02,
ROUND(c03.mean::numeric/200,2) cli_tmin_03,
ROUND(c04.mean::numeric/200,2) cli_tmin_04,
ROUND(c05.mean::numeric/200,2) cli_tmin_05,
ROUND(c06.mean::numeric/200,2) cli_tmin_06,
ROUND(c07.mean::numeric/200,2) cli_tmin_07,
ROUND(c08.mean::numeric/200,2) cli_tmin_08,
ROUND(c09.mean::numeric/200,2) cli_tmin_09,
ROUND(c10.mean::numeric/200,2) cli_tmin_10,
ROUND(c11.mean::numeric/200,2) cli_tmin_11,
ROUND(c12.mean::numeric/200,2) cli_tmin_12,
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
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_01 b01 ON main.wdpaid=b01.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_02 b02 ON main.wdpaid=b02.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_03 b03 ON main.wdpaid=b03.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_04 b04 ON main.wdpaid=b04.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_05 b05 ON main.wdpaid=b05.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_06 b06 ON main.wdpaid=b06.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_07 b07 ON main.wdpaid=b07.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_08 b08 ON main.wdpaid=b08.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_09 b09 ON main.wdpaid=b09.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_10 b10 ON main.wdpaid=b10.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_11 b11 ON main.wdpaid=b11.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_avg_12 b12 ON main.wdpaid=b12.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_01 c01 ON main.wdpaid=c01.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_02 c02 ON main.wdpaid=c02.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_03 c03 ON main.wdpaid=c03.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_04 c04 ON main.wdpaid=c04.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_05 c05 ON main.wdpaid=c05.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_06 c06 ON main.wdpaid=c06.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_07 c07 ON main.wdpaid=c07.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_08 c08 ON main.wdpaid=c08.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_09 c09 ON main.wdpaid=c09.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_10 c10 ON main.wdpaid=c10.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_11 c11 ON main.wdpaid=c11.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_min_12 c12 ON main.wdpaid=c12.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_01 d01 ON main.wdpaid=d01.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_02 d02 ON main.wdpaid=d02.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_03 d03 ON main.wdpaid=d03.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_04 d04 ON main.wdpaid=d04.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_05 d05 ON main.wdpaid=d05.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_06 d06 ON main.wdpaid=d06.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_07 d07 ON main.wdpaid=d07.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_08 d08 ON main.wdpaid=d08.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_09 d09 ON main.wdpaid=d09.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_10 d10 ON main.wdpaid=d10.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_11 d11 ON main.wdpaid=d11.wdpaid
LEFT JOIN :SCHEMA_CLIM.pa_nasa_sst_max_12 d12 ON main.wdpaid=d12.wdpaid
ORDER BY wdpaid;

ALTER TABLE :SCHEMA_CLIM.nasa_sst_wdpa_:DATE
ADD PRIMARY KEY (wdpaid);
