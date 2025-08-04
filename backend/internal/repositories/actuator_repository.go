package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
)

type ActuatorRepository interface {
	FindAll() ([]models.Actuator, error)
}

type actuatorRepository struct {
	db *sql.DB
}

func NewActuatorRepository(db *sql.DB) ActuatorRepository {
	return &actuatorRepository{db: db}
}

// FindAll mengembalikan data aktuator dummy.
func (r *actuatorRepository) FindAll() ([]models.Actuator, error) {
	// NANTI: Ganti ini dengan query database sungguhan
	actuators := []models.Actuator{
		// status: false, "OTOMATIS"; status: true, "MANUAL"
		{ID: 1, Name: "Sistem Irigasi Utama", Status: false, Mode: "OTOMATIS"},
		{ID: 2, Name: "Pompa Pupuk Cair", Status: false, Mode: "OTOMATIS"},
	}
	return actuators, nil
}
