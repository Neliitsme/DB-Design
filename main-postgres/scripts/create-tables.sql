CREATE TABLE IF NOT EXISTS stoma.users
(
    id           INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR(30)   NOT NULL,
    last_name    VARCHAR(30)   NOT NULL,
    middle_name  VARCHAR(30),
    phone_number CHAR(12)      NOT NULL,
    email        VARCHAR(255) UNIQUE,
    birth_date   DATE          NOT NULL,
    gender_id    INT DEFAULT 1 NOT NULL,
    role_id      INT DEFAULT 1 NOT NULL
);

-- Users-to-Clinics Many-to-Many
CREATE TABLE IF NOT EXISTS stoma.users_clinics
(
    id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id   INT NOT NULL,
    clinic_id INT NOT NULL,

    UNIQUE (user_id, clinic_id)
);

CREATE TABLE IF NOT EXISTS stoma.genders
(
    id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- unknown (1), female, male, etc.
    gender VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO stoma.genders(gender)
VALUES ('Unknown'),
       ('Female'),
       ('Male');

CREATE TABLE IF NOT EXISTS stoma.user_roles
(
    id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Client, Staff
    role_name VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO stoma.user_roles(role_name)
VALUES ('Client'),
       ('Staff');

CREATE TABLE IF NOT EXISTS stoma.clients
(
    id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS stoma.medical_histories
(
    id             INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        INT UNIQUE   NOT NULL,
    current_health VARCHAR(255) NOT NULL DEFAULT ('Healthy'),
    allergies      TEXT,
    prescription   TEXT
);

CREATE TABLE IF NOT EXISTS stoma.clinics
(
    id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS stoma.staff
(
    id                 INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id            INT UNIQUE                NOT NULL,
    working_since_date DATE DEFAULT CURRENT_DATE NOT NULL,
    working_since_time TIME DEFAULT CURRENT_TIME NOT NULL,
    staff_role_id      INT                       NOT NULL
);

CREATE TABLE IF NOT EXISTS stoma.staff_roles
(
    id              INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Doctor, Receptionist, Administrator
    staff_role_name VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO stoma.staff_roles(staff_role_name)
VALUES ('Doctor'),
       ('Receptionist'),
       ('Administrator');

CREATE TYPE stoma.doctor_categories AS ENUM ('Uncategorized', 'First', 'Second', 'Highest');

CREATE TABLE IF NOT EXISTS stoma.doctors
(
    id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id               INT UNIQUE                                      NOT NULL,
    specialty_id           INT                                             NOT NULL,
    qualification_category stoma.doctor_categories DEFAULT 'Uncategorized' NOT NULL
);

CREATE TABLE IF NOT EXISTS stoma.doctor_specialties
(
    id             INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Therapist, Surgeon, Periodontist, Orthopedic-surgeon, Orthodontist
    specialty_name VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO stoma.doctor_specialties(specialty_name)
VALUES ('Therapist'),
       ('Surgeon'),
       ('Periodontist'),
       ('Orthopedic-surgeon'),
       ('Orthodontist');

CREATE TABLE IF NOT EXISTS stoma.appointments
(
    id                  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id           INT  NOT NULL,
    doctor_id           INT  NOT NULL,
    appointment_type_id INT  NOT NULL,
    appointed_date      DATE NOT NULL,
    appointed_time      TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS stoma.appointment_types
(
    id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Diagnostics, Consultation, Surgery, etc.
    type_name VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO stoma.appointment_types(type_name)
VALUES ('Diagnostics'),
       ('Consultation'),
       ('Surgery'),
       ('Cleaning');

ALTER TABLE stoma.users
    ADD FOREIGN KEY (gender_id)
        REFERENCES stoma.genders (id),
    ADD FOREIGN KEY (role_id)
        REFERENCES stoma.user_roles (id);

ALTER TABLE stoma.medical_histories
    ADD FOREIGN KEY (user_id)
        REFERENCES stoma.users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE stoma.users_clinics
    ADD FOREIGN KEY (user_id)
        REFERENCES stoma.users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD FOREIGN KEY (clinic_id)
        REFERENCES stoma.clinics (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE stoma.clients
    ADD FOREIGN KEY (user_id)
        REFERENCES stoma.users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE stoma.staff
    ADD FOREIGN KEY (user_id)
        REFERENCES stoma.users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD FOREIGN KEY (staff_role_id)
        REFERENCES stoma.staff_roles (id);

ALTER TABLE stoma.doctors
    ADD FOREIGN KEY (staff_id)
        REFERENCES stoma.staff (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD FOREIGN KEY (specialty_id)
        REFERENCES stoma.doctor_specialties (id);

ALTER TABLE stoma.appointments
    ADD FOREIGN KEY (client_id)
        REFERENCES stoma.clients (id)
        ON UPDATE CASCADE,
    ADD FOREIGN KEY (doctor_id)
        REFERENCES stoma.doctors (id)
        ON UPDATE CASCADE,
    ADD FOREIGN KEY (appointment_type_id)
        REFERENCES stoma.appointment_types (id);

-- \copy stoma.users(first_name, last_name, phone_number, birth_date, gender_id, role_id) from 'users-data.csv' delimiter ',' CSV HEADER