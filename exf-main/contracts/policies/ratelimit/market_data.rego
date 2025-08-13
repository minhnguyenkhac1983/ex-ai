package exf.ratelimit.marketdata

default limit = 10

# Ví dụ đơn giản: mỗi member tối đa 100 req/s theo endpoint
limit = l {
  endpoint := input.path
  member := input.claims.member_id
  # tra bảng cấu hình extern (mock):
  some _
  l := 100
}


