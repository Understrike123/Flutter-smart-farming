package models

import "time"

// User mendefinisikan struktur data untuk pengguna.
// Pastikan semua field ini ada, terutama 'Password'.
type User struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Password  string    `json:"-"` // json:"-" berarti field ini tidak akan pernah dikirim dalam response JSON
	CreatedAt time.Time `json:"created_at"`
}