const userRepository = require('../repositories/userRepository');
const bcrypt = require('bcryptjs');
const jwt = = require('jsonwebtoken');
const config = require('../config/auth.config');

exports.registerUser = async (userData) => {
  const { username, email, password } = userData;
  // Enkripsi password sebelum disimpan
  const hashedPassword = bcrypt.hashSync(password, 8);
  return await userRepository.createUser({
    username,
    email,
    password_hash: hashedPassword,
  });
};

exports.loginUser = async (loginData) => {
  const { username_or_email, password } = loginData;
  const user = await userRepository.findUserByUsernameOrEmail(username_or_email);

  if (!user) {
    throw new Error("User tidak ditemukan.");
  }

  const passwordIsValid = bcrypt.compareSync(password, user.password_hash);

  if (!passwordIsValid) {
    throw new Error("Password salah!");
  }

  // Membuat token JWT
  const token = jwt.sign({ id: user.id }, config.secret, {
    expiresIn: 86400 // 24 jam
  });

  return {
    token,
    user_id: user.id,
    message: "Login berhasil"
  };
};