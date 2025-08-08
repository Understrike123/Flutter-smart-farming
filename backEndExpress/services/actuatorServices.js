const actuatorRepository = require("../repositories/actuatorRepository");

exports.findAllActuators = async () => {
  return await actuatorRepository.getAllActuators();
};

exports.executeCommand = async (actuatorId, command, duration) => {
  // 1. Dapatkan aktuator untuk memastikan ada
  const actuator = await actuatorRepository.getActuatorById(actuatorId);
  if (!actuator) {
    throw new Error(`Aktuator dengan ID ${actuatorId} tidak ditemukan.`);
  }

  // 2. Logika untuk mengirim perintah ke perangkat fisik (misalnya via MQTT)
  //    akan ditempatkan di sini. Untuk saat ini, kita simulasikan sukses.
  console.log(
    `MENGIRIM PERINTAH: ${command} ke aktuator ${actuator.name} (ID: ${actuatorId})`
  );
  const commandStatus = "SUCCESS";

  // 3. Update status aktuator di database
  const newStatus = command === "TURN_ON";
  await actuatorRepository.updateActuatorStatus(actuatorId, newStatus);

  // 4. Catat perintah ini di tabel actuator_commands
  const commandLog = await actuatorRepository.logCommand({
    actuatorId: actuatorId,
    command: command,
    duration_minutes: duration,
    executed_at: new Date(),
    status: commandStatus,
  });

  return commandLog;
};

exports.findSchedulesForActuator = async (actuatorId) => {
  return await actuatorRepository.getSchedulesByActuatorId(actuatorId);
};

exports.createScheduleForActuator = async (actuatorId, scheduleData) => {
  // Tambahkan actuatorId ke data jadwal sebelum membuat
  scheduleData.actuatorId = actuatorId;
  return await actuatorRepository.createSchedule(scheduleData);
};

exports.updateScheduleById = async (scheduleId, updatedData) => {
  const schedule = await actuatorRepository.getScheduleById(scheduleId);
  if (!schedule) {
    throw new Error(`Jadwal dengan ID ${scheduleId} tidak ditemukan.`);
  }
  return await actuatorRepository.updateSchedule(scheduleId, updatedData);
};

exports.deleteScheduleById = async (scheduleId) => {
  const schedule = await actuatorRepository.getScheduleById(scheduleId);
  if (!schedule) {
    throw new Error(`Jadwal dengan ID ${scheduleId} tidak ditemukan.`);
  }
  return await actuatorRepository.deleteSchedule(scheduleId);
};
