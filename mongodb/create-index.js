const db = connect("mongodb://localhost:27017/admin");
db.auth("root", "example");
db = db.getSiblingDB("stoma");
db.medical_histories.createIndex(
  {
    _id: 1,
    user_id: 1,
  },
  { unique: true }
);
