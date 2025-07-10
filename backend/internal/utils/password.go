// internal/utils/password.go
package utils

import "golang.org/x/crypto/bcrypt"

// HashPassword mengenkripsi password menggunakan bcrypt
func HashPassword(password string) (string, error) {
	// Menghasilkan hash dari password dengan cost factor 14
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

// CheckPasswordHash membandingkan password teks biasa dengan hash-nya
func CheckPasswordHash(password, hash string) bool {
	// Membandingkan hash yang tersimpan dengan password yang diberikan saat login
	// Kesalahan sebelumnya: `[]bytes(hash)` seharusnya `[]byte(hash)`
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	
	// Jika tidak ada error (err == nil), berarti password cocok.
	return err == nil
}
