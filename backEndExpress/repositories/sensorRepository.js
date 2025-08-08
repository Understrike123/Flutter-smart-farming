const db = require("../models");
const Sensor = db.sensor;
const SensorReading = db.sensorReading;
const { Op } = db.Sequelize;

exports.getAllSensors = async () => {
  return await Sensor.findAll();
};

exports.getSensorByDeviceId = async (deviceId) => {
  return await Sensor.findOne({ where: { device_id: deviceId } });
};

exports.getLatestReadingBySensorId = async (sensorId) => {
  return await SensorReading.findOne({
    where: { sensorId: sensorId },
    order: [["timestamp", "DESC"]],
  });
};

exports.getReadingsHistory = async (sensorId, startTime) => {
  return await SensorReading.findAll({
    where: {
      sensorId: sensorId,
      timestamp: {
        [Op.gte]: startTime,
      },
    },
    order: [["timestamp", "ASC"]],
  });
};

exports.createReading = async (sensorId, value) => {
  return await SensorReading.create({
    sensorId: sensorId,
    value: value,
    timestamp: new Date(),
  });
};
