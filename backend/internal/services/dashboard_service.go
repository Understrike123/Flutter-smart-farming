package services

import (
	"flutter-smart-farming/backend/internal/models"
	"flutter-smart-farming/backend/internal/repositories"
	"log"
)

type DashboardService interface {
	GetDashboardSummary() (*models.DashboardSummary, error)
}

type dashboardService struct {
	sensorRepo       repositories.SensorRepository
	actuatorRepo     repositories.ActuatorRepository
	notificationRepo repositories.NotificationRepository
}

// NewDashboardService membuat instance baru dari dashboardService.
func NewDashboardService(
	sensorRepo repositories.SensorRepository,
	actuatorRepo repositories.ActuatorRepository,
	notificationRepo repositories.NotificationRepository,
) DashboardService {
	return &dashboardService{
		sensorRepo:       sensorRepo,
		actuatorRepo:     actuatorRepo,
		notificationRepo: notificationRepo,
	}
}

// GetDashboardSummary mengumpulkan semua data yang dibutuhkan untuk dasbor.
func (s *dashboardService) GetDashboardSummary() (*models.DashboardSummary, error) {
	log.Println("INFO: DashboardService: Memulai pengambilan data ringkasan dasbor.")

	// Panggil semua repository secara paralel untuk efisiensi (menggunakan goroutine)
	errChan := make(chan error, 3)
	sensorChan := make(chan []models.Sensor)
	actuatorChan := make(chan []models.Actuator)
	notificationChan := make(chan []models.AppNotification)

	go func() {
		sensors, err := s.sensorRepo.FindAll()
		if err != nil {
			errChan <- err
			return
		}
		sensorChan <- sensors
	}()

	go func() {
		actuators, err := s.actuatorRepo.FindAll()
		if err != nil {
			errChan <- err
			return
		}
		actuatorChan <- actuators
	}()

	go func() {
		// Ambil 5 notifikasi terbaru
		notifications, err := s.notificationRepo.FindLatest(5)
		if err != nil {
			errChan <- err
			return
		}
		notificationChan <- notifications
	}()

	// Tunggu semua goroutine selesai dan kumpulkan hasilnya
	var summary models.DashboardSummary
	var errs []error

	for i := 0; i < 3; i++ {
		select {
		case sensors := <-sensorChan:
			summary.CurrentSensors = sensors
		case actuators := <-actuatorChan:
			summary.ActuatorStatus = actuators
		case notifications := <-notificationChan:
			summary.LatestNotifications = notifications
		case err := <-errChan:
			errs = append(errs, err)
		}
	}

	if len(errs) > 0 {
		log.Printf("ERROR: Terjadi kesalahan saat mengambil data dasbor: %v", errs[0])
		return nil, errs[0]
	}

	log.Println("INFO: DashboardService: Berhasil mengambil semua data ringkasan dasbor.")
	return &summary, nil
}

