FROM golang:1.22-alpine AS build
WORKDIR /src
COPY go.mod .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/worker .

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /out/worker /app/worker
ENV TEMPORAL_ADDRESS=temporal:7233
CMD ["/app/worker"]


