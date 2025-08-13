env "local" {
  url     = "postgres://postgres:postgres@localhost:5432/exchange_dev?sslmode=disable"
  dev_url = "docker://postgres/latest"
  migration {
    dir = "file://migrations"
  }
}


