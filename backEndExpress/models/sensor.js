module.exports = (sequelize, Sequelize) => {
  const Sensor = sequelize.define("sensors", {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    device_id: {
      type: Sequelize.STRING,
      unique: true,
    },
    name: Sequelize.STRING,
    type: Sequelize.STRING,
    location: Sequelize.STRING,
    unit: Sequelize.STRING,
    threshold_min: Sequelize.FLOAT,
    threshold_max: Sequelize.FLOAT,
  });

  return Sensor;
};
