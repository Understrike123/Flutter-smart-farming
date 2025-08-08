const actuatorService = require("../services/actuatorService");

exports.getAllActuators = async (req, res) => {
  try {
    const actuators = await actuatorService.findAllActuators();
    res.status(200).send(actuators);
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.sendCommand = async (req, res) => {
  try {
    const { actuatorId } = req.params;
    const { command, duration_minutes } = req.body;

    // Validasi input
    if (!command || !["TURN_ON", "TURN_OFF"].includes(command)) {
      return res.status(400).send({
        message: "Perintah tidak valid. Gunakan 'TURN_ON' atau 'TURN_OFF'.",
      });
    }

    const result = await actuatorService.executeCommand(
      actuatorId,
      command,
      duration_minutes
    );
    res
      .status(200)
      .send({ message: "Perintah berhasil dikirim", data: result });
  } catch (error) {
    // Spesifikasikan error jika aktuator tidak ditemukan
    if (error.message.includes("tidak ditemukan")) {
      return res.status(404).send({ message: error.message });
    }
    res.status(500).send({ message: error.message });
  }
};

exports.getSchedules = async (req, res) => {
  try {
    const { actuatorId } = req.params;
    const schedules = await actuatorService.findSchedulesForActuator(
      actuatorId
    );
    res.status(200).send(schedules);
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.createSchedule = async (req, res) => {
  try {
    const { actuatorId } = req.params;
    const scheduleData = req.body;
    const newSchedule = await actuatorService.createScheduleForActuator(
      actuatorId,
      scheduleData
    );
    res
      .status(201)
      .send({ message: "Jadwal berhasil dibuat", schedule_id: newSchedule.id });
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.updateSchedule = async (req, res) => {
  try {
    const { scheduleId } = req.params;
    const updatedData = req.body;
    const updatedSchedule = await actuatorService.updateScheduleById(
      scheduleId,
      updatedData
    );
    res
      .status(200)
      .send({ message: "Jadwal berhasil diperbarui", data: updatedSchedule });
  } catch (error) {
    if (error.message.includes("tidak ditemukan")) {
      return res.status(404).send({ message: error.message });
    }
    res.status(500).send({ message: error.message });
  }
};

exports.deleteSchedule = async (req, res) => {
  try {
    const { scheduleId } = req.params;
    await actuatorService.deleteScheduleById(scheduleId);
    // Standar RESTful untuk DELETE yang sukses adalah 204 No Content
    res.status(204).send();
  } catch (error) {
    if (error.message.includes("tidak ditemukan")) {
      return res.status(404).send({ message: error.message });
    }
    res.status(500).send({ message: error.message });
  }
};
