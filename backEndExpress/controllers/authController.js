const authService = require("../services/authService");

exports.register = async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return res
        .status(400)
        .send({ message: "Username, email, dan password diperlukan." });
    }
    const user = await authService.registerUser({ username, email, password });
    res
      .status(201)
      .send({ message: "User berhasil didaftarkan!", userId: user.id });
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { username_or_email, password } = req.body;
    if (!username_or_email || !password) {
      return res
        .status(400)
        .send({ message: "Username/email dan password diperlukan." });
    }
    const data = await authService.loginUser({ username_or_email, password });
    res.status(200).send(data);
  } catch (error) {
    res.status(401).send({
      message: error.message || "Login gagal. Kredensial tidak valid.",
    });
  }
};
