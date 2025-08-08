const actuatorController = require("../controllers/actuatorController");
// Middleware authJwt sudah di-require di file route lain, jadi bisa langsung dipakai
module.exports = function (app) {
  app.use(function (req, res, next) {
    res.header(
      "Access-Control-Allow-Headers",
      "x-access-token, Origin, Content-Type, Accept"
    );
    next();
  });

  // --- Actuator Endpoints ---
  app.get(
    "/api/v1/actuators",
    [authJwt.verifyToken],
    actuatorController.getAllActuators
  );
  app.post(
    "/api/v1/actuators/:actuatorId/command",
    [authJwt.verifyToken],
    actuatorController.sendCommand
  );

  // --- Schedule Endpoints ---
  app.get(
    "/api/v1/actuators/:actuatorId/schedules",
    [authJwt.verifyToken],
    actuatorController.getSchedules
  );
  app.post(
    "/api/v1/actuators/:actuatorId/schedules",
    [authJwt.verifyToken],
    actuatorController.createSchedule
  );
  app.put(
    "/api/v1/schedules/:scheduleId",
    [authJwt.verifyToken],
    actuatorController.updateSchedule
  );
  app.delete(
    "/api/v1/schedules/:scheduleId",
    [authJwt.verifyToken],
    actuatorController.deleteSchedule
  );
};
