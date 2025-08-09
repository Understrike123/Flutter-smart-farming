package models

// Actuator merepresentasikan data aktuator dari database.
type Actuator struct {
	ID         int    `json:"id"`
	DeviceID   string `json:"device_id"` // <-- Dibutuhkan untuk INSERT
	Name       string `json:"name"`
	Type       string `json:"type"`
	Location   string `json:"location"` // <-- Dibutuhkan untuk INSERT
	Status     bool   `json:"status"`
	Mode       string `json:"mode"`
}

// ActuatorCommand merepresentasikan log perintah yang dikirim ke aktuator.
// DEFINISI YANG HILANG ADA DI SINI.
type ActuatorCommand struct {
	ID              int    `json:"id"`
	ActuatorID      int    `json:"actuator_id"`
	Command         string `json:"command"` // "TURN_ON" atau "TURN_OFF"
	DurationMinutes *int   `json:"duration_minutes,omitempty"` // Pointer agar bisa NULL
	Status          string `json:"status"` // "SUCCESS" atau "FAILED"
}
