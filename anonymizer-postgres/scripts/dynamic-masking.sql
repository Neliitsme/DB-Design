ALTER DATABASE postgres SET anon.sourceschema TO 'stoma';

CREATE ROLE tempo WITH LOGIN PASSWORD 'tempopw';

SECURITY LABEL FOR anon ON ROLE tempo IS 'MASKED';

SELECT anon.start_dynamic_masking();