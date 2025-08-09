package services

import (
	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/repositories"
)

type ActuatorService interface {
	GetAllActuators() ([]models.Actuator, error)
	ProcessCommand(actuatorID int, command string, duration *int) error
	CreateActuator(actuator *models.Actuator) error
}

type actuatorService struct {
	repo repositories.ActuatorRepository
}

func NewActuatorService(repo repositories.ActuatorRepository) ActuatorService{
	return &actuatorService{repo: repo}
}

func (s *actuatorService) GetAllActuators()([]models.Actuator, error){
	return s.repo.FindAll()
}

func (s *actuatorService) ProcessCommand(actuatorID int, command string, duration *int)error{
	var status bool
	var mode string

	if command == "TURN_ON"{
		status = true
		mode = "manual"
	} else if command == "TURN_OFF" {
		status = false
		mode = "auto"
	}

	err := s.repo.UpdateStatus(actuatorID, status, mode)
	if err != nil{
		return err
	}

	logEntry := models.ActuatorCommand{
		ActuatorID: actuatorID,
		Command: command,
		DurationMinutes: duration,
		Status: "SUCCESS",
	}
	return s.repo.LogCommand(logEntry)
}

func (s *actuatorService) CreateActuator(actuator *models.Actuator) error {
	return s.repo.Create(actuator)
}