FROM golang:1.22-alpine AS build
WORKDIR /src
COPY . .
RUN apk add --no-cache git ca-certificates \
    && go mod tidy \
    && CGO_ENABLED=0 go build -o /out/wallet ./cmd

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /out/wallet /app/wallet
EXPOSE 8080
CMD ["/app/wallet"]


