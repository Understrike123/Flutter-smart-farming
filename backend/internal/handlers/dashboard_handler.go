package handlers

import (
	"flutter-smart-farming/backend/internal/services"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type DashboardHandler struct {
	dashboardService services.DashboardService
}

func NewDashboardHandler(dashboardService services.DashboardService) *DashboardHandler {
	return &DashboardHandler{dashboardService: dashboardService}
}

// GetDashboardSummary adalah handler untuk endpoint GET /api/v1/dashboard.
func (h *DashboardHandler) GetDashboardSummary(c *gin.Context) {
	log.Println("INFO: DashboardHandler: Menerima permintaan untuk ringkasan dasbor.")
	
	summary, err := h.dashboardService.GetDashboardSummary()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memproses data dasbor"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Berhasil mengambil data dasbor",
		"data":    summary,
	})
}
