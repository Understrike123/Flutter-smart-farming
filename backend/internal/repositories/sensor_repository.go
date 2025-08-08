package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
	"log"
	"time"
)

type SensorRepository interface {
	FindAll() ([]models.Sensor, error)
	GetLatestReading(sensorID int) (*models.SensorReading, error)
	GetHistory(sensorID int, startTime, endTime time.Time) ([]models.SensorReading, error)
}

type sensorRepository struct {
	db *sql.DB
}

func NewSensorRepository(db *sql.DB) SensorRepository {
	return &sensorRepository{db: db}
}

// FindAll mengambil semua sensor yang terdaftar dari database.
func (r *sensorRepository) FindAll() ([]models.Sensor, error) {
	log.Println("DEBUG: Masuk ke repository FindAll.")
	query := "SELECT id, name, type, unit FROM sensor_data"
	rows, err := r.db.Query(query)
	if err != nil {
		log.Printf("ERROR: Gagal saat menjalankan db.Query: %v", err)
		return nil, err
	}
	defer rows.Close()

	var sensors []models.Sensor
	log.Println("DEBUG: Query berhasil, memulai iterasi baris...")

	for rows.Next() {
		var sensor models.Sensor
		// Tambahkan &sensor.Unit saat scan
		if err := rows.Scan(&sensor.ID, &sensor.Name, &sensor.Type, &sensor.Unit); err != nil {
			return nil, err
		}

		latestReading, err := r.GetLatestReading(sensor.ID)
		if err != nil {
			// Jika terjadi error (selain tidak ada baris), hentikan proses
			return nil, err
		}

		if latestReading != nil {
			sensor.CurrentValue = latestReading.Value
			// Logika sederhana untuk status, bisa dibuat lebih kompleks
			if latestReading.Value > 50 {
				sensor.Status = "Normal"
			} else {
				sensor.Status = "Rendah"
			}
		} else {
			// Beri nilai default jika tidak ada data pembacaan
			sensor.CurrentValue = 0
			sensor.Status = "N/A"
		}
		
		sensors = append(sensors, sensor)
	}
	log.Println("DEBUG: Selesai iterasi, mengembalikan data sensor.")
	return sensors, nil
}

// GetLatestReading mengambil data pembacaan terakhir dari sensor tertentu.
func (r *sensorRepository) GetLatestReading(sensorID int) (*models.SensorReading, error) {
	reading := &models.SensorReading{}
	query := `
		SELECT id, sensor_id, value, timestamp 
		FROM sensor_readings 
		WHERE sensor_id = $1 
		ORDER BY timestamp DESC 
		LIMIT 1`

	err := r.db.QueryRow(query, sensorID).Scan(&reading.ID, &reading.SensorID, &reading.Value, &reading.Timestamp)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // Tidak ada data, bukan error
		}
		return nil, err
	}
	return reading, nil
}

// GetHistory mengambil riwayat pembacaan sensor dalam rentang waktu tertentu.
func (r *sensorRepository) GetHistory(sensorID int, startTime, endTime time.Time) ([]models.SensorReading, error) {
	query := `
		SELECT id, sensor_id, value, timestamp 
		FROM sensor_readings 
		WHERE sensor_id = $1 AND timestamp BETWEEN $2 AND $3 
		ORDER BY timestamp ASC`
	
	rows, err := r.db.Query(query, sensorID, startTime, endTime)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var readings []models.SensorReading
	for rows.Next() {
		var reading models.SensorReading
		if err := rows.Scan(&reading.ID, &reading.SensorID, &reading.Value, &reading.Timestamp); err != nil {
			return nil, err
		}
		readings = append(readings, reading)
	}
	return readings, nil
}
