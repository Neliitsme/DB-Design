const db = connect("mongodb://localhost:27017/admin");
db.auth("root", "example");
db = db.getSiblingDB("stoma");
db.clinics.insertMany([
  {
    name: "HQ",
    address: "56 Pawnee St. New Bern, NC 28560",
  },
  {
    name: "Biggest",
    address: "71 Summit Court Dyersburg, TN 38024",
  },
  {
    name: "Smallest",
    address: "62 E. Oak Ave. Gulfport, MS 39503",
  },

  {
    name: "Medium",
    address: "9550 Golden Star St. Mc Lean, VA 22101",
  },
  {
    name: "Tempo",
    address: "9530 Creek St. Rosemount, MN 55068",
  },
  {
    name: "Temper",
    address: "400 West Country Ave. Saint Augustine, FL 32084",
  },
  {
    name: "Alpha",
    address: "54 Front Drive Cartersville, GA 30120",
  },
  {
    name: "Beta",
    address: "242 Poor House St. Key West, FL 33040",
  },
  {
    name: "Omega",
    address: "8547 Newport St. West Chicago, IL 60185",
  },
  {
    name: "Delta",
    address: "84 Big Rock Cove Lane Springfield, PA 19064",
  },
]);

const userIds = db.users.find({}, { _id: 1 });
userIds.forEach((e) => {
  db.medical_histories.insertOne({
    user_id: e._id,
    status: "healthy",
  });
});
