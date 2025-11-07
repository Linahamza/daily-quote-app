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

# Sauvegarder le PID de Gunicorn
GUNICORN_PID=$!

# Attendre que Gunicorn démarre
echo "⏳ Attente du démarrage de Gunicorn (PID: $GUNICORN_PID)..."
sleep 5

# Vérifier que le processus Gunicorn existe encore
if ! kill -0 $GUNICORN_PID 2>/dev/null; then
    echo "❌ ERREUR: Gunicorn s'est arrêté (PID $GUNICORN_PID)"
    echo "📋 Processus actifs :"
    ps aux
    exit 1
fi

echo "✅ Gunicorn démarré avec succès (PID: $GUNICORN_PID)"

# 2. Démarrer Nginx en avant-plan
echo "🌐 Démarrage de Nginx (port 80)..."
echo "================================================"
echo "✨ Application prête !"
echo "📡 API accessible sur http://localhost"
echo "================================================"

# Lancer Nginx (bloque le script, garde le container actif)
exec nginx -g 'daemon off;'