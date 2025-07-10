// internal/config/database.go
package config

import (
	"database/sql"
	"fmt"
	"os"
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

	return db, nil
}