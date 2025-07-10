// internal/repositories/user_repository.go
package repositories

import (
	"database/sql"
	"smart_farming_backend/internal/models"
)

// UserRepository adalah interface yang mendefinisikan operasi database untuk user.
type UserRepository interface {
	Save(user *models.User) error
	FindByEmail(email string) (*models.User, error)
}

// userRepository adalah implementasi dari UserRepository.
type userRepository struct {
	db *sql.DB
}

// NewUserRepository membuat instance baru dari userRepository.
func NewUserRepository(db *sql.DB) UserRepository {
	return &userRepository{db: db}
}

// Save menyimpan user baru ke dalam database.
func (r *userRepository) Save(user *models.User) error {
	query := "INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id, created_at"
	err := r.db.QueryRow(query, user.Name, user.Email, user.Password).Scan(&user.ID, &user.CreatedAt)
	return err
}

// FindByEmail mencari user berdasarkan alamat email.
func (r *userRepository) FindByEmail(email string) (*models.User, error) {
	user := &models.User{}
	query := "SELECT id, name, email, password, created_at FROM users WHERE email = $1"
	// Memperbaiki variabel yang salah: `&userPassword` menjadi `&user.Password`
	err := r.db.QueryRow(query, email).Scan(&user.ID, &user.Name, &user.Email, &user.Password, &user.CreatedAt)
	if err != nil {
		return nil, err
	}
	return user, nil
}
