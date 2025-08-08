// Sebaiknya nama file ini adalah: internal/models/sensor.go
package models

import "time"

type Sensor struct {
	ID          int     `json:"id"`
	Name        string  `json:"name"`
	Type        string  `json:"type"`
	// Tambahkan field baru untuk menampung data dari pembacaan terakhir
	CurrentValue float64 `json:"current_value"`
	Unit         string  `json:"unit"`
	Status       string  `json:"status"`
}

type SensorReading struct {
	ID        int       `json:"id"`
	SensorID  int       `json:"sensor_id"`
	Value     float64   `json:"value"`
	Timestamp time.Time `json:"timestamp"`
}