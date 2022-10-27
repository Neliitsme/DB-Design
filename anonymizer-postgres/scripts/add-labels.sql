-- Destruction
SECURITY LABEL FOR anon ON COLUMN stoma.users.middle_name
    IS 'MASKED WITH VALUE NULL';

-- Faking
SECURITY LABEL FOR anon ON COLUMN stoma.users.last_name
    IS 'MASKED WITH FUNCTION anon.fake_last_name()';

SECURITY LABEL FOR anon ON COLUMN stoma.users.first_name
    IS 'MASKED WITH FUNCTION anon.fake_first_name()';

-- Partial scrambling
SECURITY LABEL FOR anon ON COLUMN stoma.users.phone_number
    IS 'MASKED WITH FUNCTION anon.partial(phone_number,2,$$******$$,2)';

-- Pseudonymization
SECURITY LABEL FOR anon ON COLUMN stoma.users.email
    IS 'MASKED WITH FUNCTION anon.pseudo_email(2, email)';