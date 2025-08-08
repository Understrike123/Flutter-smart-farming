package models

// AppSettings merepresentasikan data pengaturan pengguna.
type AppSettings struct {
	UserID                int     `json:"-"` // Tidak diekspos di JSON
	NotificationsEnabled  bool    `json:"notifications_enabled"`
	SoilMoistureThreshold float64 `json:"soil_moisture_threshold"`
}
