# 📖 Daily Quote API

API REST qui fournit des citations inspirantes aléatoires.

<!-- Badges de statut CI/CD -->
![CI/CD Pipeline](https://github.com/Linahamza/daily-quote-app/workflows/CI%2FCD%20Pipeline/badge.svg)
![Docker Image Size](https://img.shields.io/docker/image-size/linahamza/daily-quote/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/linahamza/daily-quote)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

<!-- Badges de technologies existants -->
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

## 🎯 Projet DevOps - TP Complet

Ce projet fait partie d'un TP DevOps couvrant :
- ✅ **PARTIE 1** : Application Flask REST API
- ✅ **PARTIE 2** : Dockerisation avec Nginx
- ✅ **PARTIE 3** : Pipeline CI/CD avec GitHub Actions (Gitleaks + Trivy)
- ⏭️ **PARTIE 4** : Déploiement sur Kubernetes
- ⏭️ **PARTIE 5** : GitOps avec ArgoCD

## 🚀 Fonctionnalités

- 🎲 Citations aléatoires depuis [Quotable.io](https://quotable.io)
- 👤 Citations par auteur spécifique
- ✅ Health check endpoint (pour Kubernetes)
- 🐳 Dockerisé avec Nginx + Gunicorn
- 🔒 Multi-stage build (image Alpine 120 MB)
- 🛡️ Container non-root (sécurité)
- 🔐 Pipeline CI/CD automatisé (scan de sécurité + build)

## 📡 Endpoints

### `GET /`
Documentation de l'API
```bash
curl http://localhost:8080/
```

### `GET /api/health`
Health check (utilisé par Kubernetes)
```bash
curl http://localhost:8080/api/health
```

**Réponse :**
```json
{
  "status": "healthy",
  "service": "daily-quote-api",
  "version": "1.0.0"
}
```

### `GET /api/quote`
Citation aléatoire
```bash
curl http://localhost:8080/api/quote
```

**Réponse :**
```json
{
  "quote": "The only way to do great work is to love what you do.",
  "author": "Steve Jobs",
  "tags": ["work", "inspirational"]
}
```

### `GET /api/quote/author/<name>`
Citation d'un auteur spécifique
```bash
curl http://localhost:8080/api/quote/author/Einstein
```

### `GET /api/authors`
Liste des auteurs disponibles
```bash
curl "http://localhost:8080/api/authors?limit=20"
```

## 🛠️ Stack Technique

| Technologie | Version | Rôle |
|-------------|---------|------|
| Python | 3.11 | Langage |
| Flask | 3.0.0 | Framework web |
| Gunicorn | 22.0.0 | Serveur WSGI |
| Nginx | latest | Reverse proxy |
| Docker | 24.x | Conteneurisation |
| Alpine Linux | 3.x | OS (base image) |
| GitHub Actions | - | CI/CD Pipeline |
| Gitleaks | 8.18.0 | Scan de secrets |
| Trivy | latest | Scan de vulnérabilités |

## 🔒 Sécurité et CI/CD

Ce projet utilise un pipeline CI/CD automatisé avec 3 étapes :

### 1️⃣ **Scan de sécurité (Gitleaks)**
- 🔍 Détecte les secrets dans le code
- 🚫 Bloque le pipeline si secrets trouvés
- ✅ README.md exclu du scan

### 2️⃣ **Build & Push Docker**
- 🐳 Build automatique de l'image Docker
- 📤 Push vers Docker Hub (tag `latest` + SHA)
- 🏷️ Métadonnées et labels automatiques

### 3️⃣ **Scan de vulnérabilités (Trivy)**
- 🛡️ Scan de l'image Docker
- ⚠️ Détecte les CVE CRITICAL et HIGH
- 📊 Résultats dans les logs GitHub Actions

**Badge de statut** : Le badge vert ✅ en haut du README indique que tous les scans passent !

## 📦 Installation et Démarrage

### Prérequis
- Docker Desktop installé
- Git

### Méthode 1 : Avec Docker Hub (Recommandé)
```bash
# Télécharger l'image depuis Docker Hub
docker pull linahamza/daily-quote:latest

# Lancer le container
docker run -d -p 8080:80 --name daily-quote linahamza/daily-quote:latest

# Tester
curl http://localhost:8080/api/health
```

### Méthode 2 : Build local
```bash
# Cloner le repository
git clone https://github.com/Linahamza/daily-quote-app.git
cd daily-quote-app

# Builder l'image
docker build -t daily-quote:1.0.2 .

# Lancer le container
docker run -d -p 8080:80 --name daily-quote daily-quote:1.0.2

# Voir les logs
docker logs -f daily-quote
```

### Méthode 3 : Développement local (sans Docker)
```bash
# Créer un environnement virtuel
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Installer les dépendances
pip install -r requirements-dev.txt

# Lancer l'application
python main.py

# Accessible sur http://localhost:5000
```

## 🏗️ Architecture
```
┌─────────────────────────────────────────┐
│         CONTAINER DOCKER                │
│                                         │
│  ┌─────────────────┐                   │
│  │     NGINX       │ Port 80           │
│  │  (Reverse Proxy)│ ← Entrée publique │
│  └────────┬────────┘                   │
│           │                             │
│           │ Proxy vers                  │
│           ▼                             │
│  ┌─────────────────┐                   │
│  │  GUNICORN       │ Port 8000         │
│  │  (WSGI Server)  │ ← Interne         │
│  │  2 workers      │                   │
│  └────────┬────────┘                   │
│           │                             │
│           │ Appelle                     │
│           ▼                             │
│  ┌─────────────────┐                   │
│  │  FLASK APP      │                   │
│  │  (daily-quote)  │                   │
│  └────────┬────────┘                   │
│           │                             │
│           │ API externe                 │
│           ▼                             │
│    Quotable.io API                     │
└─────────────────────────────────────────┘
```

## 📁 Structure du Projet
```
daily-quote-app/
├── .github/
│   └── workflows/
│       └── ci-cd.yml         # Pipeline CI/CD
├── app/
│   ├── __init__.py           # Factory Flask
│   ├── config.py             # Configuration
│   ├── routes.py             # Endpoints API
│   └── services.py           # Logique métier
├── nginx/
│   └── nginx.conf            # Configuration Nginx
├── tests/
│   ├── test_routes.py        # Tests des endpoints
│   └── test_services.py      # Tests des services
├── Dockerfile                # Multi-stage build
├── .dockerignore             # Fichiers à exclure
├── start.sh                  # Script de démarrage
├── requirements.txt          # Dépendances production
├── requirements-dev.txt      # Dépendances développement
├── main.py                   # Point d'entrée
└── README.md                 # Documentation
```

## 🧪 Tests
```bash
# Lancer tous les tests
pytest

# Avec couverture
pytest --cov=app --cov-report=html

# Ouvrir le rapport
open htmlcov/index.html
```

## 🐳 Bonnes Pratiques Docker Appliquées

- ✅ Multi-stage build (image finale légère)
- ✅ Image Alpine (120 MB)
- ✅ User non-root (sécurité)
- ✅ Health checks (monitoring)
- ✅ .dockerignore (optimisation build)
- ✅ Labels (métadonnées)
- ✅ Logs vers stdout (12-factor app)

## 🔗 Liens Utiles

- **Docker Hub :** https://hub.docker.com/r/linahamza/daily-quote
- **GitHub Actions :** https://github.com/Linahamza/daily-quote-app/actions
- **API Quotable.io :** https://github.com/lukePeavey/quotable
- **Documentation Flask :** https://flask.palletsprojects.com/

## 👤 Auteur

**LINA HAMZA**  
TP DevOps - 2025

## 📄 Licence

MIT