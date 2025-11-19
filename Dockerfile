FROM golang:1.21-alpine AS builder
RUN apk add --no-cache git
WORKDIR /app
COPY go.mod ./
COPY ip2country.go ./
RUN go mod tidy && go mod download
COPY GeoLite2-City.mmdb ./
RUN go build -o ip2country ip2country.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/ip2country .
COPY --from=builder /app/GeoLite2-City.mmdb .
EXPOSE 8080
CMD ["./ip2country"]

