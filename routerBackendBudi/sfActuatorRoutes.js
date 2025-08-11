// routes/sfActuatorRoutes.js
const express = require("express");
const router = express.Router();
const db = require("../config/database");
const { authenticateToken } = require("../middleware/authMiddleware");
const { publishCommand } = require("../services/mqttService");

// Endpoint untuk mendapatkan daftar aktuator pengguna yang terautentikasi
// PATH: /api/sf/actuators
router.get("/", authenticateToken, async (req, res) => {
    try {
        const username = req.user.username;
        const query = "SELECT id, name, type, status, mode FROM sf_actuators WHERE username = ?";
        const [rows] = await db.query(query, [username]);
        res.json({ success: true, data: rows });
    } catch (error) {
        console.error("❌ Error mengambil daftar aktuator:", error);
        res.status(500).json({ success: false, message: "Gagal mengambil daftar aktuator.", error: error.message });
    }
});

// Endpoint untuk mengirim perintah ke aktuator
// PATH: /api/sf/actuators/:actuator_id/command
router.post("/:actuator_id/command", authenticateToken, async (req, res) => {
    console.log("✅ REQUEST MASUK KE ENDPOINT AKTUATOR!"); // ✅ LOG UNTUK DEBUGGING
    try {
        const { actuator_id } = req.params;
        const { command } = req.body;
        const username = req.user.username;

        if (!command) {
            return res.status(400).json({ success: false, message: "❌ Perintah tidak boleh kosong." });
        }

        const [actuator] = await db.query(
            "SELECT id FROM sf_actuators WHERE id = ? AND username = ? LIMIT 1",
            [actuator_id, username]
        );
        
        if (actuator.length === 0) {
            return res.status(404).json({ success: false, message: "❌ Aktuator tidak ditemukan atau bukan milik Anda." });
        }
        
        // Simpan command ke database atau kirim ke MQTT
        // publishCommand(mqttTopic, { command });

        res.json({ success: true, message: `✅ Perintah '${command}' berhasil dikirim ke aktuator.` });
    } catch (error) {
        console.error("❌ Error mengirim perintah aktuator:", error);
        res.status(500).json({ success: false, message: "Gagal mengirim perintah.", error: error.message });
    }
});

module.exports = router;