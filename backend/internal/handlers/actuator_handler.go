package handlers

import (
	"flutter-smart-farming/backend/internal/services"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type ActuatorHandler struct{
	actuatorService services.ActuatorService
}

func NewActuatorHandler(actuatorService services.ActuatorService) *ActuatorHandler{
	return &ActuatorHandler{actuatorService: actuatorService}
}

// getActuators menangani GET /api/v1/actuators
func (h *ActuatorHandler) GetActuators(c *gin.Context){
	actuators, err := h.actuatorService.GetAllActuators()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data aktuator"})
		return	

	}
	c.JSON(http.StatusOK, gin.H{"data": actuators})
}


// PostCommand menangani POST /api/v1/actuators/:actuator_id/command
func (h *ActuatorHandler) PostCommand(c *gin.Context){
	actuatorID, err := strconv.Atoi(c.Param("actuator_id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ID aktuator tidak valid"})
		return
	}

	var reqBody struct{
		Command string `json:"command" binding:"required"`
		DurationMinutes *int   `json:"duration_minutes"`
	}

	if err := c.ShouldBindJSON(&reqBody); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.actuatorService.ProcessCommand(actuatorID, reqBody.Command, reqBody.DurationMinutes)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memproses perintah"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Perintah berhasil dikirim"})
}