#!/bin/bash

# Récupération de l'IP passée en argument par GitHub Actions
TARGET_IP=$1
KEYWORD="Mission Accomplie"

# Vérification qu'une IP est bien fournie
if [ -z "$TARGET_IP" ]; then
    echo "❌ ERREUR: Aucune IP fournie."
    echo "Usage: ./check_functional.sh <ADRESSE_IP>"
    exit 1
fi

URL="http://$TARGET_IP"
echo "🔍 Test fonctionnel en cours sur : $URL"

# Test de connexion avec timeout de 10s pour éviter de bloquer
if curl -s --connect-timeout 10 "$URL" | grep -q "$KEYWORD"; then
    echo "✅ SUCCÈS: Le site est accessible et contient '$KEYWORD'."
    exit 0
else
    echo "❌ ECHEC: Chaîne '$KEYWORD' introuvable ou site inaccessible."
    echo "--- Début du contenu reçu ---"
    curl -s --connect-timeout 10 "$URL" | head -n 10
    echo "--- Fin de l'extrait ---"
    exit 1
fi