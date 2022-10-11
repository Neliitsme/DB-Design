CREATE VIEW stoma.staff_info AS
SELECT users.id,
       users.first_name,
       users.last_name,
       users.middle_name,
       users.phone_number,
       users.email,
       users.birth_date,
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