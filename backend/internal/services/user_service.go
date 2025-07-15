// internal/services/user_service.go
package services

import (
	"errors"
	// Pastikan path import ini sesuai dengan nama modul di go.mod Anda
	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/repositories"
	"flutter-smart-farming/backend/internal/utils"
)

// UserService adalah interface yang mendefinisikan logika bisnis untuk user.
type UserService interface {
	RegisterUser(name, email, password string) (*models.User, error)
	Login(email, password string) (string, error) // Token dikembalikan sebagai string
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
	existingUser, _ := s.userRepo.FindByEmail(email)
	if existingUser != nil {
		return nil, errors.New("email sudah terdaftar")
	}

	// PERBAIKAN: Memanggil fungsi yang benar: utils.HashPassword (H kapital)
	hashedPassword, err := utils.HashPassword(password)
	if err != nil {
		return nil, errors.New("gagal memproses password")
	}

	newUser := &models.User{
		Name:     name,
		Email:    email,
		Password: hashedPassword,
	}

	if err := s.userRepo.Save(newUser); err != nil {
		return nil, errors.New("gagal menyimpan user ke database")
	}

	return newUser, nil
}

// Login menangani logika bisnis untuk proses login user.
func (s *userService) Login(email, password string) (string, error) {
	// 1. Cari user berdasarkan email
	user, err := s.userRepo.FindByEmail(email)
	if err != nil {
		return "", errors.New("email atau password salah")
	}

	// 2. Bandingkan password yang diberikan dengan hash di database
	if !utils.CheckPasswordHash(password, user.Password) {
		return "", errors.New("email atau password salah")
	}

	// 3. Jika password cocok, generate JWT token
	token, err := utils.GenerateJWT(user)
	if err != nil {
		return "", errors.New("gagal membuat token otentikasi")
	}

	return token, nil
}