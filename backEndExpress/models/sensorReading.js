module.exports = (sequelize, Sequelize) => {
  const SensorReading = sequelize.define("sensor_readings", {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    value: {
      type: Sequelize.FLOAT,
      allowNull: false,
    },
    timestamp: {
      type: Sequelize.DATE,
      allowNull: false,
    },
  });

  return SensorReading;
};
