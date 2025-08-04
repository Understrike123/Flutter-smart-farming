package models

import "time"

type AppNotification struct {
	ID        int       `json:"id"`
	Title     string    `json:"title"`
	Subtitle  string    `json:"subtitle"`
	Type      string    `json:"type"`
	Timestamp time.Time `json:"timestamp"`
	IsRead    bool      `json:"is_read"`
}