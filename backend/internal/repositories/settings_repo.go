package repositories

import (
	"database/sql"
	"flutter-smart-farming/backend/internal/models"
)

type SettingsRepository interface {
	GetByUserID(userID int) (*models.AppSettings, error)
	Upsert(settings *models.AppSettings) error // Upsert = Update or Insert
}

type settingsRepository struct {
	db *sql.DB
}

func NewSettingsRepository(db *sql.DB) SettingsRepository {
	return &settingsRepository{db: db}
}

// GetByUserID mengambil pengaturan untuk pengguna tertentu.
func (r *settingsRepository) GetByUserID(userID int) (*models.AppSettings, error) {
	settings := &models.AppSettings{UserID: userID}
	query := `SELECT notifications_enabled, soil_moisture_threshold FROM user_settings WHERE user_id = $1`

	err := r.db.QueryRow(query, userID).Scan(&settings.NotificationsEnabled, &settings.SoilMoistureThreshold)
	if err != nil {
		if err == sql.ErrNoRows {
			// Jika belum ada pengaturan, kembalikan pengaturan default
			return &models.AppSettings{
				UserID:                userID,
				NotificationsEnabled:  true,
				SoilMoistureThreshold: 25.0,
			}, nil
		}
		return nil, err // Error lain
	}
	return settings, nil
}

// Upsert memperbarui pengaturan pengguna jika ada, atau membuatnya jika tidak ada.
func (r *settingsRepository) Upsert(settings *models.AppSettings) error {
	query := `
		INSERT INTO user_settings (user_id, notifications_enabled, soil_moisture_threshold, updated_at)
		VALUES ($1, $2, $3, NOW())
		ON CONFLICT (user_id) DO UPDATE SET
			notifications_enabled = EXCLUDED.notifications_enabled,
			soil_moisture_threshold = EXCLUDED.soil_moisture_threshold,
			updated_at = NOW()`

	_, err := r.db.Exec(query, settings.UserID, settings.NotificationsEnabled, settings.SoilMoistureThreshold)
	return err
}
