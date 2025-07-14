// internal/handlers/user_handler.go
package handlers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"flutter-smart-farming/backend/internal/services"
)

// UserHandler menangani request HTTP yang berhubungan dengan user.
type UserHandler struct {
	userService services.UserService
}

// NewUserHandler membuat instance baru dari UserHandler.
func NewUserHandler(s services.UserService) *UserHandler {
	return &UserHandler{userService: s}
}

// --- DTOs (Data Transfer Objects) ---

type RegisterRequest struct {
	Name     string `json:"name" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

// PERBAIKAN: Menambahkan definisi untuk LoginRequest
type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type UserResponse struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"`
}

// PERBAIKAN: Menambahkan definisi untuk LoginResponse
type LoginResponse struct {
	Token string `json:"token"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}

// --- Handlers ---

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

	response := UserResponse{
		ID:        user.ID,
		Name:      user.Name,
		Email:     user.Email,
		CreatedAt: user.CreatedAt,
	}

	c.JSON(http.StatusCreated, response)
}

// Login menghandle endpoint untuk proses login.
func (h *UserHandler) Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Input tidak valid: " + err.Error()})
		return
	}

	token, err := h.userService.Login(req.Email, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, ErrorResponse{Error: err.Error()})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{Token: token})
}