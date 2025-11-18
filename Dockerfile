
FROM golang:1.23.3 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .

FROM alpine:3.19

WORKDIR /app

COPY --from=builder /app/server .

COPY --from=builder /app/api/templates ./api/templates

RUN chmod +x /app/server

EXPOSE 8080

CMD ["./server"]
