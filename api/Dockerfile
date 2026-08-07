FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod download
RUN go build -o api-service .

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /app/api-service .

EXPOSE 8080

CMD ["./api-service"]