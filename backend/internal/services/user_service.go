// internal/services/user_service.go
package services

import (
	"errors"
	// Pastikan path import ini sesuai dengan nama modul di go.mod Anda
	"smart_farming_backend/internal/models"
	"smart_farming_backend/internal/repositories"
	"smart_farming_backend/internal/utils"
)

// UserService adalah interface yang mendefinisikan logika bisnis untuk user.
type UserService interface {
	// Mengembalikan pointer ke User (*models.User) agar bisa mengembalikan nil jika terjadi error.
	RegisterUser(name, email, password string) (*models.User, error)
}

type userService struct {
	userRepo repositories.UserRepository
}

// NewUserService membuat instance baru dari UserService.
func NewUserService(repo repositories.UserRepository) UserService {
	return &userService{userRepo: repo}
}

// RegisterUser menangani logika bisnis untuk mendaftarkan user baru.
func (s *userService) RegisterUser(name, email, password string) (*models.User, error) {
	// 1. Cek apakah email sudah ada.
	// Memanggil metode yang benar: FindByEmail, bukan GetUserByEmail.
	existingUser, _ := s.userRepo.FindByEmail(email)
	if existingUser != nil {
		return nil, errors.New("email sudah terdaftar")
	}

	// 2. Hash password untuk keamanan.
	hashedPassword, err := utils.HashPassword(password)
	if err != nil {
		return nil, errors.New("gagal memproses password")
	}

	// 3. Buat instance user baru.
	newUser := &models.User{
		Name:     name,
		Email:    email,
		Password: hashedPassword,
	}

	// 4. Simpan user baru ke database.
	// Memanggil metode yang benar: Save, bukan CreateUser.
	if err := s.userRepo.Save(newUser); err != nil {
		return nil, errors.New("gagal menyimpan user ke database")
	}

	// Mengembalikan objek user yang baru dibuat.
	return newUser, nil
}
