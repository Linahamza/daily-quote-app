"""
Initialisation de l'application Flask
"""

from flask import Flask


def create_app():
    """
    Factory Pattern : Créer et configurer l'application Flask
    
    Returns:
        Flask: Instance de l'application configurée
    """
    # Créer l'instance Flask
    app = Flask(__name__)
    
    # Charger la configuration
    app.config.from_object('app.config.Config')
    
    # Enregistrer les routes (Blueprint)
    from app.routes import api
    app.register_blueprint(api)
    
    # Log de démarrage
    @app.route('/')
    def index():
        return {
            'message': 'Welcome to Daily Quote API',
            'endpoints': {
                'random_quote': '/api/quote',
                'quote_by_author': '/api/quote/author/<name>',
                'health': '/api/health'
            }
        }
    
    return app