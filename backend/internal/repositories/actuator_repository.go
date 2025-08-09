package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
	"log"
)

type ActuatorRepository interface {
	FindAll() ([]models.Actuator, error)
	UpdateStatus(actuatorID int, status bool, mode string) error
	LogCommand(command models.ActuatorCommand) error
	Create(actuator *models.Actuator) error
}

type actuatorRepository struct {
	db *sql.DB
}

func NewActuatorRepository(db *sql.DB) ActuatorRepository {
	return &actuatorRepository{db: db}
}

// FindAll mengambil semua aktuator dari database.
func (r *actuatorRepository) FindAll() ([]models.Actuator, error) {
	log.Println("DEBUG: Masuk ke repository Actuator.FindAll.")
	
	// PERBAIKAN: Tambahkan "ORDER BY id ASC" untuk memastikan urutan data selalu konsisten.
	query := `SELECT id, name, status, mode, device_id, type, location FROM actuators ORDER BY id ASC`

	rows, err := r.db.Query(query)
	if err != nil {
		log.Printf("ERROR: Gagal saat menjalankan db.Query di Actuator.FindAll: %v", err)
		return nil, err
	}
	defer rows.Close()

	var actuators []models.Actuator
	log.Println("DEBUG: Query aktuator berhasil, memulai iterasi baris...")

	for rows.Next() {
		var actuator models.Actuator
		log.Println("DEBUG: Membaca baris baru untuk aktuator...")

		if err := rows.Scan(&actuator.ID, &actuator.Name, &actuator.Status, &actuator.Mode, &actuator.DeviceID, &actuator.Type, &actuator.Location); err != nil {
			log.Printf("ERROR: Gagal saat rows.Scan di Actuator.FindAll: %v", err)
			return nil, err
		}
		
		log.Printf("DEBUG: Baris aktuator berhasil di-scan: ID=%d, Name=%s", actuator.ID, actuator.Name)
		actuators = append(actuators, actuator)
	}

	log.Println("DEBUG: Selesai iterasi, mengembalikan data aktuator.")
	return actuators, nil
}


// UpdateStatus memperbarui status dan mode dari aktuator tertentu.
func (r *actuatorRepository) UpdateStatus(actuatorID int, status bool, mode string) error {
	query := `UPDATE actuators SET status = $1, mode = $2, last_command_at = NOW() WHERE id = $3`
	_, err := r.db.Exec(query, status, mode, actuatorID)
	return err
}

// LogCommand mencatat perintah yang dieksekusi ke database.
func (r *actuatorRepository) LogCommand(command models.ActuatorCommand) error {
	query := `INSERT INTO actuator_commands (actuator_id, command, duration_minutes, status) VALUES ($1, $2, $3, $4)`
	_, err := r.db.Exec(query, command.ActuatorID, command.Command, command.DurationMinutes, command.Status)
	return err
}

func (r *actuatorRepository) Create(actuator *models.Actuator) error {
	query := `INSERT INTO actuators (device_id, name, type, location) VALUES ($1, $2, $3, $4)`
	_, err := r.db.Exec(query, actuator.ID, actuator.Name, actuator.Type, actuator.Location)
	return err
}
