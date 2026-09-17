-- dopa_wdpa_all_inds
DROP MATERIALIZED VIEW IF EXISTS dopa_50.dopa_wdpa_all_inds_template CASCADE;CREATE MATERIALIZED VIEW dopa_50.dopa_wdpa_all_inds_template AS
SELECT * FROM dopa_50.dopa_wdpa_all_inds LIMIT 0;
GRANT SELECT ON dopa_50.dopa_wdpa_all_inds_template TO h05ibexro;
DROP FUNCTION IF EXISTS dopa_50.get_dopa_wdpa_all_inds(integer);
CREATE FUNCTION dopa_50.get_dopa_wdpa_all_inds(wdpaid integer DEFAULT NULL::integer)
RETURNS SETOF dopa_50.dopa_wdpa_all_inds_template
LANGUAGE 'plpgsql' AS $BODY$
DECLARE
sql TEXT;
BEGIN
sql :='
SELECT * FROM dopa_50.dopa_wdpa_all_inds';
IF wdpaid IS NOT NULL THEN
			sql := sql || ' WHERE wdpaid = $1;';
ELSE	sql := sql || ';';
END IF;
RETURN QUERY EXECUTE sql USING wdpaid;
END;
$BODY$;
GRANT EXECUTE ON FUNCTION dopa_50.get_dopa_wdpa_all_inds(integer) TO h05ibexro;

