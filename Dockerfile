FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS builder

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=1 GOOS=linux GOARCH=$(go env GOARCH) go build -o /nudex-voter ./cmd

FROM --platform=$TARGETPLATFORM alpine:3.18

WORKDIR /app

RUN mkdir -p /app/db

COPY --from=builder /nudex-voter /app/nudex-voter

EXPOSE 8080 50051 4001

CMD ["/app/nudex-voter"]