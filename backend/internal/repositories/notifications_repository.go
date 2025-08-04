package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
	"time"
)

type NotificationRepository interface {
	FindLatest(limit int) ([]models.AppNotification, error)
}

type notificationRepository struct {
	db *sql.DB
}

func NewNotificationRepository(db *sql.DB) NotificationRepository {
	return &notificationRepository{db: db}
}

// FindLatest mengembalikan data notifikasi dummy.
func (r *notificationRepository) FindLatest(limit int) ([]models.AppNotification, error) {
	// NANTI: Ganti ini dengan query database sungguhan
	notifications := []models.AppNotification{
		{ID: 1, Title: "Kelembaban Tanah Rendah!", Subtitle: "Zona 2 – Perlu Penyiraman Segera.", Type: "penting", Timestamp: time.Now().Add(-2 * time.Hour), IsRead: false},
		{ID: 2, Title: "Suhu Udara Tinggi Terdeteksi", Subtitle: "Suhu mencapai 35°C di kebun.", Type: "penting", Timestamp: time.Now().Add(-29 * time.Hour), IsRead: true},
	}
	// Pastikan jumlahnya tidak melebihi limit
	if len(notifications) > limit {
		return notifications[:limit], nil
	}
	return notifications, nil
}