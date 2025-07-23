path "sys/policies/acl/*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}

path "auth/approle/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/mongo/admin" {
  capabilities = ["read"]
}

path "secret/data/tableTop/ca.pem" {
  capabilities = ["read"]
}

path "secret/data/tableTop/ca.key" {
  capabilities = ["read"]
}

path "secret/data/mongo/" {
  capabilities = ["list"]
}

path "secret/data/mongo/*" {
  capabilities = ["create", "update"]
}