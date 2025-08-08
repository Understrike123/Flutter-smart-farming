package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
)

type ActuatorRepository interface {
	FindAll() ([]models.Actuator, error)
	UpdateStatus(actuatorID int, status bool, mode string) error
	LogCommand(command models.ActuatorCommand) error
}

type actuatorRepository struct {
	db *sql.DB
}

func NewActuatorRepository(db *sql.DB) ActuatorRepository {
	return &actuatorRepository{db: db}
}

// FindAll mengambil semua aktuator dari database.
func (r *actuatorRepository) FindAll() ([]models.Actuator, error) {
	query := `SELECT id, name, status, mode FROM actuators`
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var actuators []models.Actuator
	for rows.Next() {
		var actuator models.Actuator
		if err := rows.Scan(&actuator.ID, &actuator.Name, &actuator.Status, &actuator.Mode); err != nil {
			return nil, err
		}
		actuators = append(actuators, actuator)
	}
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