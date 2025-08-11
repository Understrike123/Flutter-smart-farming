const express = require("express");
const router = express.Router();
const db = require("../config/database");

router.get("/:sensor_id/history", async (req, res) => {
    try {
        const { sensor_id } = req.params;
        const { duration } = req.query;
        const username = req.user.username;
        if (!duration) {
            return res.status(400).json({ success: false, message: "❌ Parameter 'duration' wajib diisi." });
        }
        let interval;
        const durationValue = parseInt(duration.slice(0, -1));
        const durationUnit = duration.slice(-1);
        if (durationUnit === 'h') {
            interval = `INTERVAL ${durationValue} HOUR`;
        } else if (durationUnit === 'd') {
            interval = `INTERVAL ${durationValue} DAY`;
        } else {
            return res.status(400).json({ success: false, message: "❌ Format duration tidak valid. Gunakan '24h', '7d', atau '30d'." });
        }
        const query = `
            SELECT value, timestamp 
            FROM sf_sensor_readings sr
            JOIN sf_sensors s ON sr.sensor_id = s.id
            WHERE s.id = ? AND s.username = ? AND sr.timestamp >= (NOW() - ${interval})
            ORDER BY sr.timestamp ASC
        `;
        const [rows] = await db.query(query, [sensor_id, username]);
        if (rows.length === 0) {
            return res.status(404).json({ success: false, message: "❌ Data historis tidak ditemukan." });
        }
        res.json({ success: true, data: rows });
    } catch (error) {
        console.error("❌ Error mengambil data historis sensor:", error);
        res.status(500).json({ success: false, message: "Gagal mengambil data historis.", error: error.message });
    }
});

router.post("/readings", async (req, res) => {
    try {
        const { device_id, value, api_key } = req.body;
        const [sensor] = await db.query("SELECT id FROM sf_sensors WHERE device_id = ? LIMIT 1", [device_id]);
        if (sensor.length === 0) {
            return res.status(404).json({ success: false, message: "❌ Sensor tidak terdaftar." });
        }
        const sensor_id = sensor[0].id;
        const query = "INSERT INTO sf_sensor_readings (sensor_id, value) VALUES (?, ?)";
        await db.query(query, [sensor_id, value]);
        res.json({ success: true, message: "✅ Pembacaan sensor berhasil disimpan." });
    } catch (error) {
        console.error("❌ Error menyimpan pembacaan sensor:", error);
        res.status(500).json({ success: false, message: "Gagal menyimpan data sensor.", error: error.message });
    }
});

module.exports = router;