package handlers

import (
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"flutter-smart-farming/backend/internal/services"
)

type SensorHandler struct {
	service services.SensorService
}

func NewSensorHandler(s services.SensorService) *SensorHandler {
	return &SensorHandler{service: s}
}

// GET /sensors
func (h *SensorHandler) GetSensors(c *gin.Context) {
	sensors, err := h.service.GetAllSensors()
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, sensors)
}

// GET /sensors/:sensor_id/readings
func (h *SensorHandler) GetSensorReadings(c *gin.Context) {
	idStr := c.Param("sensor_id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "ID sensor tidak valid"})
		return
	}

	reading, err := h.service.GetLatestReading(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Gagal mengambil data pembacaan"})
		return
	}
	if reading == nil {
		c.JSON(http.StatusNotFound, ErrorResponse{Error: "Data pembacaan tidak ditemukan"})
		return
	}
	c.JSON(http.StatusOK, reading)
}

// GET /sensors/:sensor_id/history
func (h *SensorHandler) GetSensorHistory(c *gin.Context) {
	idStr := c.Param("sensor_id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "ID sensor tidak valid"})
		return
	}

	// Default rentang waktu: 24 jam terakhir
	endTime := time.Now()
	startTime := endTime.Add(-24 * time.Hour)

	// Cek jika ada query parameter
	if startQuery, ok := c.GetQuery("start_time"); ok {
		startTime, err = time.Parse(time.RFC3339, startQuery)
		if err != nil {
			c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Format start_time salah, gunakan format ISO 8601"})
			return
		}
	}
	if endQuery, ok := c.GetQuery("end_time"); ok {
		endTime, err = time.Parse(time.RFC3339, endQuery)
		if err != nil {
			c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Format end_time salah, gunakan format ISO 8601"})
			return
		}
	}

	history, err := h.service.GetSensorHistory(id, startTime, endTime)
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Gagal mengambil riwayat data"})
		return
	}

	c.JSON(http.StatusOK, history)
}
