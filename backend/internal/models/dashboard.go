package models

// DashboardSummary adalah struct yang akan diubah menjadi JSON sebagai respons.
// Tag `json:"..."` digunakan untuk mengontrol nama field di output JSON.
type DashboardSummary struct {
	CurrentSensors      []Sensor         `json:"current_sensors"`
	ActuatorStatus      []Actuator       `json:"actuator_status"`
	LatestNotifications []AppNotification `json:"latest_notifications"`
}
