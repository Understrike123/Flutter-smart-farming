module.exports = (sequelize, Sequelize) => {
  const Schedule = sequelize.define("schedules", {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    schedule_type: Sequelize.STRING, // 'DAILY', 'WEEKLY', 'THRESHOLD_BASED'
    time_of_day: Sequelize.TIME, // Hanya waktu, misal '06:00:00'
    day_of_week: Sequelize.INTEGER, // 0=Minggu, 1=Senin, ..., 6=Sabtu
    criteria_json: Sequelize.JSONB, // e.g., {"soil_moisture_min": 40}
    duration_minutes: Sequelize.INTEGER,
    is_active: {
      type: Sequelize.BOOLEAN,
      defaultValue: true,
    },
  });
  return Schedule;
};
