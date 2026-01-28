#!/bin/bash
# tests/check_security.sh
source $(dirname "$0")/config.sh

echo "Test sécurité sur $TARGET_URL..."

# Vérifier la présence du header X-Content-Type-Options
HEADER_CHECK=$(curl -s -I "$TARGET_URL" | grep -i "X-Content-Type-Options: nosniff")

if [ -z "$HEADER_CHECK" ]; then
    echo " ECHEC: Header de sécurité 'X-Content-Type-Options' manquant"
    exit 1
fi

echo " SUCCES: Header de sécurité présent."
exit 0