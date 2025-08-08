const { authJwt } = require("../middleware");
const sensorController = require("../controllers/sensorController");

module.exports = function (app) {
  app.use(function (req, res, next) {
    res.header(
      "Access-Control-Allow-Headers",
      "x-access-token, Origin, Content-Type, Accept"
    );
    next();
  });

  // Mendapatkan daftar semua sensor
  app.get(
    "/api/v1/sensors",
    [authJwt.verifyToken],
    sensorController.getAllSensors
  );

  // Mendapatkan data pembacaan terbaru dari satu sensor
  // Catatan: Endpoint ini tidak ada di dokumen asli, tapi sangat berguna.
  app.get(
    "/api/v1/sensors/:sensorId/readings/latest",
    [authJwt.verifyToken],
    sensorController.getLatestReading
  );

  // Mendapatkan riwayat pembacaan sensor
  app.get(
    "/api/v1/sensors/:sensorId/history",
    [authJwt.verifyToken],
    sensorController.getSensorHistory
  );

  // Endpoint untuk perangkat IoT mengirim data (tidak memerlukan JWT dari user)
  app.post("/api/v1/sensors/readings", sensorController.createReading);
};
