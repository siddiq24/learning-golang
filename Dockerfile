# Stage 1: Build
FROM golang:1.23.3 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build static binary (wajib agar bisa jalan di Alpine)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .

# Stage 2: Run
FROM alpine:3.19

WORKDIR /app

# Copy binary
COPY --from=builder /app/server .

# Copy templates & static
COPY --from=builder /app/templates ./templates

# Pastikan binary bisa dieksekusi
RUN chmod +x /app/server

EXPOSE 8080

CMD ["./server"]
