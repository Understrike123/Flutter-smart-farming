// internal/handlers/user_handler.go
package handlers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"smart_farming_backend/internal/services"
)

// UserHandler menangani request HTTP yang berhubungan dengan user.
type UserHandler struct {
	userService services.UserService
}

// NewUserHandler membuat instance baru dari UserHandler.
func NewUserHandler(s services.UserService) *UserHandler {
	return &UserHandler{userService: s}
}

// RegisterRequest adalah DTO (Data Transfer Object) untuk request registrasi.
type RegisterRequest struct {
	Name     string `json:"name" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

// UserResponse adalah DTO untuk response data user.
// Pastikan tipe data field di sini cocok dengan tipe data yang akan diisi.
type UserResponse struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"` // Tipe data di sini adalah time.Time
}

// ErrorResponse adalah DTO untuk response error.
type ErrorResponse struct {
	Error string `json:"error"`
}

// RegisterUser menghandle endpoint untuk registrasi user baru.
func (h *UserHandler) RegisterUser(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Input tidak valid: " + err.Error()})
		return
	}

	user, err := h.userService.RegisterUser(req.Name, req.Email, req.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: err.Error()})
		return
	}

	// Membuat response dengan tipe data yang benar.
	// user.CreatedAt (time.Time) dimasukkan ke field CreatedAt (time.Time).
	response := UserResponse{
		ID:        user.ID,
		Name:      user.Name,
		Email:     user.Email,
		CreatedAt: user.CreatedAt,
	}

	c.JSON(http.StatusCreated, response)
}
