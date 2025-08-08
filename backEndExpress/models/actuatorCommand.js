module.exports = (sequelize, Sequelize) => {
  const ActuatorCommand = sequelize.define("actuator_commands", {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    command: Sequelize.STRING, // 'TURN_ON' atau 'TURN_OFF'
    duration_minutes: Sequelize.INTEGER,
    executed_at: Sequelize.DATE,
    status: Sequelize.STRING, // 'SUCCESS', 'FAILED'
  });
  return ActuatorCommand;
};
