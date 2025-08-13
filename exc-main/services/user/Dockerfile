FROM golang:1.22-alpine AS build
WORKDIR /src
COPY . .
RUN apk add --no-cache git ca-certificates \
    && go mod tidy \
    && CGO_ENABLED=0 go build -o /out/user ./cmd

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /out/user /app/user
EXPOSE 8080
CMD ["/app/user"]


