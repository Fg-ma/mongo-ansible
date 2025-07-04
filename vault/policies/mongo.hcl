path "auth/approle/login" {
  capabilities = ["create", "read"]
}

path "secret/data/mongo/mongodb.pem" {
  capabilities = ["read"]
}

path "secret/data/mongo/mongodb-keyfile" {
  capabilities = ["read"]
}
