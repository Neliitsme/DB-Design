const db = connect("mongodb://localhost:27017/admin");
db.auth("root", "example");
db = db.getSiblingDB("stoma");
print(db.adminCommand("listDatabases"));
print(db.getCollectionNames());
print(db.users.find());
