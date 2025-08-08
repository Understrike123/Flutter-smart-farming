const sensorService = require("../services/sensorService");

exports.getAllSensors = async (req, res) => {
  try {
    const sensors = await sensorService.findAllSensors();
    res.status(200).send(sensors);
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.getLatestReading = async (req, res) => {
  try {
    const { sensorId } = req.params;
    const reading = await sensorService.findLatestReading(sensorId);
    if (reading) {
      res.status(200).send(reading);
    } else {
      res.status(404).send({ message: "Data pembacaan tidak ditemukan." });
    }
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.getSensorHistory = async (req, res) => {
  try {
    const { sensorId } = req.params;
    const { duration } = req.query; // contoh: '24h', '7d', '30d'
    const history = await sensorService.findSensorHistory(sensorId, duration);
    res.status(200).send(history);
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.createReading = async (req, res) => {
  try {
    // Endpoint ini untuk perangkat IoT.
    // Asumsi body request: { device_id: "...", value: ... }
    const { device_id, value } = req.body;
    if (!device_id || value === undefined) {
      return res
        .status(400)
        .send({ message: "device_id dan value diperlukan." });
    }
    const reading = await sensorService.createSensorReading(device_id, value);
    res
      .status(201)
      .send({ message: "Data pembacaan berhasil diterima", data: reading });
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};
