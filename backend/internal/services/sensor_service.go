package services

import (
	"time"
	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/repositories"
)

type SensorService interface {
	GetAllSensors() ([]models.Sensor, error)
	GetLatestReading(sensorID int) (*models.SensorReading, error)
	GetSensorHistory(sensorID int, startTime, endTime time.Time) ([]models.SensorReading, error)
}

type sensorService struct {
	repo repositories.SensorRepository
}

func NewSensorService(repo repositories.SensorRepository) SensorService {
	return &sensorService{repo: repo}
}

func (s *sensorService) GetAllSensors() ([]models.Sensor, error) {
	return s.repo.FindAll()
}

func (s *sensorService) GetLatestReading(sensorID int) (*models.SensorReading, error) {
	return s.repo.GetLatestReading(sensorID)
}

func (s *sensorService) GetSensorHistory(sensorID int, startTime, endTime time.Time) ([]models.SensorReading, error) {
	return s.repo.GetHistory(sensorID, startTime, endTime)
}
