CREATE TABLE IF NOT EXISTS stoma.users_mod_0
(
    LIKE stoma.users INCLUDING DEFAULTS INCLUDING CONSTRAINTS,
    CHECK ( id % 3 = 0)
) INHERITS (stoma.users);
CREATE TABLE IF NOT EXISTS stoma.users_mod_1
(
    LIKE stoma.users INCLUDING DEFAULTS INCLUDING CONSTRAINTS,
    CHECK (id % 3 = 1 )
) INHERITS (stoma.users);
CREATE TABLE IF NOT EXISTS stoma.users_mod_2
(
    LIKE stoma.users INCLUDING DEFAULTS INCLUDING CONSTRAINTS,
    CHECK ( id % 3 = 2 )
) INHERITS (stoma.users);

CREATE UNIQUE INDEX IF NOT EXISTS users_mod_0_id ON stoma.users_mod_0 (id);
CREATE UNIQUE INDEX IF NOT EXISTS users_mod_0_email ON stoma.users_mod_0 (email);
CREATE UNIQUE INDEX IF NOT EXISTS users_mod_1_id ON stoma.users_mod_1 (id);
CREATE UNIQUE INDEX IF NOT EXISTS users_mod_1_email ON stoma.users_mod_1 (email);
CREATE UNIQUE INDEX IF NOT EXISTS users_mod_2_id ON stoma.users_mod_2 (id);
CREATE UNIQUE INDEX IF NOT EXISTS users_mod_2_email ON stoma.users_mod_2 (email);

CREATE OR REPLACE FUNCTION users_insert_trigger()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (NEW.id % 3 = 0) THEN
        INSERT INTO stoma.users_mod_0
        VALUES (NEW.*);
    ELSIF (NEW.id % 3 = 1) THEN
        INSERT INTO stoma.users_mod_1
        VALUES (NEW.*);
    ELSE
        INSERT INTO stoma.users_mod_2
        VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER insert_users_trigger
    BEFORE INSERT
    ON stoma.users
    FOR EACH ROW
EXECUTE FUNCTION users_insert_trigger();
