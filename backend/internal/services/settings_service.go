package services

import (
	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/repositories"
)

type SettingsService interface {
	GetUserSettings(userID int) (*models.AppSettings, error)
	UpdateUserSettings(userID int, updatedSettings *models.AppSettings) error
}

type settingsService struct {
	repo repositories.SettingsRepository
}

func NewSettingsService(repo repositories.SettingsRepository) SettingsService {
	return &settingsService{repo: repo}
}

func (s *settingsService) GetUserSettings(userID int) (*models.AppSettings, error) {
	return s.repo.GetByUserID(userID)
}

func (s *settingsService) UpdateUserSettings(userID int, updatedSettings *models.AppSettings) error {
	// Pastikan user ID yang akan diupdate adalah user ID dari token
	updatedSettings.UserID = userID
	return s.repo.Upsert(updatedSettings)
}
