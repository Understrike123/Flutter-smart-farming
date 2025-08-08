package models

// Actuator merepresentasikan data aktuator dari database.
type Actuator struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Status bool   `json:"status"` // true = ON, false = OFF
	Mode   string `json:"mode"`   // "auto" atau "manual"
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
