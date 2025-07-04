path "auth/approle/role/mongo/role-id" {
  capabilities = ["read"]
}

path "auth/approle/role/mongo/secret-id" {
  capabilities = ["update"]
}
