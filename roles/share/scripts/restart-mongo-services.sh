#!/bin/bash

# Fix ownership of rendered certs
for file in mongodb.pem mongodb-keyfile; do
  sudo chown mongodb:{{ mongo_certs_group }} "{{ mongo_base_dir }}/certs/secrets/$file"
done

# Restart MongoDB services
for svc in mongod-configsvr mongos mongod-shardsvr; do
  systemctl list-units --full -all "$svc.service" | grep -Fq loaded && systemctl restart "$svc"
done