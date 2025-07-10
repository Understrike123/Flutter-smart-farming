// internal/config/env.go

package config

import (
	"log"
	"github.com/joho/godotenv"
)

// LoadEnv memuat variable variable dari file .env
func LoadEnv() {
	err := godotenv.Load()
	if err != nil {
		log.Println("Peringatan: Gagal memuat file .env Menggunakan environment variable sistem.")
	}
}