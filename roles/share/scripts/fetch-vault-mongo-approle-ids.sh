root@tableTopNode1:/mnt/mongo/vault/scripts# sudo cat fetch-vault-one-time-token.sh
#!/bin/bash

set -euo pipefail

# Unique info about this VM
VM_ID=$(hostname)
VM_IP=$(hostname -I | awk '{print $1}')
PURPOSE="Get role_id and secret_id for mongodb secrets"
POLICIES='["default","mongo-1-approle-reader"]'
NUM_USES=2

# Make request to approval server
echo "[INFO] Requesting approval from vault approver..."
RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"id\":\"${VM_ID}\", \
       \"ip\":\"${VM_IP}\", \
       \"purpose\":\"${PURPOSE}\", \
       \"policies\":${POLICIES}, \
       \"num_uses\":${NUM_USES}}" \
  https://192.168.1.48:4242/request)

REQUEST_ID=$(echo "$RESPONSE" | jq -r .request_id)

if [[ -z "$REQUEST_ID" || "$REQUEST_ID" == "null" ]]; then
  echo "[ERROR] Failed to get request_id"
  exit 1
fi

# poll for approval
while true; do
  STATUS_RESPONSE=$(curl -s "https://192.168.1.48:4242/request-status?id=${REQUEST_ID}")
  STATUS=$(echo "$STATUS_RESPONSE" | jq -r .status)

  if [[ "$STATUS" == "approved" ]]; then
    VAULT_TOKEN=$(echo "$STATUS_RESPONSE" | jq -r .vault_token)

    # get role_id and secret_id from Vault
    ROLE_ID=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" \
      https://192.168.1.48:8200/v1/auth/approle/role/mongo-1/role-id | jq -r .data.role_id)

    SECRET_ID=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" \
      --request POST \
      https://192.168.1.48:8200/v1/auth/approle/role/mongo-1/secret-id | jq -r .data.secret_id)

    if [[ -z "$ROLE_ID" || -z "$SECRET_ID" ]]; then
      echo "[ERROR] Could not get role_id/secret_id from Vault."
      exit 1
    fi

    # Replace these placeholders with actual values or export them at the top
    echo "$ROLE_ID" | sudo tee /mnt/mongo/certs/secrets/role_id > /dev/null
    echo "$SECRET_ID" | sudo tee /mnt/mongo/certs/secrets/secret_id > /dev/null
    chown mongodb:mongodbcerts /mnt/mongo/certs/secrets/role_id
    chown mongodb:mongodbcerts /mnt/mongo/certs/secrets/secret_id
    chmod 0600 /mnt/mongo/certs/secrets/role_id /mnt/mongo/certs/secrets/secret_id

    echo "[INFO] Starting vault-agent service..."
    systemctl start vault-agent
    exit 0
  fi

  echo "[INFO] Waiting for approval..."
  sleep 2
done
