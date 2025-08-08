package services

import (
	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/repositories"
)

type NotificationService interface {
	GetNotifications(filter string) ([]models.AppNotification, error)
	MarkNotificationAsRead(notificationID int) error
}

type notificationService struct {
	repo repositories.NotificationRepository
}

func NewNotificationService(repo repositories.NotificationRepository) NotificationService {
	return &notificationService{repo: repo}
}

func (s *notificationService) GetNotifications(filter string) ([]models.AppNotification, error) {
	return s.repo.FindFiltered(filter)
}

func (s *notificationService) MarkNotificationAsRead(notificationID int) error {
	return s.repo.MarkAsRead(notificationID)
}