// Sebaiknya nama file ini adalah: internal/models/sensor.go
package models

import "time"

type SensorData struct {
    ID        int       `json:"id"`
    Type      string    `json:"type"`      // Contoh: "temperature", "humidity"
    Value     float64   `json:"value"`     // Nilai sensor
    Timestamp time.Time `json:"timestamp"` // Waktu pengambilan data
}