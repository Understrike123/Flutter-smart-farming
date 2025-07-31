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
)

func main() {
	config.LoadEnv()
	db, err := config.ConnectDatabase()
	if err != nil {
		log.Fatalf("FATAL: Gagal terhubung ke database: %v", err)
	}
	defer db.Close()
	log.Println("INFO: Berhasil terhubung ke database.")

	// --- Inisialisasi semua dependencies ---
	userRepo := repositories.NewUserRepository(db)
	userService := services.NewUserService(userRepo)
	userHandler := handlers.NewUserHandler(userService)

	sensorRepo := repositories.NewSensorRepository(db)
	sensorService := services.NewSensorService(sensorRepo)
	sensorHandler := handlers.NewSensorHandler(sensorService)
	
	// (Inisialisasi untuk actuator, dashboard, dll. akan ditambahkan di sini nanti)

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
			// Rute untuk Sensor
			sensors := protected.Group("/sensors")
			{
				sensors.GET("", sensorHandler.GetSensors) // Mengganti "/" menjadi ""
				sensors.GET("/:sensor_id/readings", sensorHandler.GetSensorReadings)
				sensors.GET("/:sensor_id/history", sensorHandler.GetSensorHistory) // <-- Rute baru
			}

			// (Rute untuk Aktuator, Dashboard, dll. akan ditambahkan di sini nanti)
		}
	}

	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("INFO: Server berjalan di http://localhost:%s", port)
	router.Run(":" + port)
}
