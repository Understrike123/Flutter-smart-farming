// routes/sfSchedulesRoutes.js
const express = require("express");
const router = express.Router();
const db = require("../config/database");
const { authenticateToken } = require("../middleware/authMiddleware");

// Middleware untuk semua route ini
router.use(authenticateToken);

// Endpoint untuk mendapatkan semua jadwal
// Path: /api/sf/schedules
router.get("/", async (req, res) => {
    try {
        const username = req.user.username;
        const query = `
            SELECT * FROM sf_schedules
            WHERE username = ?
            ORDER BY time_of_day ASC
        `;
        const [rows] = await db.query(query, [username]);
        res.json({ success: true, data: rows });
    } catch (error) {
        console.error("❌ Error mengambil jadwal:", error);
        res.status(500).json({ success: false, message: "Gagal mengambil jadwal.", error: error.message });
    }
});

// Endpoint untuk membuat jadwal baru
// Path: /api/sf/schedules
router.post("/", async (req, res) => {
    try {
        const username = req.user.username;
        const { actuator_id, schedule_type, time_of_day, day_of_week, criteria_json, duration_minutes, is_active } = req.body;

        if (!actuator_id || !schedule_type || !time_of_day) {
            return res.status(400).json({ success: false, message: "❌ Data jadwal tidak lengkap." });
        }

        const query = `
            INSERT INTO sf_schedules (
                actuator_id, username, schedule_type, time_of_day, day_of_week,
                criteria_json, duration_minutes, is_active
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;
        await db.query(query, [
            actuator_id,
            username,
            schedule_type,
            time_of_day,
            day_of_week,
            criteria_json,
            duration_minutes,
            is_active
        ]);

        res.json({ success: true, message: "✅ Jadwal baru berhasil dibuat." });
    } catch (error) {
        console.error("❌ Error membuat jadwal:", error);
        res.status(500).json({ success: false, message: "Gagal membuat jadwal.", error: error.message });
    }
});

// Endpoint untuk menghapus jadwal
// Path: /api/sf/schedules/:schedule_id
router.delete("/:schedule_id", async (req, res) => {
    try {
        const { schedule_id } = req.params;
        const username = req.user.username;

        const [result] = await db.query("DELETE FROM sf_schedules WHERE id = ? AND username = ?", [schedule_id, username]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: "❌ Jadwal tidak ditemukan atau bukan milik Anda." });
        }
        res.json({ success: true, message: "✅ Jadwal berhasil dihapus." });
    } catch (error) {
        console.error("❌ Error menghapus jadwal:", error);
        res.status(500).json({ success: false, message: "Gagal menghapus jadwal.", error: error.message });
    }
});

module.exports = router;