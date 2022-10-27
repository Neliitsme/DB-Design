-- Generalization
CREATE MATERIALIZED VIEW IF NOT EXISTS stoma.staff_info AS
SELECT anon.generalize_int4range(users.id, 10)                 AS id,
       users.first_name,
       users.last_name,
       users.phone_number,
       users.email,
       anon.generalize_daterange(users.birth_date, $$decade$$) AS birth_date,
       genders.gender,
       staff_roles.staff_role_name,
       medical_histories.current_health
FROM stoma.users
         JOIN stoma.staff
              ON users.id = staff.user_id
         JOIN stoma.genders
              ON genders.id = users.gender_id
         JOIN stoma.staff_roles
              ON staff_roles.id = staff.staff_role_id
         JOIN stoma.medical_histories
              ON users.id = medical_histories.user_id;

-- Faking, Noise
CREATE MATERIALIZED VIEW IF NOT EXISTS stoma.users_clinics_readable AS
SELECT anon.noise(users.id, 0.5)    AS id,
       users.first_name,
       anon.lorem_ipsum(words := 1) AS middle_name,
       users.last_name,
       anon.fake_address()          AS address
FROM stoma.users
         JOIN stoma.users_clinics ON users_clinics.user_id = users.id
         JOIN stoma.clinics ON clinics.id = users_clinics.clinic_id;

-- Hashing, Randomization
CREATE MATERIALIZED VIEW IF NOT EXISTS stoma.surgeon_doctors AS
SELECT users.id,
       users.first_name,
       users.last_name,
       anon.random_date() as working_since_date,
       anon.hash(doctors.qualification_category::text) AS qualification_category,
       specialty_name
FROM stoma.users
         JOIN stoma.staff on users.id = staff.user_id
         JOIN stoma.doctors on staff.id = doctors.staff_id
         JOIN stoma.doctor_specialties ds on ds.id = doctors.specialty_id
WHERE specialty_name = 'Surgeon'