# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY src/go.mod src/go.sum ./

RUN go mod download

COPY src/ .

RUN CGO_ENABLED=0 GOOS=linux go build -o api .

# Runtime stage
FROM alpine:3.22

WORKDIR /app

RUN adduser -D appuser

COPY --from=builder /app/api .

USER appuser

EXPOSE 8080

CMD ["./api"]
