const db = connect("mongodb://localhost:27017/admin");
db.auth("root", "example");
db = db.getSiblingDB("stoma");
db.createView("user_info", "users", [
  {
    $lookup: {
      from: "clinics",
      localField: "main_clinic",
      foreignField: "name",
      as: "clinic_addresses",
    },
  },
  { $unwind: "$clinic_addresses" },
  {
    $lookup: {
      from: "medical_histories",
      localField: "_id",
      foreignField: "user_id",
      as: "histories_to_users",
    },
  },
  { $unwind: "$histories_to_users" },
  {
    $project: {
      _id: 1,
      first_name: 1,
      last_name: 1,
      middle_name: 1,
      phone_number: 1,
      email: 1,
      birth_date: 1,
      gender: 1,
      role: 1,
      health_status: "$histories_to_users.status",
      main_clinic: 1,
      clinic_address: "$clinic_addresses.address",
    },
  },
]);
