// Sebaiknya nama file ini adalah: internal/models/sensor.go
package models

import "time"

type Sensor struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Type string `json:"type"`
}

type SensorReading struct {
	ID        int       `json:"id"`
	SensorID  int       `json:"sensor_id"`
	Value     float64   `json:"value"`
	Timestamp time.Time `json:"timestamp"`
}