package handlers

import (
	"net/http"
	"strconv"

	"flutter-smart-farming/backend/internal/services"

	"github.com/gin-gonic/gin"
)

type NotificationHandler struct {
	notificationService services.NotificationService
}

func NewNotificationHandler(notificationService services.NotificationService) *NotificationHandler {
	return &NotificationHandler{notificationService: notificationService}
}

// GetNotifications menangani GET /api/v1/notifications
func (h *NotificationHandler) GetNotifications(c *gin.Context) {
	filter := c.DefaultQuery("filter", "semua") // default 'semua'
	notifications, err := h.notificationService.GetNotifications(filter)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil notifikasi"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": notifications})
}

// MarkNotificationRead menangani PUT /api/v1/notifications/:notification_id/read
func (h *NotificationHandler) MarkNotificationRead(c *gin.Context) {
	notificationID, err := strconv.Atoi(c.Param("notification_id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ID notifikasi tidak valid"})
		return
	}

	if err := h.notificationService.MarkNotificationAsRead(notificationID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menandai notifikasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Notifikasi berhasil ditandai sebagai sudah dibaca"})
}