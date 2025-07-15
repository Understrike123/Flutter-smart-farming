// internal/utils/auth.go

package utils

import (
		"os"
		"time"
		"flutter-smart-farming/backend/internal/models"
		"github.com/golang-jwt/jwt/v5"
)


// GenerateJWT membuat token JWT baru untuk user yang berhasil login.
func GenerateJWT(user *models.User) (string, error) {
	// Ambi secret key dari environtment variable
	secretKey := []byte(os.Getenv("JWT_SECRET_KEY"))

	// Buat claims (payload) untuk token
	claims := jwt.MapClaims{
		"user_id": user.ID,
		"email": user.Email,
		"exp": time.Now().Add(time.Hour * 24).Unix(), // Token berlaku selama 24 jam
		"iat": time.Now().Unix(), // ID user sebagai subject
	}

	// Buat token baru dengan claims dan metode signing HS256
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
 
	// Tandatangani token dengan secret key untuk menghasilkan string token
	tokenString, err := token.SignedString(secretKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}