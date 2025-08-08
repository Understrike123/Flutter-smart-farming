const db = require("../models");
const Actuator = db.actuator;
const ActuatorCommand = db.actuatorCommand;
const Schedule = db.schedule;

// --- Actuator ---
exports.getAllActuators = async () => {
  return await Actuator.findAll();
};

exports.getActuatorById = async (id) => {
  return await Actuator.findByPk(id);
};

exports.updateActuatorStatus = async (id, newStatus) => {
  return await Actuator.update(
    { status: newStatus, last_command_at: new Date() },
    { where: { id: id } }
  );
};

// --- Actuator Command ---
exports.logCommand = async (commandData) => {
  return await ActuatorCommand.create(commandData);
};

// --- Schedule ---
exports.getSchedulesByActuatorId = async (actuatorId) => {
  return await Schedule.findAll({ where: { actuatorId: actuatorId } });
};

exports.getScheduleById = async (id) => {
  return await Schedule.findByPk(id);
};

exports.createSchedule = async (scheduleData) => {
  return await Schedule.create(scheduleData);
};

exports.updateSchedule = async (id, updatedData) => {
  await Schedule.update(updatedData, { where: { id: id } });
  return this.getScheduleById(id); // Kembalikan data yang sudah diupdate
};

exports.deleteSchedule = async (id) => {
  return await Schedule.destroy({ where: { id: id } });
};
