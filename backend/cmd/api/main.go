// cmd/api/main.go
package main

import (
	"log"
	"os"
	"smart_farming_backend/internal/config"
	"smart_farming_backend/internal/handlers"
	"smart_farming_backend/internal/repositories"
	"smart_farming_backend/internal/services"

	"github.com/gin-gonic/gin"
)

func main() {
	// 1. Muat environment variables dari .env
	config.LoadEnv()

	// 2. Hubungkan ke database
	db, err := config.ConnectDatabase()
	if err != nil {
		log.Fatalf("FATAL: Gagal terhubung ke database: %v", err)
	}
	defer db.Close()
	log.Println("INFO: Berhasil terhubung ke database.")

	// 3. Inisialisasi semua lapisan (dependency injection)
	// Repository -> Service -> Handler
	userRepo := repositories.NewUserRepository(db)
	userService := services.NewUserService(userRepo)
	userHandler := handlers.NewUserHandler(userService)

	// 4. Setup router menggunakan Gin
	router := gin.Default()

	// Grouping routes
	api := router.Group("/api/v1")
	{
		users := api.Group("/users")
		{
			// Pastikan tidak ada karakter aneh atau salah ketik di baris ini
			users.POST("/register", userHandler.RegisterUser)
			// Tambahkan endpoint lain di sini (login, get profile, dll)
		}
	}

	// 5. Jalankan server
	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080" // Default port
	}

	log.Printf("INFO: Server berjalan di http://localhost:%s", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("FATAL: Gagal menjalankan server: %v", err)
	}
}
