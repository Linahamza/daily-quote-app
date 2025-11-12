# 📖 Daily Quote API

API REST qui fournit des citations inspirantes aléatoires.

<!-- Badges de statut CI/CD -->
![CI/CD Pipeline](https://github.com/Linahamza/daily-quote-app/workflows/CI%2FCD%20Pipeline/badge.svg)
![Docker Image Size](https://img.shields.io/docker/image-size/linahamza/daily-quote/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/linahamza/daily-quote)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

<!-- Badges SonarCloud -->
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Linahamza_daily-quote-app&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Linahamza_daily-quote-app)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=Linahamza_daily-quote-app&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=Linahamza_daily-quote-app)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=Linahamza_daily-quote-app&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=Linahamza_daily-quote-app)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=Linahamza_daily-quote-app&metric=bugs)](https://sonarcloud.io/summary/new_code?id=Linahamza_daily-quote-app)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=Linahamza_daily-quote-app&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=Linahamza_daily-quote-app)

<!-- Badges de technologies existants -->
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

## 🎯 Projet DevOps - TP Complet

Ce projet fait partie d'un TP DevOps couvrant :
- ✅ **PARTIE 1** : Application Flask REST API
- ✅ **PARTIE 2** : Dockerisation avec Nginx
- ✅ **PARTIE 3** : Pipeline CI/CD avec GitHub Actions (Gitleaks + SonarCloud + Trivy)
- ⏭️ **PARTIE 4** : Déploiement sur Kubernetes

## 🚀 Fonctionnalités

- 🎲 Citations aléatoires depuis [Quotable.io](https://quotable.io)
- 👤 Citations par auteur spécifique
- ✅ Health check endpoint (pour Kubernetes)
- 🐳 Dockerisé avec Nginx + Gunicorn
- 🔒 Multi-stage build (image Alpine 120 MB)
- 🛡️ Container non-root (sécurité)
- 🔐 Pipeline CI/CD automatisé (scan de sécurité multi-couches + build)

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
| **SonarCloud** | - | **Code quality + SAST** |
| Trivy | latest | Scan de vulnérabilités |

## 🔒 Pipeline de Sécurité Multi-Couches

Notre pipeline CI/CD implémente une stratégie **Defense in Depth** avec 4 couches de sécurité :

### Architecture du Pipeline

```
┌─────────────────────────────────────────────────┐
│        PIPELINE DE SÉCURITÉ COMPLET             │
├─────────────────────────────────────────────────┤
│                                                 │
│  1️⃣ Gitleaks       → Secrets hardcodés         │
│  2️⃣ SonarCloud     → Code bugs + SAST          │
│  3️⃣ Docker Build   → Image sécurisée           │
│  4️⃣ Trivy          → CVE dans dépendances      │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Détails des Scans

| Couche | Outil | Détecte | Bloque le Pipeline |
|--------|-------|---------|-------------------|
| **1. Secrets** | Gitleaks | API keys, tokens, passwords hardcodés | ✅ Oui |
| **2. Code Quality** | SonarCloud | Bugs, vulnerabilities (SAST), code smells, duplications | ✅ Oui (Quality Gate) |
| **3. Build** | Docker | Image optimisée et sécurisée | - |
| **4. Dependencies** | Trivy | CVE dans Flask, Gunicorn, packages Python | ⚠️ Warning |

### 🔍 Pourquoi SonarCloud ?

SonarCloud comble les **angles morts** non couverts par Gitleaks et Trivy :

- **Gitleaks** détecte les secrets hardcodés → ✅ mais pas les bugs dans le code
- **Trivy** détecte les CVE dans les dépendances → ✅ mais pas les failles dans VOTRE code
- **SonarCloud** analyse VOTRE code pour détecter :
  - 🐛 Bugs (null pointers, logic errors)
  - 🔓 Vulnérabilités (SQL injection, XSS, path traversal)
  - 🗑️ Code smells (dette technique, duplications)
  - 📊 Complexité cyclomatique excessive

**Exemple concret :**
```python
# ❌ Détecté par SonarCloud, IGNORÉ par Gitleaks/Trivy
@app.route('/quote/<author>')
def get_quote(author):
    query = f"SELECT * FROM quotes WHERE author = '{author}'"  # SQL Injection !
    db.execute(query)
```

**Badge de statut** : Les badges verts ✅ en haut du README indiquent que tous les scans passent !

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
docker build -t daily-quote:1.0.4 .

# Lancer le container
docker run -d -p 8080:80 --name daily-quote daily-quote:1.0.4

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
│       └── ci-cd.yml         # Pipeline CI/CD complet
├── app/
│   ├── __init__.py           # Factory Flask
│   ├── config.py             # Configuration
│   ├── routes.py             # Endpoints API
│   └── services.py           # Logique métier
├── k8s/                      # Manifestes Kubernetes
│   ├── deployment.yaml       # Deployment
│   └── service.yaml          # Service NodePort
├── nginx/
│   └── nginx.conf            # Configuration Nginx
├── tests/
│   ├── test_routes.py        # Tests des endpoints
│   └── test_services.py      # Tests des services
├── Dockerfile                # Multi-stage build
├── .dockerignore             # Fichiers à exclure
├── sonar-project.properties  # Configuration SonarCloud
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
- **SonarCloud Dashboard :** https://sonarcloud.io/dashboard?id=Linahamza_daily-quote-app
- **API Quotable.io :** https://github.com/lukePeavey/quotable
- **Documentation Flask :** https://flask.palletsprojects.com/

## 👤 Auteur

**LINA HAMZA**  
TP DevOps - 2025

## 📄 Licence

MIT