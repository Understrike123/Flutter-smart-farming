const dbConfig = require("../config/db.config.js");
const Sequelize = require("sequelize");
const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,
  operatorsAliases: false,
  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle,
  },
});

const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;

// Memuat semua model
db.user = require("./user.js")(sequelize, Sequelize);
db.sensor = require("./sensor.js")(sequelize, Sequelize);
db.sensorReading = require("./sensorReading.js")(sequelize, Sequelize);
db.actuator = require("./actuator.js")(sequelize, Sequelize); // DITAMBAHKAN
db.actuatorCommand = require("./actuatorCommand.js")(sequelize, Sequelize); // DITAMBAHKAN
db.schedule = require("./schedule.js")(sequelize, Sequelize); // DITAMBAHKAN

// --- DITAMBAHKAN: Mendefinisikan Relasi ---
// Satu Sensor memiliki banyak Pembacaan (SensorReadings)
db.sensor.hasMany(db.sensorReading, { as: "readings" });
db.sensorReading.belongsTo(db.sensor, {
  foreignKey: "sensorId",
  as: "sensor",
});

db.actuator.hasMany(db.actuatorCommand, { as: "commands" });
db.actuatorCommand.belongsTo(db.actuator, {
  foreignKey: "actuatorId",
  as: "actuator",
});
// Actuator -> Schedules
db.actuator.hasMany(db.schedule, { as: "schedules" });
db.schedule.belongsTo(db.actuator, {
  foreignKey: "actuatorId",
  as: "actuator",
});

module.exports = db;
