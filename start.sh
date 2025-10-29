#!/bin/sh
# Script de démarrage pour le container Docker
# Lance Gunicorn et Nginx

set -e  # Arrêter si une commande échoue

echo "================================================"
echo "🚀 Démarrage de Daily Quote API"
echo "================================================"

# 1. Démarrer Gunicorn en arrière-plan
echo "📦 Démarrage de Gunicorn (port 8000)..."
gunicorn --bind 0.0.0.0:8000 \
         --workers 2 \
         --threads 2 \
         --timeout 60 \
         --access-logfile - \
         --error-logfile - \
         --log-level info \
         "app:create_app()" &

# Attendre que Gunicorn démarre
echo "⏳ Attente du démarrage de Gunicorn..."
sleep 3

# Vérifier que Gunicorn écoute
if ! nc -z 127.0.0.1 8000; then
    echo "❌ ERREUR: Gunicorn n'a pas démarré correctement"
    exit 1
fi

echo "✅ Gunicorn démarré avec succès"

# 2. Démarrer Nginx en avant-plan
echo "🌐 Démarrage de Nginx (port 80)..."
echo "================================================"
echo "✨ Application prête !"
echo "📡 API accessible sur http://localhost"
echo "================================================"

# Lancer Nginx (bloque le script, garde le container actif)
exec nginx -g 'daemon off;'