package models

import "time"

type AppNotification struct {
	ID        int       `json:"id"`
	Message   string    `json:"message"`
	Type      string    `json:"type"`
	Severity  string    `json:"severity"`
	Timestamp time.Time `json:"timestamp"`
	IsRead    bool      `json:"is_read"`
}