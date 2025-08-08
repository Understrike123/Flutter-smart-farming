module.exports = (sequelize, Sequelize) => {
  const Actuator = sequelize.define("actuators", {
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
    status: {
      type: Sequelize.BOOLEAN,
      defaultValue: false, // false = OFF, true = ON
    },
    mode: {
      type: Sequelize.STRING,
      defaultValue: "manual", // 'manual' atau 'auto'
    },
    last_command_at: Sequelize.DATE,
  });
  return Actuator;
};
