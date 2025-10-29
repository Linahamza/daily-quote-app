"""
Configuration de l'application Daily Quote
"""

import os

class Config:
    """Configuration de base"""
    
    # Sécurité Flask
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-prod'
    
    # API externe (HTTP car HTTPS bloqué)
    QUOTABLE_API_URL = 'http://api.quotable.io'
    
    # Serveur
    HOST = '0.0.0.0'
    PORT = 5000
    
    # Timeout API (secondes)
    API_TIMEOUT = 10