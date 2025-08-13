package exf.authz.trading

default allow = false

# Input shape suggestion:
# input.method, input.path, input.claims (sub, roles, member_id), input.body

allow {
  some role
  role := input.claims.roles[_]
  role == "trader"
  input.method == "POST"
  startswith(input.path, "/orders")
}

allow {
  some role
  role := input.claims.roles[_]
  role == "trader"
  input.method == "PATCH"
  startswith(input.path, "/orders/")
}

allow {
  some role
  role := input.claims.roles[_]
  role == "trader"
  input.method == "DELETE"
  startswith(input.path, "/orders/")
}

allow {
  some role
  role := input.claims.roles[_]
  role == "viewer"
  input.method == "GET"
  startswith(input.path, "/orders/")
}


