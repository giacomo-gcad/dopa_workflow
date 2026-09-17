-- dopa_wdpa_all_inds
DROP MATERIALIZED VIEW IF EXISTS :v_rest.dopa_wdpa_all_inds_template CASCADE;CREATE MATERIALIZED VIEW :v_rest.dopa_wdpa_all_inds_template AS
SELECT * FROM :v_rest.dopa_wdpa_all_inds LIMIT 0;
GRANT SELECT ON :v_rest.dopa_wdpa_all_inds_template TO h05ibexro;
DROP FUNCTION IF EXISTS :v_rest.get_dopa_wdpa_all_inds(integer);
CREATE FUNCTION :v_rest.get_dopa_wdpa_all_inds(wdpaid integer DEFAULT NULL::integer)
RETURNS SETOF :v_rest.dopa_wdpa_all_inds_template
LANGUAGE 'plpgsql' AS $BODY$
DECLARE
sql TEXT;
BEGIN
sql :='
SELECT * FROM :v_rest.dopa_wdpa_all_inds';
IF wdpaid IS NOT NULL THEN
			sql := sql || ' WHERE wdpaid = $1;';
ELSE	sql := sql || ';';
END IF;
RETURN QUERY EXECUTE sql USING wdpaid;
END;
$BODY$;
GRANT EXECUTE ON FUNCTION :v_rest.get_dopa_wdpa_all_inds(integer) TO h05ibexro;

