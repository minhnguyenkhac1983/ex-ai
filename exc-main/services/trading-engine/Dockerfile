FROM golang:1.22-alpine AS build
WORKDIR /src
COPY . .
RUN apk add --no-cache git ca-certificates \
    && go mod download \
    && CGO_ENABLED=0 go build -o /out/trading ./cmd

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /out/trading /app/trading
EXPOSE 8080
CMD ["/app/trading"]
