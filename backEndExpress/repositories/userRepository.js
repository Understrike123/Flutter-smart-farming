const db = require("../models");
const User = db.user;
const { Op } = db.Sequelize;

exports.createUser = async (userData) => {
  return await User.create(userData);
};

exports.findUserByUsernameOrEmail = async (usernameOrEmail) => {
  return await User.findOne({
    where: {
      [Op.or]: [{ username: usernameOrEmail }, { email: usernameOrEmail }],
    },
  });
};
