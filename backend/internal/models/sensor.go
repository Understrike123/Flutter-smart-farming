// Sebaiknya nama file ini adalah: internal/models/sensor.go
package models

import "time"

type Sensor struct {
	ID         int     `json:"id"`
	DeviceID   string  `json:"device_id"` // <-- Dibutuhkan untuk INSERT
	Name       string  `json:"name"`
	Type       string  `json:"type"`
	Location   string  `json:"location"` // <-- Dibutuhkan untuk INSERT
	Unit       string  `json:"unit"`
	// Field di bawah ini diisi oleh logika service, bukan dari request
	CurrentValue float64 `json:"current_value,omitempty"`
	Status       string  `json:"status,omitempty"`
}

type SensorReading struct {
	ID        int       `json:"id"`
	SensorID  int       `json:"sensor_id"`
	Value     float64   `json:"value"`
	Timestamp time.Time `json:"timestamp"`
}