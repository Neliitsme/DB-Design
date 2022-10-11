CREATE UNIQUE INDEX IF NOT EXISTS users_id_name_role
    ON stoma.users (id) INCLUDE (first_name, last_name, role_id);
CREATE UNIQUE INDEX IF NOT EXISTS staff_user_id_role
    ON stoma.staff (user_id) INCLUDE (staff_role_id);
CREATE UNIQUE INDEX IF NOT EXISTS doctors_staff_id_specialty
    ON stoma.doctors (staff_id) INCLUDE (specialty_id);
CREATE UNIQUE INDEX IF NOT EXISTS medical_histories_user_id_health
    ON stoma.medical_histories (user_id) INCLUDE (current_health);