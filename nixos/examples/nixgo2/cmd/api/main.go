package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	// Create an HTTP server
	server := &http.Server{Addr: ":8080"}

	// Channel to listen for shutdown signals
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt, syscall.SIGTERM)

	// Channel to trigger shutdown from the /stop endpoint
	stopServer := make(chan struct{})

	// Handle requests
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello, World!")
	})

	http.HandleFunc("/stop", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Server shutting down...")
		close(stopServer) // Signal server shutdown
	})

	// Run server in a separate goroutine
	go func() {
		fmt.Println("Server is running on http://localhost:8080")
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			fmt.Printf("Error starting server: %v\n", err)
		}
	}()

	// Wait for an interrupt signal or stop request
	select {
	case <-stop:
	case <-stopServer:
	}

	fmt.Println("\nShutting down server...")

	// Create a context with timeout for shutdown
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Shutdown the server gracefully
	if err := server.Shutdown(ctx); err != nil {
		fmt.Printf("Server forced to shutdown: %v\n", err)
	}

	fmt.Println("Server stopped")
}
