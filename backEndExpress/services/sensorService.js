const sensorRepository = require("../repositories/sensorRepository");

exports.findAllSensors = async () => {
  return await sensorRepository.getAllSensors();
};

exports.findLatestReading = async (sensorId) => {
  return await sensorRepository.getLatestReadingBySensorId(sensorId);
};

exports.findSensorHistory = async (sensorId, duration) => {
  // Logika untuk mengubah durasi (string) menjadi waktu mulai (Date)
  const now = new Date();
  let startTime;

  if (duration && duration.endsWith("h")) {
    const hours = parseInt(duration.slice(0, -1));
    startTime = new Date(now.getTime() - hours * 60 * 60 * 1000);
  } else if (duration && duration.endsWith("d")) {
    const days = parseInt(duration.slice(0, -1));
    startTime = new Date(now.getTime() - days * 24 * 60 * 60 * 1000);
  } else {
    // Default: 24 jam terakhir jika durasi tidak valid atau tidak ada
    startTime = new Date(now.getTime() - 24 * 60 * 60 * 1000);
  }

  return await sensorRepository.getReadingsHistory(sensorId, startTime);
};

exports.createSensorReading = async (deviceId, value) => {
  // Cari sensor berdasarkan device_id
  const sensor = await sensorRepository.getSensorByDeviceId(deviceId);
  if (!sensor) {
    throw new Error(`Sensor dengan device_id ${deviceId} tidak ditemukan.`);
  }

  // Buat data pembacaan baru
  return await sensorRepository.createReading(sensor.id, value);
};
