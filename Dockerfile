# =============================================================================
# STAGE 1 : BUILDER
# Image temporaire pour installer les dépendances
# =============================================================================
FROM python:3.11-alpine AS builder

# Métadonnées
LABEL stage=builder

# Installer les dépendances de build
RUN apk add --no-cache \
    gcc \
    musl-dev \
    linux-headers

# Créer un environnement virtuel
RUN python -m venv /opt/venv

# Activer le venv
ENV PATH="/opt/venv/bin:$PATH"

# Copier uniquement requirements.txt (layer caching)
COPY requirements.txt .

# Installer les dépendances Python dans le venv
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# =============================================================================
# STAGE 2 : RUNNER
# Image finale légère pour la production
# =============================================================================
FROM python:3.11-alpine

# Métadonnées de l'image
LABEL maintainer="lina94.hamza@gmail.com" \
      version="1.0.0" \
      description="Daily Quote API with Flask, Gunicorn and Nginx"

# Installer les dépendances runtime
RUN apk add --no-cache \
    nginx \
    netcat-openbsd \
    curl

# Copier le venv depuis le builder
COPY --from=builder /opt/venv /opt/venv

# Activer le venv
ENV PATH="/opt/venv/bin:$PATH"

# Créer un utilisateur non-root (sécurité)
RUN adduser -D -u 1000 appuser && \
    mkdir -p /var/log/nginx /var/lib/nginx/tmp && \
    chown -R appuser:appuser /var/log/nginx /var/lib/nginx

# Définir le répertoire de travail
WORKDIR /app

# Copier le code de l'application
COPY --chown=appuser:appuser app/ ./app/
COPY --chown=appuser:appuser main.py ./

# Copier la configuration Nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copier le script de démarrage
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exposer le port 80 (Nginx)
EXPOSE 80

# Passer à l'utilisateur non-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Point d'entrée
CMD ["/start.sh"]