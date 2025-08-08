package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
)

// metode-metode yang dibutuhkan ke dalam "kontrak" (interface)
type NotificationRepository interface {
	FindLatest(limit int) ([]models.AppNotification, error)
	FindFiltered(filter string) ([]models.AppNotification, error)
	MarkAsRead(notificationID int) error
}
type notificationRepository struct {
	db *sql.DB
}

func NewNotificationRepository(db *sql.DB) NotificationRepository {
	return &notificationRepository{db: db}
}

// FindLatest mengambil notifikasi terbaru sejumlah 'limit'.
func (r *notificationRepository) FindLatest(limit int) ([]models.AppNotification, error) {
	// Query ini mengambil notifikasi terbaru berdasarkan waktu pembuatannya.
	query := `
		SELECT id, message, type, severity, created_at, is_read 
		FROM notifications 
		ORDER BY created_at DESC 
		LIMIT $1`

	rows, err := r.db.Query(query, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var notifications []models.AppNotification
	for rows.Next() {
		var n models.AppNotification
		// PERBAIKAN: Sesuaikan urutan scan
		if err := rows.Scan(&n.ID, &n.Message, &n.Type, &n.Severity, &n.Timestamp, &n.IsRead); err != nil {
			return nil, err
		}
		notifications = append(notifications, n)
	}
	return notifications, nil
}

// FindLatest mengembalikan data notifikasi dummy.
func (r *notificationRepository) FindFiltered(filter string) ([]models.AppNotification, error) {
	query := `SELECT id, message, type, severity, created_at, is_read FROM notifications`

	switch filter {
	case "penting":
		query += ` WHERE severity = 'WARNING' OR severity = 'CRITICAL'`
	case "belumDibaca":
		query += ` WHERE is_read = false`
	}
	query += ` ORDER BY created_at DESC`

	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var notifications []models.AppNotification
	for rows.Next() {
		var n models.AppNotification
		// PERBAIKAN: Sesuaikan urutan scan
		if err := rows.Scan(&n.ID, &n.Message, &n.Type, &n.Severity, &n.Timestamp, &n.IsRead); err != nil {
			return nil, err
		}
		notifications = append(notifications, n)
	}
	return notifications, nil
}


// MarkAsRead menandai notifikasi sebagai sudah dibaca.
func (r *notificationRepository) MarkAsRead(notificationID int) error {
	query := `UPDATE notifications SET is_read = true WHERE id = $1`
	_, err := r.db.Exec(query, notificationID)
	return err
}