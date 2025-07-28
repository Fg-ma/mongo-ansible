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
  capabilities = ["create", "update", "delete", "list"]
}

path "secret/metadata/mongo/*" {
  capabilities = ["delete", "list"]
}

path "secret/data/mongos/" {
  capabilities = ["list"]
}

path "secret/data/mongos/*" {
  capabilities = ["create", "update", "delete", "list"]
}

path "secret/metadata/mongos/*" {
  capabilities = ["delete", "list"]
}

# PKI Engine Access
path "pki/roles/*" {
  capabilities = ["create", "update", "read", "list"]
}
path "pki/issue/*" {
  capabilities = ["create", "update", "read", "list"]
}
path "pki/sign/*" {
  capabilities = ["create", "update"]
}
path "pki/revoke" {
  capabilities = ["update"]
}
path "pki/certs/*" {
  capabilities = ["read", "list"]
}
path "pki/issuers" {
  capabilities = ["read", "list"]
}
path "pki/keys/*" {
  capabilities = ["read", "list"]
}

# Allow modifying PKI configuration if needed
path "pki/config/*" {
  capabilities = ["read", "update"]
}

path "roles/*" {
  capabilities = ["create", "update", "read", "list"]
}
