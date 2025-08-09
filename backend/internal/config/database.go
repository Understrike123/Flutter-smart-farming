// internal/config/database.go
package config

import (
	"database/sql"
	"fmt"
	"os"
	"time"

	_ "github.com/lib/pq" // Driver PostgreSQL
)

func ConnectDatabase() (*sql.DB, error) {
    
	// Baca connection string langsung dari environment variable
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		return nil, fmt.Errorf("DATABASE_URL environment variable not set")
	}

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, err
	}

	err = db.Ping()
	if err != nil {
		return nil, err
	}

	// --- PERBAIKAN: Tambahkan konfigurasi connection pool di sini ---

	// 1. Atur jumlah maksimum koneksi yang idle (tidak terpakai).
	// Ini mencegah penumpukan koneksi yang bisa menjadi usang.
	db.SetMaxIdleConns(10)

	// 2. Atur jumlah maksimum koneksi yang bisa dibuka secara bersamaan.
	db.SetMaxOpenConns(100)

	// 3. Atur waktu maksimum koneksi boleh idle sebelum ditutup.
	// 5 menit adalah nilai yang baik untuk database seperti Neon.
	db.SetConnMaxIdleTime(5 * time.Minute)

	// 4. Atur waktu maksimum koneksi boleh digunakan sebelum dibuat ulang.
	// 1 jam adalah nilai yang aman untuk menghindari masalah koneksi usang.
	db.SetConnMaxLifetime(1 * time.Hour)



	return db, nil
}