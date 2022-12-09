const db = connect("mongodb://localhost:27017/admin");
db.auth("root", "example");
db = db.getSiblingDB("stoma");
db.users.updateMany({}, [
  {
    $set: {
      gender: {
        $switch: {
          branches: [
            { case: { $eq: ["$gender", 1] }, then: "Male" },
            { case: { $eq: ["$gender", 2] }, then: "Female" },
          ],
          default: "Unknown",
        },
      },
    },
  },
  {
    $set: {
      role: {
        $cond: {
          if: { $eq: ["$role", 2] },
          then: "Staff",
          else: "Client",
        },
      },
    },
  },
]);
