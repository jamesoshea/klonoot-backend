\c klonoot
BEGIN;
CREATE TABLE hidden.csp_reports(
    id bigserial PRIMARY KEY,
    created timestamp NOT NULL DEFAULT now(),
    report jsonb NOT NULL
);
CREATE FUNCTION csp_report("csp-report" json)
    RETURNS void
    LANGUAGE SQL
    SECURITY DEFINER
    AS $$
    INSERT INTO hidden.csp_reports(report)
        VALUES("csp-report")
$$;
GRANT EXECUTE ON FUNCTION csp_report(json) TO anonymous;
COMMIT;

