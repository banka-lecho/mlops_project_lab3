#!/bin/sh
# Поднимает dev-сервер Vault и применяет вшитый в образ скрипт инициализации.
set -e

# Фоновая задача: дождаться готовности API и залить секреты из /seed.sh
# (сам скрипт скопирован в образ на этапе сборки, см. Dockerfile).
(
  export VAULT_ADDR=http://127.0.0.1:8200 VAULT_TOKEN=root
  until vault status >/dev/null 2>&1; do sleep 1; done
  sh /seed.sh
) &

exec vault server -dev \
  -dev-root-token-id=root \
  -dev-listen-address=0.0.0.0:8200
