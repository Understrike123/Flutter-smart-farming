require("dotenv").config();
const express = require("express");
const cors = require("cors");
const db = require("./models"); // Sequelize models

// --- Inisialisasi Aplikasi Express ---
const app = express();
const PORT = process.env.PORT || 8080;

// --- Middleware ---
app.use(cors()); // Mengizinkan request dari domain lain (misalnya, aplikasi Flutter Anda)
app.use(express.json()); // Mem-parsing body request sebagai JSON
app.use(express.urlencoded({ extended: true }));

// --- Sinkronisasi Database ---
// Dalam development, Anda mungkin ingin menghapus dan membuat ulang tabel.
// db.sequelize.sync({ force: true }).then(() => {
//   console.log("Drop and re-sync db.");
// });
db.sequelize
  .sync()
  .then(() => {
    console.log("Database berhasil tersinkronisasi.");
  })
  .catch((err) => {
    console.log("Gagal sinkronisasi database: " + err.message);
  });

// --- Routes ---
app.get("/", (req, res) => {
  res.json({ message: "Selamat datang di Smart Farming API." });
});

// Memuat semua file route dari folder routes
require("./routes/authRoutes")(app);
require("./routes/sensorRoutes")(app); // DITAMBAHKAN: Route untuk Sensor
// require('./routes/dashboardRoutes')(app); // Akan diimplementasikan
require("./routes/actuatorRoutes")(app); // Akan diimplementasikan
// require('./routes/notificationRoutes')(app); // Akan diimplementasikan
// require('./routes/settingsRoutes')(app); // Akan diimplementasikan

// --- Menjalankan Server ---
app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}.`);
});
