package main

import (
	"flutter-smart-farming/backend/internal/config"
	"flutter-smart-farming/backend/internal/handlers"
	"flutter-smart-farming/backend/internal/middleware"
	"flutter-smart-farming/backend/internal/repositories"
	"flutter-smart-farming/backend/internal/services"
	"log"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Muat environment variables dari file .env
	if err := godotenv.Load(); err != nil {
		log.Println("INFO: Tidak ada file .env, menggunakan environment variables sistem.")
	}
	db, err := config.ConnectDatabase()
	if err != nil {
		log.Fatalf("FATAL: Gagal terhubung ke database: %v", err)
	}
	defer db.Close()
	log.Println("INFO: Berhasil terhubung ke database.")

	// --- Inisialisasi semua dependencies ---
	// Lapisan Repository (berinteraksi dengan DB)
	// Lapisan Service (logika bisnis)
	// Lapisan Handler (menangani HTTP request)

	// inisiasi users 
	userRepo := repositories.NewUserRepository(db)
	userService := services.NewUserService(userRepo)
	userHandler := handlers.NewUserHandler(userService)

	// inisiasi sensors
	sensorRepo := repositories.NewSensorRepository(db)
	sensorService := services.NewSensorService(sensorRepo)
	sensorHandler := handlers.NewSensorHandler(sensorService)
	
	// Inisialisasi untuk Actuator dan Notifikasi
	actuatorRepo := repositories.NewActuatorRepository(db)
	actuatorService := services.NewActuatorService(actuatorRepo)
	actuatorHandler := handlers.NewActuatorHandler(actuatorService)

	// Inisialisasi untuk Notifikasi
	notificationRepo := repositories.NewNotificationRepository(db)
	notificationService := services.NewNotificationService(notificationRepo)
	notificationHandler := handlers.NewNotificationHandler(notificationService)

	// Inisialisasi untuk Dashboard
	dashboardService := services.NewDashboardService(sensorRepo, actuatorRepo, notificationRepo)
	dashboardHandler := handlers.NewDashboardHandler(dashboardService)

	// Inisialisasi untuk Pengaturan
	settingsRepo := repositories.NewSettingsRepository(db)
	settingsService := services.NewSettingsService(settingsRepo)
	settingsHandler := handlers.NewSettingsHandler(settingsService)

	// --- Setup Router ---
	router := gin.Default()

	// konfigurasi CORS ORIGIN ke aplikasi flutter
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowHeaders = []string{"Origin", "Content-Type", "Content-Type", "Authorization"}
	router.Use(cors.New(config))

	
	api := router.Group("/api/v1")
	{
		// Grup untuk Auth (tidak perlu token)
		auth := api.Group("/auth")
		{
			auth.POST("/register", userHandler.RegisterUser)
			auth.POST("/login", userHandler.Login)
		}

		// Grup untuk endpoint yang terproteksi
		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware()) // Terapkan middleware di sini
		{
			protected.GET("/dashboard", dashboardHandler.GetDashboardSummary)
			
			// Rute untuk Sensor
			sensors := protected.Group("/sensors")
			{
				sensors.GET("", sensorHandler.GetSensors) // Mengganti "/" menjadi ""
				sensors.POST("", sensorHandler.CreateSensor)
				sensors.GET("/:sensor_id/readings", sensorHandler.GetSensorReadings)
				sensors.GET("/:sensor_id/history", sensorHandler.GetSensorHistory) 
			}

			// Rute unruk Actuator
			actuators := protected.Group("/actuators")
			{
				actuators.GET("", actuatorHandler.GetActuators)
				actuators.POST("", actuatorHandler.CreateActuator)
				actuators.POST("/:actuator_id/command", actuatorHandler.PostCommand)
			}

			// Rute untuk Notifikasi
			notifications := protected.Group("/notifications")
			{
				notifications.GET("", notificationHandler.GetNotifications)
				notifications.PUT("/:notification_id/read", notificationHandler.MarkNotificationRead)
			}
			settings := protected.Group("/settings")
			{
				settings.GET("", settingsHandler.GetSettings)
				settings.PUT("", settingsHandler.UpdateSettings)
			}
		}
		// menjalankan server
		port := os.Getenv("SERVER_PORT")
		if port == "" {
			port = "8080"
		}
		log.Printf("INFO: Server berjalan di http://localhost:%s", port)
		if err := router.Run(":" + port); err != nil {
			log.Fatalf("FATAL: Gagal menjalankan server: %v", err)
		}
	}
}
