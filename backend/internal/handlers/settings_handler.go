package handlers

import (
	"log"
	"net/http"

	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/services"

	"github.com/gin-gonic/gin"
)

type SettingsHandler struct {
	settingsService services.SettingsService
}

func NewSettingsHandler(settingsService services.SettingsService) *SettingsHandler {
	return &SettingsHandler{settingsService: settingsService}
}

// GetSettings menangani GET /api/v1/settings
func (h *SettingsHandler) GetSettings(c *gin.Context) {
	userID, _ := c.Get("user_id") // Diambil dari middleware

	settings, err := h.settingsService.GetUserSettings(int(userID.(float64)))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memuat pengaturan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": settings})
}

// UpdateSettings menangani PUT /api/v1/settings
func (h *SettingsHandler) UpdateSettings(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req models.AppSettings
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Data input tidak valid"})
		return
	}

	err := h.settingsService.UpdateUserSettings(int(userID.(float64)), &req)
	if err != nil {
		log.Printf("ERROR: Gagal update pengaturan untuk user %v: %v", userID, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan pengaturan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Pengaturan berhasil diperbarui"})
}
